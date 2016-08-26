#import <Foundation/Foundation.h>

@class DBXAccessToken;

///
/// Union result type from OAuth linking attempt.
///
@interface DBXOAuthResult : NSObject

/// The `DBXAuthResultTag` enum type represents the possible tag
/// states that the `DBXOAuthResult` union can exist in.
typedef NS_ENUM(NSInteger, DBXAuthResultTag) {
    /// The authorization succeeded. Includes a `DBXAccessToken`.
    DBXAuthSuccess,
    
    /// The authorization failed. Includes an `OAuth2Error` and a descriptive message.
    DBXAuthError,
    
    /// The authorization was manually canceled by the user.
    DBXAuthCancel,
};

/// The `DBXAuthErrorType` enum type represents the possible
/// error types that can be returned from OAuth linking.
typedef NS_ENUM(NSInteger, DBXAuthErrorType) {
    /// The client is not authorized to request an access token using this method.
    DBXAuthUnauthorizedClient,
    
    /// The resource owner or authorization server denied the request.
    DBXAuthAccessDenied,
    
    /// The authorization server does not support obtaining an access token using
    /// this method.
    DBXAuthUnsupportedResponseType,
    
    /// The requested scope is invalid, unknown, or malformed.
    DBXAuthInvalidScope,
    
    /// The authorization server encountered an unexpected condition that prevented
    /// it from fulfilling the request.
    DBXAuthServerError,
    
    /// The authorization server is currently unable to handle the request due to a
    /// temporary overloading or maintenance of the server.
    DBXAuthTemporarilyUnavailable,
    
    /// Some other error (outside of the OAuth2 specification)
    DBXAuthUnknown,
};

/// Represents the `DBXOAuthResult` object's current tag state.
@property (nonatomic) DBXAuthResultTag tag;

/// The access token that is retrieved in the event of a successful OAuth authorization.
@property (nonatomic, nonnull) DBXAccessToken *accessToken;

/// The type of OAuth error that is returned in the event of an unsuccessful OAuth
/// authorization.
@property (nonatomic) DBXAuthErrorType errorType;

/// The error description string associated with the `DBXAuthErrorType` that is returned
/// in the event of an unsuccessful OAuth authorization.
@property (nonatomic, nonnull) NSString *errorDescription;


/// Initializes the `DBXOAuthResult` object with data from a successful OAuth linking attempt.
- (nonnull instancetype)initWithSuccess:(DBXAccessToken * _Nonnull)accessToken;

/// Initializes the `DBXOAuthResult` object with data from an unsuccessful OAuth linking attempt.
- (nonnull instancetype)initWithError:(NSString * _Nonnull)errorType errorDescription:(NSString * _Nonnull)errorDescription;

/// Initializes the `DBXOAuthResult` object with data from a cancelled OAuth linking attempt.
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
/// `DBXOAuthResult` object.
- (NSString * _Nonnull)description;

@end
