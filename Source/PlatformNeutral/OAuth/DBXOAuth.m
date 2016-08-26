///
/// Logic for handling OAuth transactions.
///

#import "DBXKeychain.h"
#import "DBXOAuth.h"
#import "DBXOAuthResult.h"
#import "DBXSharedApplicationProtocol.h"
#import "Reachability.h"

/// A shared instance of a `DBXOAuthManager` for convenience
static DBXOAuthManager *sharedOAuthManager;
static Reachability *internetReachableFoo;

@implementation DBXOAuthManager

+ (DBXOAuthManager *)sharedOAuthManager {
    return sharedOAuthManager;
}

+ (void)sharedOAuthManager:(DBXOAuthManager *)sharedManager {
    sharedOAuthManager = sharedManager;
}

- (instancetype)init:(NSString *)appKey host:(NSString *)host {
    if (self) {
        _appKey = appKey;
        _redirectURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"db-%@://2/token", _appKey]];
        _host = host;
        _urls = [NSMutableArray arrayWithObjects:_redirectURL, nil];
    }
    return self;
}

- (instancetype)init:(NSString *)appKey {
    return [self init:appKey host:@"www.dropbox.com"];
}

- (DBXOAuthResult *)handleRedirectURL:(NSURL *)url {
    // check if url is a cancel url
    if (([[url host] isEqualToString:@"1"] && [[url path] isEqualToString:@"/cancel"]) || ([[url host] isEqualToString:@"2"] && [[url path] isEqualToString:@"/cancel"])) {
        return [[DBXOAuthResult alloc] initWithCancel];
    }
    
    if (![self canHandleURL:url]) {
        return nil;
    }
    
    DBXOAuthResult *result = [self extractFromUrl: url];
    
    if ([result isSuccess]) {
        [DBXKeychain set:result.accessToken.uid value:result.accessToken.accessToken];
    }
    
    return result;
}

- (void)authorizeFromSharedApplication:(id<DBXSharedApplication>)sharedApplication browserAuth:(BOOL)browserAuth {
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
        BOOL (^tryInterceptHandler)(NSURL *) = ^BOOL(NSURL *url) {
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

        [sharedApplication presentWebViewAuth:url tryInterceptHandler:tryInterceptHandler cancelHandler:cancelHandler];
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

- (DBXOAuthResult *)extractFromRedirectURL:(NSURL *)url {
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    NSArray *pairs  = [[url fragment] componentsSeparatedByString:@"&"] ?: @[];
    
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        [results setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    
    if (results[@"error"]) {
        NSString *desc = [[results[@"error_description"] stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByRemovingPercentEncoding] ?: @"";
        
        if ([results[@"error"] isEqualToString:@"access_denied"]) {
            return [[DBXOAuthResult alloc] initWithCancel];
        }
        return [[DBXOAuthResult alloc] initWithError:results[@"error"] errorDescription:desc];
    } else {
        NSString *uid = results[@"account_id"] ?: results[@"team_id"];
        DBXAccessToken *accessToken = [[DBXAccessToken alloc] init:results[@"access_token"] uid:uid];
        return [[DBXOAuthResult alloc] initWithSuccess:accessToken];
    }
}

- (DBXOAuthResult *)extractFromUrl:(NSURL *)url {
    return [self extractFromRedirectURL:url];
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id <DBXSharedApplication>)sharedApplication {
    return NO;
}

- (NSDictionary<NSString *, DBXAccessToken *> *)getAllAccessTokens {
    NSArray<NSString *> *users = [DBXKeychain getAll];
    NSMutableDictionary<NSString *, DBXAccessToken *> *result = [[NSMutableDictionary alloc] init];
    for (NSString *user in users) {
        NSString *accessToken = [DBXKeychain get:user];
        if (accessToken != nil) {
            result[user] = [[DBXAccessToken alloc] init:accessToken uid:user];
        }
    }
    return result;
}

- (BOOL)hasStoredAccessTokens {
    return [self getAllAccessTokens].count != 0;
}

- (DBXAccessToken *)getAccessToken:(NSString *)user {
    NSString *accessToken = [DBXKeychain get:user];
    if (accessToken != nil) {
        return [[DBXAccessToken alloc] init:accessToken uid:user];
    } else {
        return nil;
    }
}

- (BOOL)clearStoredAccessToken:(DBXAccessToken *)token {
    return [DBXKeychain delete:token.uid];
}

- (BOOL)clearStoredAccessTokens {
    return [DBXKeychain clear];
}

- (BOOL)storeAccessToken:(DBXAccessToken *)accessToken {
    return [DBXKeychain set:accessToken.uid value:accessToken.accessToken];
}

- (DBXAccessToken *)getFirstAccessToken {
    NSDictionary<NSString *, DBXAccessToken *> *tokens = [self getAllAccessTokens];
    NSArray *values = [tokens allValues];
    if ([values count] != 0) {
        return [values objectAtIndex:0];
    }
    return nil;
}

@end


@implementation DBXDesktopOAuthManager

@end


@implementation DBXMobileOAuthManager

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

- (DBXOAuthResult *)extractFromUrl:(NSURL *)url {
    DBXOAuthResult *result;
    if ([url.host isEqualToString:@"1"]) { // dauth
        result = [self extractfromDAuthURL:url];
    } else {
        result = [self extractFromRedirectURL:url];
    }
    return result;
}

- (BOOL)checkAndPresentPlatformSpecificAuth:(id<DBXSharedApplication>)sharedApplication {
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

- (NSString *)dAuthScheme:(id<DBXSharedApplication>)sharedApplication {
    if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-2" nonce:nil]]) {
        return @"dbapi-2";
    } else if ([sharedApplication canPresentExternalApp:[self dAuthURL:@"dbapi-8-emm" nonce:nil]]) {
        return @"dbapi-8-emm";
    } else {
        return nil;
    }
}

- (DBXOAuthResult *)extractfromDAuthURL:(NSURL *)url {
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
                return [[DBXOAuthResult alloc] initWithSuccess:[[DBXAccessToken alloc] init:accessToken uid:uid]];
            } else {
                return [[DBXOAuthResult alloc] initWithError:@"" errorDescription:@"Unable to verify link request."];
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


@implementation DBXAccessToken
    
- (instancetype)init:(NSString *)accessToken uid:(NSString *)uid {
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
