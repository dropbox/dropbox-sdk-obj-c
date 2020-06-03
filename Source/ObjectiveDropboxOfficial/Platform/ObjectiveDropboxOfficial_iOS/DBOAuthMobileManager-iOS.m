///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthMobileManager-iOS.h"

#import "DBOAuthConstants.h"
#import "DBOAuthManager+Protected.h"
#import "DBOAuthMobile-iOS.h"
#import "DBOAuthPKCESession.h"
#import "DBOAuthResult.h"
#import "DBScopeRequest+Protected.h"
#import "DBSharedApplicationProtocol.h"

#pragma mark - OAuth manager base (iOS)

static NSString *kDBLinkNonce = @"dropbox.sync.nonce";

@implementation DBOAuthMobileManager {
  NSURL *_dauthRedirectURL;
}

- (instancetype)initWithAppKey:(NSString *)appKey {
  return [self initWithAppKey:appKey host:nil];
}

- (instancetype)initWithAppKey:(NSString *)appKey host:(NSString *)host {
  return [self initWithAppKey:appKey host:host redirectURL:nil];
}

- (instancetype)initWithAppKey:(NSString *)appKey host:(NSString *)host redirectURL:(NSString *)redirectURL {
  self = [super initWithAppKey:appKey host:host redirectURL:redirectURL];
  if (self) {
    _dauthRedirectURL = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://1/connect", appKey]];
    [_urls addObject:_dauthRedirectURL];
  }
  return self;
}

- (DBOAuthResult *)extractFromUrl:(NSURL *)url {
  DBOAuthResult *result;
  if ([url.host isEqualToString:@"1"]) { // dauth
    result = [self extractfromDAuthURL:url];
  } else {
    result = [self extractFromRedirectURL:url];
  }
  return result;
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id<DBSharedApplication>)sharedApplication {
  if (![self hasApplicationQueriesSchemes]) {
    NSString *message = @"DropboxSDK: unable to link; app isn't registered to query for URL schemes dbapi-2 and "
                        @"dbapi-8-emm. In your project's Info.plist file, add a \"dbapi-2\" value and a "
                        @"\"dbapi-8-emm\" value associated with the following keys: \"Information Property List\" > "
                        @"\"LSApplicationQueriesSchemes\" > \"Item <N>\" and \"Item <N+1>\".";
    NSString *title = @"ObjectiveDropbox Error";
    [sharedApplication presentErrorMessage:message title:title];
    return YES;
  }

  NSString *scheme = [self dAuthScheme:sharedApplication];

  if (scheme != nil) {
    NSURL *url = nil;
    if (_authSession) {
      // Code flow
      url = [self dAuthURL:scheme authSession:_authSession];
    } else {
      // Token flow
      NSString *nonce = [[NSUUID alloc] init].UUIDString;
      [[NSUserDefaults standardUserDefaults] setObject:nonce forKey:kDBLinkNonce];
      url = [self dAuthURL:scheme nonce:nonce];
    }
    NSAssert(url, @"Failed to create dauth url.");
    [sharedApplication presentExternalApp:url];
    return YES;
  }

  return NO;
}

- (DBOAuthResult *)handleRedirectURL:(NSURL *)url {
  [[DBMobileSharedApplication mobileSharedApplication] dismissAuthController];
  DBOAuthResult *result = [super handleRedirectURL:url];
  return result;
}

- (NSURL *)dAuthURL:(NSString *)scheme nonce:(NSString *)nonce {
  NSURLComponents *components = [self db_dauthUrlCommonComponentsWithScheme:scheme];
  if (nonce != nil) {
    NSString *state = [NSString stringWithFormat:@"oauth2:%@", nonce];
    components.queryItems =
      [components.queryItems arrayByAddingObject:[NSURLQueryItem queryItemWithName:kDBStateKey value:state]];
  }
  return components.URL;
}

- (NSURL *)dAuthURL:(NSString *)scheme authSession:(DBOAuthPKCESession *)authSession {
  NSURLComponents *components = [self db_dauthUrlCommonComponentsWithScheme:scheme];
  NSString *extraQueryParams = [DBOAuthMobileManager db_createExtraQueryParamsStringForAuthSession:authSession];
  components.queryItems =
    [components.queryItems arrayByAddingObjectsFromArray:@[
      [NSURLQueryItem queryItemWithName:kDBStateKey value:authSession.state],
      [NSURLQueryItem queryItemWithName:kDBExtraQueryParamsKey value:extraQueryParams],
    ]];
  return components.URL;
}

- (NSString *)dAuthScheme:(id<DBSharedApplication>)sharedApplication {
  if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-2" nonce:nil]]) {
    return @"dbapi-2";
  } else if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-8-emm" nonce:nil]]) {
    return @"dbapi-8-emm";
  } else {
    return nil;
  }
}

- (DBOAuthResult *)extractfromDAuthURL:(NSURL *)url {
  NSString *path = url.path;
  if (path != nil) {
    if ([path isEqualToString:@"/connect"]) {
      NSMutableDictionary<NSString *, NSString *> *results = [[NSMutableDictionary alloc] init];
      NSArray<NSString *> *pairs = [url.query componentsSeparatedByString:@"&"] ?: @[];

      for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        [results setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
      }
      NSArray<NSString *> *state = [results[@"state"] componentsSeparatedByString:@"%3A"];

      NSString *nonce = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kDBLinkNonce];
      if (state.count == 2 && [state[0] isEqualToString:@"oauth2"] && [state[1] isEqualToString:nonce]) {
        NSString *accessToken = results[@"oauth_token_secret"];
        NSString *uid = results[@"uid"];
        return [[DBOAuthResult alloc] initWithSuccess:[[DBAccessToken alloc] initWithAccessToken:accessToken uid:uid]];
      } else {
        return [[DBOAuthResult alloc] initWithError:@"" errorDescription:@"Unable to verify link request."];
      }
    }
  }

  return nil;
}

- (BOOL)hasApplicationQueriesSchemes {
  NSArray<NSString *> *queriesSchemes =
      [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSApplicationQueriesSchemes"];
  BOOL foundApi2 = NO;
  BOOL foundApi8Emm = NO;
  for (NSString *scheme in queriesSchemes) {
    if ([scheme isEqualToString:@"dbapi-2"]) {
      foundApi2 = YES;
    } else if ([scheme isEqualToString:@"dbapi-8-emm"]) {
      foundApi8Emm = YES;
    }
    if (foundApi2 && foundApi8Emm) {
      return YES;
    }
  }
  return NO;
}

- (NSURLComponents *)db_dauthUrlCommonComponentsWithScheme:(NSString *)scheme {
  NSURLComponents *components = [NSURLComponents new];
  components.scheme = scheme;
  components.host = @"1";
  components.path = @"/connect";
  components.queryItems = @[
    [NSURLQueryItem queryItemWithName:@"k" value:_appKey],
    [NSURLQueryItem queryItemWithName:@"s" value:@""],
  ];
  return components;
}

+ (NSString *)db_createExtraQueryParamsStringForAuthSession:(DBOAuthPKCESession *)authSession {
  NSMutableArray<NSString *> *params = [NSMutableArray new];
  NSString *format = @"%@=%@";
  DBPkceData *pkceData = authSession.pkceData;
  [params addObject:[NSString stringWithFormat:format, kDBCodeChallengeKey, pkceData.codeChallenge]];
  [params addObject:[NSString stringWithFormat:format, kDBCodeChallengeMethodKey, pkceData.codeChallengeMethod]];
  [params addObject:[NSString stringWithFormat:format, kDBTokenAccessTypeKey, authSession.tokenAccessType]];
  [params addObject:[NSString stringWithFormat:format, kDBResponseTypeKey, authSession.responseType]];
  DBScopeRequest *scopeRequest = authSession.scopeRequest;
  if (scopeRequest.scopeString) {
    [params addObject:[NSString stringWithFormat:format, kDBScopeKey, scopeRequest.scopeString]];
  }
  if (scopeRequest.includeGrantedScopes) {
    [params addObject:[NSString stringWithFormat:format, kDBIncludeGrantedScopesKey, scopeRequest.scopeType]];
  }
  return [params componentsJoinedByString:@"&"];
}

@end
