///
/// Logic for handling OAuth transactions.
///

#import "DbxKeychain.h"
#import "DbxOAuth.h"
#import "DbxOAuthResult.h"
#import "Reachability.h"

@implementation DbxOAuthManager

// MARK: Shared instance
/// A shared instance of a `DbxOAuthManager` for convenience
static DbxOAuthManager *sharedOAuthManager;
static Reachability *internetReachableFoo;

/// Manages access token storage and authentication
///
/// Use the `DbxOAuthManager` to authenticate users through OAuth2, save access tokens, and retrieve access tokens.
+ (DbxOAuthManager *)sharedOAuthManager {
    return sharedOAuthManager;
}

+ (void)sharedOAuthManager:(DbxOAuthManager *)sharedManager {
    sharedOAuthManager = sharedManager;
}


// MARK: Functions

///
/// Create an instance
/// parameter appKey: The app key from the developer console that identifies this app.
///
- (nonnull instancetype)init:(NSString *)appKey host:(NSString *)host {
    if (self) {
        _appKey = appKey;
        _redirectURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"db-%@://2/token", _appKey]];
        _host = host;
        _urls = [NSMutableArray arrayWithObjects:_redirectURL, nil];
    }
    return self;
}

///
/// Create an instance
/// parameter appKey: The app key from the developer console that identifies this app.
///
- (nonnull instancetype)init:(NSString *)appKey {
    return [self init:appKey host:@"www.dropbox.com"];
}

///
/// Try to handle a redirect back into the application
///
/// - parameter url: The URL to attempt to handle
///
/// - returns `nil` if SwiftyDropbox cannot handle the redirect URL, otherwise returns the `DropboxAuthResult`.
///
- (DbxOAuthResult *)handleRedirectURL:(NSURL *)url {
    // check if url is a cancel url
    if (([[url host] isEqualToString:@"1"] && [[url path] isEqualToString:@"/cancel"]) || ([[url host] isEqualToString:@"2"] && [[url path] isEqualToString:@"/cancel"])) {
        return [[DbxOAuthResult alloc] initWithCancel];
    }
    
    if (![self canHandleURL:url]) {
        return nil;
    }
    
    DbxOAuthResult *result = [self extractFromUrl: url];
    
    if ([result isSuccess]) {
        [DbxKeychain setWithString:result.accessToken.uid value:result.accessToken.accessToken];
    }
    
    return result;
}

///
/// Present the OAuth2 authorization request page by presenting a web view controller modally
///
/// - parameter controller: The controller to present from
///
- (void)authorizeFromSharedApplication:(id<DbxSharedApplication>)sharedApplication browserAuth:(BOOL)browserAuth {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus] == NotReachable) {
        NSString *message = @"Try again once you have an internet connection.";
        NSString *title = @"No internet connection";
        
        NSDictionary<NSString *, void(^)()> *buttonHandlers = @{
            @"Retry": ^void() { [self authorizeFromSharedApplication:sharedApplication browserAuth:browserAuth]; }
        };

        [sharedApplication presentErrorMessageWithHandlers:message title:title buttonHandlers:buttonHandlers];
        
        return;
    }

    if (![self conformsToAppScheme]) {
        NSString *message = [NSString stringWithFormat:@"DropboxSDK: unable to link; app isn't registered for correct URL scheme (db-%@). Add this scheme to your project Info.plist file, associated with following key: \"Information Property List\" > \"URL types\" > \"Item 0\" > \"URL Schemes\" > \"Item <N>\".", _appKey];
        NSString *title = @"SwiftyDropbox Error";
        
        [sharedApplication presentErrorMessage:message title:title];
        
        return;
    }
    
    NSURL *url = [self authURL];
    
    if ([self checkAndPresentPlatformSpecificAuth:sharedApplication]) {
        return;
    }
    
    if (browserAuth) {
        [sharedApplication presentBrowserAuth:url];
    } else {
        BOOL (^tryIntercept)(NSURL *) = ^BOOL(NSURL *url) {
            if ([self canHandleURL:url]) {
                [sharedApplication presentExternalApp:url];
                return YES;
            } else {
                return NO;
            }
        };
        
        void (^cancelHandler)() = ^void() {
            NSURL *cancelUrl = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://2/cancel", _appKey]];
            [sharedApplication presentExternalApp:cancelUrl];
        };

        [sharedApplication presentWebViewAuth:url tryIntercept:tryIntercept cancelHandler:cancelHandler];
    }
}

- (BOOL)conformsToAppScheme {
    NSString *appScheme = [NSString stringWithFormat:@"db-%@", _appKey];
    
    NSArray *urlTypes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleURLTypes"] ?: @[];
    
    for (NSDictionary *urlType in urlTypes) {
        NSArray<NSString *> *schemes = [urlType objectForKey:@"CFBundleURLSchemes"];
        for (NSString *scheme in schemes) {
            NSLog(@"%@\n", scheme);
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
    components.path = @"/1/oauth2/authorize";
    
    components.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"response_type" value:@"token"],
        [NSURLQueryItem queryItemWithName:@"client_id" value:_appKey],
        [NSURLQueryItem queryItemWithName:@"redirect_uri" value:[_redirectURL absoluteString]],
        [NSURLQueryItem queryItemWithName:@"disable_signup" value:@"true"],
    ];
    return components.URL;
}

- (BOOL)canHandleURL:(NSURL *)url {
    for (NSURL *known in _urls) {
        if ([url.scheme isEqualToString:known.scheme] && [url.host isEqualToString:known.host] && [url.path isEqualToString:known.path]) {
            return YES;
        }
    }
    return NO;
}

- (DbxOAuthResult *)extractFromRedirectURL:(NSURL *)url {
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    NSArray *pairs  = [[url fragment] componentsSeparatedByString:@"&"] ?: @[];
    
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        [results setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    
    if (results[@"error"]) {
        NSString *desc = [[results[@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding] ?: @"";
        
        if ([results[@"error"] isEqualToString:@"access_denied"]) {
            return [[DbxOAuthResult alloc] initWithCancel];
        }
        return [[DbxOAuthResult alloc] initWithError:results[@"error"] errorDescription:desc];
    } else {
        DbxAccessToken *accessToken = [[DbxAccessToken alloc] init:results[@"access_token"] uid:results[@"uid"]];
        return [[DbxOAuthResult alloc] initWithSuccess:accessToken];
    }
}

- (DbxOAuthResult *)extractFromUrl:(NSURL *)url {
    return [self extractFromRedirectURL:url];
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id <DbxSharedApplication>)sharedApplication {
    return NO;
}

///
/// Retrieve all stored access tokens
///
/// - returns: a dictionary mapping users to their access tokens
///
- (NSDictionary<NSString *, DbxAccessToken *> *)getAllAccessTokens {
    NSArray<NSString *> *users = [DbxKeychain getAll];
    NSMutableDictionary<NSString *, DbxAccessToken *> *result = [[NSMutableDictionary alloc] init];
    for (NSString *user in users) {
        NSString *accessToken = [DbxKeychain get:user];
        if (accessToken != nil) {
            result[user] = [[DbxAccessToken alloc] init:accessToken uid:user];
        }
    }
    return result;
}

///
/// Check if there are any stored access tokens
///
/// - returns: Whether there are stored access tokens
///
- (BOOL)hasStoredAccessTokens {
    return [self getAllAccessTokens].count != 0;
}

///
/// Retrieve the access token for a particular user
///
/// - parameter user: The user whose token to retrieve
///
/// - returns: An access token if present, otherwise `nil`.
///
- (DbxAccessToken *)getAccessToken:(NSString *)user {
    NSString *accessToken = [DbxKeychain get:user];
    if (accessToken != nil) {
        return [[DbxAccessToken alloc] init:accessToken uid:user];
    } else {
        return nil;
    }
}

///
/// Delete a specific access token
///
/// - parameter token: The access token to delete
///
/// - returns: whether the operation succeeded
///
- (BOOL)clearStoredAccessToken:(DbxAccessToken *)token {
    return [DbxKeychain delete:token.uid];
}

///
/// Delete all stored access tokens
///
/// - returns: whether the operation succeeded
///
- (BOOL)clearStoredAccessTokens {
    return [DbxKeychain clear];
}

///
/// Save an access token
///
/// - parameter token: The access token to save
///
/// - returns: whether the operation succeeded
///
- (BOOL)storeAccessToken:(DbxAccessToken *)accessToken {
    return [DbxKeychain setWithString:accessToken.uid value:accessToken.accessToken];
}

///
/// Utility function to return an arbitrary access token
///
/// - returns: the "first" access token found, if any (otherwise `nil`)
///
- (DbxAccessToken *)getFirstAccessToken {
    NSDictionary<NSString *, DbxAccessToken *> *tokens = [self getAllAccessTokens];
    NSArray *values = [tokens allValues];
    if ([values count] != 0) {
        return [values objectAtIndex:0];
    }
    return nil;
}

@end


@implementation DbxDesktopOAuthManager

@end


@implementation DbxMobileOAuthManager

static NSString *kDBLinkNonce = @"dropbox.sync.nonce";

- (instancetype)init:(NSString *)appKey {
    self = [super init:appKey];
    if (self) {
        _dauthRedirectURL = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://1/connect", appKey]];
        [_urls addObject:_dauthRedirectURL];
    }
    return self;
}

- (instancetype)init:(NSString *)appKey host:(NSString *)host {
    self = [super init:appKey host:host];
    if (self) {
        _dauthRedirectURL = [NSURL URLWithString:[NSString stringWithFormat:@"db-%@://1/connect", appKey]];
        [_urls addObject:_dauthRedirectURL];
    }
    return self;
}

- (DbxOAuthResult *)extractFromUrl:(NSURL *)url {
    DbxOAuthResult *result;
    if ([url.host isEqualToString:@"1"]) { // dauth
        result = [self extractfromDAuthURL:url];
    } else {
        result = [self extractFromRedirectURL:url];
    }
    return result;
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id<DbxSharedApplication>)sharedApplication {
    if (![self hasApplicationQueriesSchemes]) {
        NSString *message = @"DropboxSDK: unable to link; app isn't registered to query for URL schemes dbapi-2 and dbapi-8-emm. In your project's Info.plist file, add a \"dbapi-2\" value and a \"dbapi-8-emm\" value associated with the following keys: \"Information Property List\" > \"LSApplicationQueriesSchemes\" > \"Item <N>\" and \"Item <N+1>\".";
        NSString *title = @"ObjectiveDropbox Error";
        [sharedApplication presentErrorMessage:message title: title];
        return YES;
    }
    
    NSString *scheme = [self dAuthScheme:sharedApplication];
    
    if (scheme != nil) {
        NSString *nonce = [[NSUUID alloc] init].UUIDString;
        [[NSUserDefaults standardUserDefaults] setObject:nonce forKey:kDBLinkNonce];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [sharedApplication presentExternalApp:[self dAuthURL:scheme nonce:nonce]];
        return YES;
    }
    
    return NO;
}

- (NSURL *)dAuthURL:(NSString *)scheme nonce:(NSString *)nonce {
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = scheme;
    components.host = @"1";
    components.path = @"/connect";
    
    if (nonce != nil) {
        NSString *state = [NSString stringWithFormat:@"oauth2:%@", nonce];
        components.queryItems = @[
          [NSURLQueryItem queryItemWithName:@"k" value:_appKey],
          [NSURLQueryItem queryItemWithName:@"s" value:@""],
          [NSURLQueryItem queryItemWithName:@"state" value:state],
        ];
    }
    return components.URL;
}

- (NSString *)dAuthScheme:(id<DbxSharedApplication>)sharedApplication {
    if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-2" nonce:nil]]) {
        return @"dbapi-2";
    } else if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-8-emm" nonce:nil]]) {
        return @"dbapi-8-emm";
    } else {
        return nil;
    }
}

- (DbxOAuthResult *)extractfromDAuthURL:(NSURL *)url {
    NSString *path = url.path;
    if (path != nil) {
        if ([path isEqualToString:@"/connect"]) {
            NSMutableDictionary<NSString *, NSString *> *results = [[NSMutableDictionary alloc] init];
            NSArray<NSString *> *pairs  = [url.query componentsSeparatedByString:@"&"] ?: @[];

            for (NSString *pair in pairs) {
                 NSArray *kv = [pair componentsSeparatedByString:@"="];
                 [results setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
            }
            NSArray<NSString *> *state = [results[@"state"] componentsSeparatedByString:@"%3A"];
            
            NSString *nonce = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:kDBLinkNonce];
            if (state.count == 2 && [state[0] isEqualToString:@"oauth2"] && [state[1] isEqualToString:nonce]) {
                NSString *accessToken = results[@"oauth_token_secret"];
                NSString *uid = results[@"uid"];
                return [[DbxOAuthResult alloc] initWithSuccess:[[DbxAccessToken alloc] init:accessToken uid:uid]];
            } else {
                return [[DbxOAuthResult alloc] initWithError:@"" errorDescription:@"Unable to verify link request."];
            }
        }
    }
    
    return nil;
}

- (BOOL)hasApplicationQueriesSchemes {
    NSArray<NSString *> *queriesSchemes = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSApplicationQueriesSchemes"];
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

@end


@implementation DbxAccessToken
    
- (nonnull instancetype)init:(NSString *)accessToken uid:(NSString *)uid {
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
