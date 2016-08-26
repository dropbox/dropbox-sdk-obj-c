#import <Foundation/Foundation.h>

@class DbxAccessToken;

///
/// Union result type from OAuth linking attempt.
///
@interface DbxOAuthResult : NSObject

/// The `DbxAuthResultTag` enum type represents the possible tag
/// states that the `DbxOAuthResult` union can exist in.
typedef NS_ENUM(NSInteger, DbxAuthResultTag) {
    /// The authorization succeeded. Includes a `DbxAccessToken`.
    DbxAuthSuccess,
    
    /// The authorization failed. Includes an `OAuth2Error` and a descriptive message.
    DbxAuthError,
    
    /// The authorization was manually canceled by the user.
    DbxAuthCancel,
};

/// The `DbxAuthErrorType` enum type represents the possible
/// error types that can be returned from OAuth linking.
typedef NS_ENUM(NSInteger, DbxAuthErrorType) {
    /// The client is not authorized to request an access token using this method.
    DbxAuthUnauthorizedClient,
    
    /// The resource owner or authorization server denied the request.
    DbxAuthAccessDenied,
    
    /// The authorization server does not support obtaining an access token using
    /// this method.
    DbxAuthUnsupportedResponseType,
    
    /// The requested scope is invalid, unknown, or malformed.
    DbxAuthInvalidScope,
    
    /// The authorization server encountered an unexpected condition that prevented
    /// it from fulfilling the request.
    DbxAuthServerError,
    
    /// The authorization server is currently unable to handle the request due to a
    /// temporary overloading or maintenance of the server.
    DbxAuthTemporarilyUnavailable,
    
    /// Some other error (outside of the OAuth2 specification)
    DbxAuthUnknown,
};

/// Represents the `DbxOAuthResult` object's current tag state.
@property (nonatomic) DbxAuthResultTag tag;

/// The access token that is retrieved in the event of a successful OAuth authorization.
@property (nonatomic, nonnull) DbxAccessToken *accessToken;

/// The type of OAuth error that is returned in the event of an unsuccessful OAuth
/// authorization.
@property (nonatomic) DbxAuthErrorType errorType;

/// The error description string associated with the `DbxAuthErrorType` that is returned
/// in the event of an unsuccessful OAuth authorization.
@property (nonatomic, nonnull) NSString *errorDescription;


/// Initializes the `DbxOAuthResult` object with data from a successful OAuth linking attempt.
- (nonnull instancetype)initWithSuccess:(DbxAccessToken * _Nonnull)accessToken;

/// Initializes the `DbxOAuthResult` object with data from an unsuccessful OAuth linking attempt.
- (nonnull instancetype)initWithError:(NSString * _Nonnull)errorType errorDescription:(NSString * _Nonnull)errorDescription;

/// Initializes the `DbxOAuthResult` object with data from a cancelled OAuth linking attempt.
- (nonnull instancetype)initWithCancel;

/// Returns whether the union's current tag state has value `Success`.
- (BOOL)isSuccess;

/// Returns whether the union's current tag state has value `Error`.
- (BOOL)isError;

/// Returns whether the union's current tag state has value `Cancel`.
- (BOOL)isCancel;

/// Returns a human-readable string representing the union's current tag state.
- (NSString * _Nonnull)getTagName;

/// Returns a human-readable representation of the
/// `DbxOAuthResult` object.
- (NSString * _Nonnull)description;

@end
