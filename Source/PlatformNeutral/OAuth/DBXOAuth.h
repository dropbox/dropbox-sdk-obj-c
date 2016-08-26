///
/// Logic for handling OAuth transactions.
///

#import <Foundation/Foundation.h>

@class DBXAccessToken;
@class DBXOAuthResult;
@protocol DBXSharedApplication;

@interface DBXOAuthManager : NSObject {
    NSString *_appKey;
    NSURL *_redirectURL;
    NSString *_host;
    NSMutableArray<NSURL *> *_urls;
}

///
/// Create an instance
/// - parameter appKey: The app key from the developer console that identifies this app.
///
- (nonnull instancetype)init:(NSString * _Nonnull)appKey host:(NSString * _Nonnull)host;

///
/// Create an instance
/// - parameter appKey: The app key from the developer console that identifies this app.
///
- (nonnull instancetype)init:(NSString * _Nonnull)appKey;

///
/// Present the OAuth2 authorization request page by presenting a web view controller modally
///
/// - parameter controller: The controller to present from
///
- (void)authorizeFromSharedApplication:(id<DBXSharedApplication> _Nonnull)sharedApplication browserAuth:(BOOL)browserAuth;

///
/// Try to handle a redirect back into the application
///
/// - parameter url: The URL to attempt to handle
///
/// - returns `nil` if SwiftyDropbox cannot handle the redirect URL, otherwise returns the `DropboxAuthResult`.
///
- (DBXOAuthResult * _Nonnull)handleRedirectURL:(NSURL * _Nonnull)url;

+ (DBXOAuthManager * _Nullable)sharedOAuthManager;

/// Manages access token storage and authentication
///
/// Use the `DBXOAuthManager` to authenticate users through OAuth2, save access tokens, and retrieve access tokens.
+ (void)sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedManager;

///
/// Retrieve all stored access tokens.
///
/// - returns: a dictionary mapping users to their access tokens
///
- (NSDictionary<NSString *, DBXAccessToken *> * _Nonnull)getAllAccessTokens;

///
/// Check if there are any stored access tokens.
///
/// - returns: Whether there are stored access tokens
///
- (BOOL)hasStoredAccessTokens;

///
/// Retrieve the access token for a particular user
///
/// - parameter user: The user whose token to retrieve
///
/// - returns: An access token if present, otherwise `nil`.
///
- (DBXAccessToken * _Nullable)getAccessToken:(NSString * _Nonnull)user;

///
/// Delete a specific access token
///
/// - parameter token: The access token to delete
///
/// - returns: whether the operation succeeded
///
- (BOOL)clearStoredAccessToken:(DBXAccessToken * _Nonnull)token;

///
/// Delete all stored access tokens
///
/// - returns: whether the operation succeeded
///
- (BOOL)clearStoredAccessTokens;

///
/// Save an access token
///
/// - parameter token: The access token to save
///
/// - returns: whether the operation succeeded
///
- (BOOL)storeAccessToken:(DBXAccessToken * _Nonnull)accessToken;

///
/// Utility function to return an arbitrary access token
///
/// - returns: the "first" access token found, if any (otherwise `nil`)
///
- (DBXAccessToken * _Nullable)getFirstAccessToken;

@end


@interface DBXDesktopOAuthManager : DBXOAuthManager
@end


@interface DBXMobileOAuthManager : DBXOAuthManager {
@protected
    NSURL *_dauthRedirectURL;
}
@end


@interface DBXAccessToken : NSObject

@property (nonatomic) NSString * _Nonnull accessToken;

// The unique identifier of the access token. Either the account id (if user app) or the team id
// if (team app).
@property (nonatomic) NSString * _Nonnull uid;

- (nonnull instancetype)init:(NSString * _Nonnull)accessToken uid:(NSString * _Nonnull)uid;

@end


