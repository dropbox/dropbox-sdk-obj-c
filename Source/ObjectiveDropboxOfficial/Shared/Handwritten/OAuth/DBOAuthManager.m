///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthManager.h"

#import "DBOAuthPKCESession.h"
#import "DBOAuthResult.h"
#import "DBOAuthUtils.h"
#import "DBSDKConstants.h"
#import "DBSDKKeychain.h"
#import "DBSDKReachability.h"
#import "DBScopeRequest.h"
#import "DBSharedApplicationProtocol.h"

#pragma mark - Access token class

@implementation DBAccessToken

- (instancetype)initWithAccessToken:(NSString *)accessToken uid:(NSString *)uid {
  self = [super init];
  if (self) {
    _accessToken = accessToken;
    _uid = uid;
  }
  return self;
}

- (NSString *)description {
  return _accessToken;
}

@end

#pragma mark - OAuth manager base

@implementation DBOAuthManager

/// A shared instance of a `DBOAuthManager` for convenience
static DBOAuthManager *s_sharedOAuthManager;

#pragma mark - Shared instance accessors and mutators

+ (DBOAuthManager *)sharedOAuthManager {
  return s_sharedOAuthManager;
}

+ (void)setSharedOAuthManager:(DBOAuthManager *)sharedOAuthManager {
  s_sharedOAuthManager = sharedOAuthManager;
}

#pragma mark - Constructors

- (instancetype)initWithAppKey:(NSString *)appKey {
  return [self initWithAppKey:appKey host:nil];
}

- (instancetype)initWithAppKey:(NSString *)appKey host:(NSString *)host {
  return [self initWithAppKey:appKey host:host redirectURL:nil];
}

- (instancetype)initWithAppKey:(NSString *)appKey host:(NSString *)host redirectURL:(NSString *)redirectURL {
  self = [super init];
  if (self) {
    if (host == nil) {
      host = !kDBSDKDebug ? @"www.dropbox.com"
                          : [NSString stringWithFormat:@"meta-%@.dev.corp.dropbox.com", kDBSDKDebugHost];
    }

    _appKey = appKey;
    _redirectURL = [[NSURL alloc] initWithString:redirectURL ?: [NSString stringWithFormat:@"db-%@://2/token", appKey]];
    _cancelURL = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://2/cancel", _appKey]];
    _host = host;
    _urls = [NSMutableArray arrayWithObjects:_redirectURL, nil];
#ifdef TARGET_OS_X
    _disableSignup = NO;
#else
    _disableSignup = YES;
#endif
    _webAuthShouldForceReauthentication = NO;
  }
  return self;
}

#pragma mark - Auth flow methods

- (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  // check if url is a cancel url
  if (([[url host] isEqualToString:@"1"] && [[url path] isEqualToString:@"/cancel"]) ||
      ([[url host] isEqualToString:@"2"] && [[url path] isEqualToString:@"/cancel"])) {
    return [[DBOAuthResult alloc] initWithCancel];
  }

  if (![self canHandleURL:url]) {
    return nil;
  }

  DBOAuthResult *result = [self extractFromUrl:url];

  if ([result isSuccess]) {
    [DBSDKKeychain storeValueWithKey:result.accessToken.uid value:result.accessToken.accessToken];
  }

  return result;
}

- (void)authorizeFromSharedApplication:(id<DBSharedApplication>)sharedApplication {
    [self authorizeFromSharedApplication:sharedApplication usePkce:NO scopeRequest:nil];
}

- (void)authorizeFromSharedApplication:(id<DBSharedApplication>)sharedApplication
                               usePkce:(BOOL)usePkce
                          scopeRequest:(DBScopeRequest *)scopeRequest {
  void (^cancelHandler)(void) = ^{
    [sharedApplication presentExternalApp:self->_cancelURL];
  };

  if ([[DBSDKReachability reachabilityForInternetConnection] currentReachabilityStatus] == DBNotReachable) {
    NSString *message = NSLocalizedString(@"Try again once you have an internet connection.",
                                          @"Displayed when commencing authorization flow without internet connection.");
    NSString *title = NSLocalizedString(@"No internet connection",
                                        @"Displayed when commencing authorization flow without internet connection.");

    NSDictionary<NSString *, void (^)(void)> *buttonHandlers = @{
      @"Cancel" : ^{
        cancelHandler();
      },
      @"Retry" : ^{
        [self authorizeFromSharedApplication:sharedApplication usePkce:usePkce scopeRequest:scopeRequest];
      }
    };

    [sharedApplication presentErrorMessageWithHandlers:message title:title buttonHandlers:buttonHandlers];

    return;
  }

  if (![self conformsToAppScheme]) {
    NSString *message = [NSString stringWithFormat:@"DropboxSDK: unable to link; app isn't registered for correct URL "
                                                   @"scheme (db-%@). Add this scheme to your project Info.plist file, "
                                                   @"associated with following key: \"Information Property List\" > "
                                                   @"\"URL types\" > \"Item 0\" > \"URL Schemes\" > \"Item <N>\".",
                                                   _appKey];
    NSString *title = @"DropboxSDK Error";

    [sharedApplication presentErrorMessage:message title:title];

    return;
  }

  if (usePkce) {
    _authSession = [[DBOAuthPKCESession alloc] initWithScopeRequest:scopeRequest];
  } else {
    _authSession = nil;
  }

  NSURL *authUrl = [self authURL];

  if ([self checkAndPresentPlatformSpecificAuth:sharedApplication]) {
    return;
  }

  [sharedApplication presentAuthChannel:authUrl cancelHandler:cancelHandler];
}

- (BOOL)conformsToAppScheme {
  NSString *appScheme = [NSString stringWithFormat:@"db-%@", _appKey];

  NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"] ?: @[];

  for (NSDictionary *urlType in urlTypes) {
    NSArray<NSString *> *schemes = [urlType objectForKey:@"CFBundleURLSchemes"];
    for (NSString *scheme in schemes) {
      if ([scheme isEqualToString:appScheme]) {
        return YES;
      }
    }
  }
  return NO;
}

- (NSURL *)authURL {
  NSURLComponents *components = [[NSURLComponents alloc] init];
  components.scheme = @"https";
  components.host = _host;
  components.path = @"/oauth2/authorize";

  NSString *localeIdentifier = [[NSBundle mainBundle] preferredLocalizations].firstObject ?: @"en";

  NSMutableArray<NSURLQueryItem *> *queryItems = [@[
    [NSURLQueryItem queryItemWithName:@"client_id" value:_appKey],
    [NSURLQueryItem queryItemWithName:@"redirect_uri" value:_redirectURL.absoluteString],
    [NSURLQueryItem queryItemWithName:@"disable_signup" value:_disableSignup ? @"true" : @"false"],
    [NSURLQueryItem queryItemWithName:@"locale" value:[self.locale localeIdentifier] ?: localeIdentifier],
  ] mutableCopy];

  NSString *state = nil;
  if (_authSession) {
    // Code flow
    state = _authSession.state;
    [queryItems addObjectsFromArray:[DBOAuthUtils createPkceCodeFlowParamsForAuthSession:_authSession]];
  } else {
    // Token flow
    state = [[NSProcessInfo processInfo] globallyUniqueString];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"response_type" value:@"token"]];
    [queryItems addObject:[NSURLQueryItem queryItemWithName:@"state" value:state]];
  }
  // used to prevent malicious impersonation of app from web browser
  [[NSUserDefaults standardUserDefaults] setValue:state forKey:kDBSDKCSRFKey];

  [queryItems addObject:[NSURLQueryItem queryItemWithName:@"force_reauthentication"
                                                    value:_webAuthShouldForceReauthentication ? @"true" : @"false"]];
  components.queryItems = queryItems;
  NSURL *url = components.URL;
  NSAssert(url, @"Failed to create auth url.");
  return url;
}

- (BOOL)canHandleURL:(NSURL *)url {
  for (NSURL *known in _urls) {
    if ([url.scheme isEqualToString:known.scheme] && [url.host isEqualToString:known.host] &&
        [url.path isEqualToString:known.path]) {
      return YES;
    }
  }
  return NO;
}

- (DBOAuthResult *)extractFromRedirectURL:(NSURL *)url {
  NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
  NSArray *pairs = [[url fragment] componentsSeparatedByString:@"&"] ?: @[];

  for (NSString *pair in pairs) {
    NSArray *kv = [pair componentsSeparatedByString:@"="];
    [results setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
  }

  if (results[@"error"]) {
    NSString *desc = [[results[@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "]
                         stringByRemovingPercentEncoding]
                         ?: @"";

    if ([results[@"error"] isEqualToString:@"access_denied"]) {
      return [[DBOAuthResult alloc] initWithCancel];
    }
    return [[DBOAuthResult alloc] initWithError:results[@"error"] errorDescription:desc];
  } else {
    NSString *state = results[@"state"];
    NSString *storedState = [[NSUserDefaults standardUserDefaults] stringForKey:kDBSDKCSRFKey];

    if (state == nil || storedState == nil || ![state isEqualToString:storedState]) {
      return [[DBOAuthResult alloc] initWithError:@"inconsistent_state"
                                 errorDescription:@"Auth flow failed because of inconsistent state."];
    } else {
      // reset upon success
      [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kDBSDKCSRFKey];
    }

    NSString *uid = results[@"uid"];
    DBAccessToken *accessToken = [[DBAccessToken alloc] initWithAccessToken:results[@"access_token"] uid:uid];
    return [[DBOAuthResult alloc] initWithSuccess:accessToken];
  }
}

- (DBOAuthResult *)extractFromUrl:(NSURL *)url {
  return [self extractFromRedirectURL:url];
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id<DBSharedApplication>)sharedApplication {
#pragma unused(sharedApplication)
  return NO;
}

#pragma mark - Keychain methods

- (BOOL)storeAccessToken:(DBAccessToken *)accessToken {
  return [DBSDKKeychain storeValueWithKey:accessToken.uid value:accessToken.accessToken];
}

- (DBAccessToken *)retrieveFirstAccessToken {
  NSDictionary<NSString *, DBAccessToken *> *tokens = [self retrieveAllAccessTokens];
  NSArray *values = [tokens allValues];
  if ([values count] != 0) {
    return [values objectAtIndex:0];
  }
  return nil;
}

- (DBAccessToken *)retrieveAccessToken:(NSString *)tokenUid {
  NSString *accessToken = [DBSDKKeychain retrieveTokenWithKey:tokenUid];
  if (accessToken != nil) {
    return [[DBAccessToken alloc] initWithAccessToken:accessToken uid:tokenUid];
  } else {
    return nil;
  }
}

- (NSDictionary<NSString *, DBAccessToken *> *)retrieveAllAccessTokens {
  NSArray<NSString *> *users = [DBSDKKeychain retrieveAllTokenIds];
  NSMutableDictionary<NSString *, DBAccessToken *> *result = [[NSMutableDictionary alloc] init];
  for (NSString *user in users) {
    NSString *accessToken = [DBSDKKeychain retrieveTokenWithKey:user];
    if (accessToken != nil) {
      result[user] = [[DBAccessToken alloc] initWithAccessToken:accessToken uid:user];
    }
  }
  return result;
}

- (BOOL)hasStoredAccessTokens {
  return [self retrieveAllAccessTokens].count != 0;
}

- (BOOL)clearStoredAccessToken:(NSString *)tokenUid {
  return [DBSDKKeychain deleteTokenWithKey:tokenUid];
}

- (BOOL)clearStoredAccessTokens {
  return [DBSDKKeychain clearAllTokens];
}

@end
