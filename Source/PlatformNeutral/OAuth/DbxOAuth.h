///
/// Logic for handling OAuth transactions.
///

#import <Foundation/Foundation.h>

@class DbxAccessToken;
@class DbxOAuthResult;

typedef void (^AuthFailedBlock)(NSString * _Nonnull errorSummary);
typedef void (^AuthSuccededBlock)(NSString * _Nonnull token);

@protocol DbxSharedApplication <NSObject>

- (void)presentErrorMessage:(NSString * _Nonnull)message title:(NSString * _Nonnull)title;
- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message title:(NSString * _Nonnull)title buttonHandlers:(NSDictionary <NSString *, void (^)()> * _Nonnull)buttonHandlers;
- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL;
- (void)presentWebViewAuth:(NSURL * _Nonnull)authURL tryIntercept:(BOOL (^_Nonnull)(NSURL * _Nonnull))tryIntercept cancelHandler:(void (^_Nonnull)(void))cancelHandler;
- (void)presentBrowserAuth:(NSURL * _Nonnull)authURL;
- (void)presentExternalApp:(NSURL * _Nonnull)url;
- (BOOL)canPresentExternalApp:(NSURL * _Nonnull)url;

@end


@interface DbxOAuthManager : NSObject {
@protected
    NSString *_appKey;
    NSURL *_redirectURL;
    NSString *_host;
    NSMutableArray<NSURL *> *_urls;
}

- (nonnull instancetype)init:(NSString * _Nonnull)appKey host:(NSString * _Nonnull)host;

- (nonnull instancetype)init:(NSString * _Nonnull)appKey;

- (void)authorizeFromSharedApplication:(id<DbxSharedApplication> _Nonnull)sharedApplication browserAuth:(BOOL)browserAuth;

- (DbxOAuthResult * _Nonnull)handleRedirectURL:(NSURL * _Nonnull)url;

+ (DbxOAuthManager * _Nullable)sharedOAuthManager;

+ (void)sharedOAuthManager:(DbxOAuthManager * _Nonnull)sharedManager;

///
/// Retrieve all stored access tokens
///
/// - returns: a dictionary mapping users to their access tokens
///
- (NSDictionary<NSString *, DbxAccessToken *> * _Nonnull)getAllAccessTokens;

///
/// Check if there are any stored access tokens
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
- (DbxAccessToken * _Nullable)getAccessToken:(NSString * _Nonnull)user;

///
/// Delete a specific access token
///
/// - parameter token: The access token to delete
///
/// - returns: whether the operation succeeded
///
- (BOOL)clearStoredAccessToken:(DbxAccessToken * _Nonnull)token;

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
- (BOOL)storeAccessToken:(DbxAccessToken * _Nonnull)accessToken;

///
/// Utility function to return an arbitrary access token
///
/// - returns: the "first" access token found, if any (otherwise `nil`)
///
- (DbxAccessToken * _Nullable)getFirstAccessToken;

@end


@interface DbxDesktopOAuthManager : DbxOAuthManager
@end


@interface DbxMobileOAuthManager : DbxOAuthManager {
@protected
    NSURL *_dauthRedirectURL;
}
@end


@interface DbxAccessToken : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)accessToken uid:(NSString * _Nonnull)uid;

@property (nonatomic) NSString * _Nonnull accessToken;
@property (nonatomic) NSString * _Nonnull uid;

@end


