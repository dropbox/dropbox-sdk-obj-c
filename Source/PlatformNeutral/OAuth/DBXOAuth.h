///
/// Logic for handling OAuth transactions.
///

#import <Foundation/Foundation.h>

@class DBXAccessToken;
@class DBXOAuthResult;
@protocol DBXSharedApplication;

///
/// Platform-neutral manager for performing OAuth linking.
///
@interface DBXOAuthManager : NSObject

///
/// Accessor method for `DBXOAuthManager` shared instance, which is used to authenticate
/// users through OAuth2, save access tokens, and retrieve access tokens.
///
/// - returns: The `DBXOAuthManager` shared instance.
///
+ (DBXOAuthManager * _Nullable)sharedOAuthManager;

///
/// Mutator method for `DBXOAuthManager` shared instance, which is used to authenticate
/// users through OAuth2, save access tokens, and retrieve access tokens.
///
/// - parameter sharedManager: The updated reference to the `DBXOAuthManager` shared
/// instance.
///
+ (void)sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedManager;

///
/// `DBXOAuthManager` convenience constructor.
///
/// - parameter appKey: The app key from the developer console that identifies this app.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey;

///
/// `DBXOAuthManager` full constructor.
///
/// - parameter appKey: The app key from the developer console that identifies this app.
/// - parameter host: The host of the OAuth web flow.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey host:(NSString * _Nonnull)host;

///
/// Platform-neutral initialization of the authorization flow. Interfaces with platform-specific rendering
/// logic via the `DBXSharedApplication` protocol.
///
///
/// - parameter sharedApplication: A platform-neutral shared application abstraction for rendering auth flow.
/// - parameter browserAuth: Whether the auth flow should use an external web browser for auth or not. If not,
/// then an in-app webview is used instead.
///
- (void)authorizeFromSharedApplication:(id<DBXSharedApplication> _Nonnull)sharedApplication browserAuth:(BOOL)browserAuth;

///
/// Handles a redirect back into the application (from whichever auth flow was being used).
///
/// - parameter url: The redirect URL to attempt to handle.
///
/// - returns `nil` if SDK cannot handle the redirect URL, otherwise returns an instance of `DBXOAuthResult`.
///
- (DBXOAuthResult * _Nonnull)handleRedirectURL:(NSURL * _Nonnull)url;

///
/// Saves an access token to the `DBXKeychain` class.
///
/// - parameter token: The access token to save.
///
/// - returns: Whether the save operation succeeded.
///
- (BOOL)storeAccessToken:(DBXAccessToken * _Nonnull)accessToken;

///
/// Utility function to return an arbitrary access token from the `DBXKeychain` class, if any exist.
///
/// - returns: the "first" access token found, if any, otherwise `nil`.
///
- (DBXAccessToken * _Nullable)getFirstAccessToken;

///
/// Retrieves the access token for a particular user from the `DBXKeychain` class.
///
/// - parameter owner: The owner of the access token to retrieve. Either user_id or team_id.
///
/// - returns: An access token if present, otherwise `nil`.
///
- (DBXAccessToken * _Nullable)getAccessToken:(NSString * _Nonnull)owner;

///
/// Retrieves all stored access tokens from the `DBXKeychain` class.
///
/// - returns: a dictionary mapping owners (via account_id or team_id) to their access tokens.
///
- (NSDictionary<NSString *, DBXAccessToken *> * _Nonnull)getAllAccessTokens;

///
/// Checks if there are any stored access tokens in the `DBXKeychain` class.
///
/// - returns: Whether there are stored access tokens.
///
- (BOOL)hasStoredAccessTokens;

///
/// Deletes a specific access tokens from the `DBXKeychain` class.
///
/// - parameter token: The access token to delete.
///
/// - returns: Whether the delete operation succeeded.
///
- (BOOL)clearStoredAccessToken:(DBXAccessToken * _Nonnull)token;

///
/// Deletes all stored access tokens in the `DBXKeychain` class.
///
/// - returns: Whether the batch deletion operation succeeded.
///
- (BOOL)clearStoredAccessTokens;

@end


///
/// Platform-specific (OS X) manager for performing OAuth linking.
///
@interface DBXDesktopOAuthManager : DBXOAuthManager

@end


///
/// Platform-specific (iOS) manager for performing OAuth linking.
///
@interface DBXMobileOAuthManager : DBXOAuthManager

@end


///
/// Encapsulation of a Dropbox OAuth2 access token and a unique
/// identifying key for storing in `DBXKeychain`.
///
@interface DBXAccessToken : NSObject

/// The OAuth2 access token.
@property (nonatomic, readonly, copy) NSString * _Nonnull accessToken;

/// The unique identifier of the access token used for storing in `DBXKeychain`.
/// Either the account_id (if user app) or the team_id if (team app).
@property (nonatomic, readonly, copy) NSString * _Nonnull uid;

///
/// `DBXAccessToken` full constructor.
///
/// - parameter accessToken: The OAuth2 access token retrieved from the auth flow.
/// - parameter uid: The unique identifier used to store in `DBXKeychain`.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken uid:(NSString * _Nonnull)uid;

@end


