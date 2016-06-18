///
/// Result types for OAuth linking.
///

#import <Foundation/Foundation.h>
@class DbxAccessToken;

/// The result of an authorization attempt.
@interface DbxOAuthResult : NSObject 

typedef NS_ENUM(NSInteger, DbxAuthResultTag) {
    /// The authorization succeeded. Includes a `DropboxAccessToken`.
    DbxAuthSuccess,
    
    /// The authorization failed. Includes an `OAuth2Error` and a descriptive message.
    DbxAuthError,
    
    /// The authorization was manually canceled by the user.
    DbxAuthCancel,
};

- (nonnull instancetype)initWithSuccess:(DbxAccessToken * _Nonnull)accessToken;

- (nonnull instancetype)initWithError:(NSString * _Nonnull)errorType errorDescription:(NSString * _Nonnull)errorDescription;

- (nonnull instancetype)initWithCancel;

- (BOOL)isSuccess;

- (BOOL)isError;

- (BOOL)isCancel;

- (NSString * _Nonnull)getTagName;

- (NSString * _Nonnull)description;

typedef NS_ENUM(NSInteger, DbxAuthErrorType) {
    /// The client is not authorized to request an access token using this method.
    DbxAuthUnauthorizedClient,
    
    /// The resource owner or authorization server denied the request.
    DbxAuthAccessDenied,
    
    /// The authorization server does not support obtaining an access token using this method.
    DbxAuthUnsupportedResponseType,
    
    /// The requested scope is invalid, unknown, or malformed.
    DbxAuthInvalidScope,
    
    /// The authorization server encountered an unexpected condition that prevented it from fulfilling the request.
    DbxAuthServerError,
    
    /// The authorization server is currently unable to handle the request due to a temporary overloading or maintenance of the server.
    DbxAuthTemporarilyUnavailable,
    
    /// Some other error (outside of the OAuth2 specification)
    DbxAuthUnknown,
};

@property (nonatomic) DbxAuthResultTag tag;
@property (nonatomic, nonnull) DbxAccessToken *accessToken;
@property (nonatomic, nonnull) NSString *errorDescription;
@property (nonatomic) DbxAuthErrorType errorType;

@end
