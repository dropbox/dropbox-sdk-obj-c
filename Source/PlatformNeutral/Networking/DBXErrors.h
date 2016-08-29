///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
@class DBXAccessToken;
@class DBXAUTHAuthError;
@class DBXAUTHRateLimitError;

///
/// Http request error.
///
/// Contains relevant information regarding a failed network
/// request. All error types except for `DBXOsError` extend this
/// class as children. Initialized in the event of a generic,
/// unidentified HTTP error.
///
@interface DBXRequestHttpError : NSObject

/// The Dropbox request id of the network call. This is useful to Dropbox
/// for debugging issues with Dropbox's SDKs and API. Please include the
/// value of this field when submitting technical support inquiries to
/// Dropbox.
@property (nonatomic, readonly, copy) NSString * _Nonnull requestId;

/// The HTTP response status code of the request.
@property (nonatomic, readonly, copy) NSNumber * _Nonnull statusCode;

/// A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the
/// "error_summary" key.
@property (nonatomic, readonly, copy) NSString * _Nonnull errorContent;

///
/// `DBXRequestHttpError` full constructor.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXRequestHttpError` instance.
///
- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorContent:(NSString * _Nonnull)errorContent;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestHttpError` object.
///
- (NSString * _Nonnull)description;

@end


///
/// Bad Input request error.
///
/// Contains relevant information regarding a failed network
/// request. Initialized in the event of an HTTP 400 response.
/// Extends `DBXRequestHttpError`.
///
@interface DBXRequestBadInputError : DBXRequestHttpError

///
/// `DBXRequestBadInputError` full constructor.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXRequestBadInputError` instance.
///
- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorContent:(NSString * _Nonnull)errorContent;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestBadInputError` object.
///
- (NSString * _Nonnull)description;

@end


///
/// Auth request error.
///
/// Contains relevant information regarding a failed network
/// request. Initialized in the event of an HTTP 401 response.
/// Extends `DBXRequestHttpError`.
///
@interface DBXRequestAuthError : DBXRequestHttpError

/// The structured object returned by the Dropbox API in the event of a 401 auth
/// error.
@property (nonatomic, readonly) DBXAUTHAuthError * _Nonnull structuredAuthError;

///
/// `DBXRequestAuthError` full constructor.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
/// - parameter structuredAuthError: The structured object returned by the Dropbox API in the
/// event of a 401 auth error.
///
/// - returns: An initialized `DBXRequestAuthError` instance.
///
- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorContent:(NSString * _Nonnull)errorContent structuredAuthError:(DBXAUTHAuthError * _Nonnull)structuredAuthError;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestAuthError` object.
///
- (NSString * _Nonnull)description;

@end


///
/// Rate limit request error.
///
/// Contains relevant information regarding a failed network
/// request. Initialized in the event of an HTTP 429 response.
/// Extends `DBXRequestHttpError`.
///
@interface DBXRequestRateLimitError : DBXRequestHttpError

/// The structured object returned by the Dropbox API in the event of a 429
/// rate-limit error.
@property (nonatomic, readonly) DBXAUTHRateLimitError * _Nonnull structuredRateLimitError;

/// The number of seconds to wait before making any additional requests in the
/// event of a rate-limit error.
@property (nonatomic, readonly, copy) NSNumber * _Nonnull backoff;


///
/// `DBXRequestRateLimitError` full constructor.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
/// - parameter structuredRateLimitError: The structured object returned by the Dropbox API in the
/// event of a 429 rate-limit error.
/// - parameter backoff: The number of seconds to wait before making any additional requests in the
/// event of a rate-limit error.
///
/// - returns: An initialized `DBXRequestRateLimitError` instance.
///
- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorContent:(NSString * _Nonnull)errorContent structuredRateLimitError:(DBXAUTHRateLimitError * _Nonnull)structuredRateLimitError backoff:(NSNumber * _Nonnull)backoff;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestRateLimitError` object.
///
- (NSString * _Nonnull)description;

@end


///
/// Rate limit request error.
///
/// Contains relevant information regarding a failed network
/// request. Initialized in the event of an HTTP 500 response.
/// Extends `DBXRequestHttpError`.
///
@interface DBXRequestInternalServerError : DBXRequestHttpError

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestInternalServerError` object.
///
- (NSString * _Nonnull)description;

@end


@interface DBXRequestOsError : NSObject

/// A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the
/// "error_summary" key.
@property (nonatomic, readonly, copy) NSString * _Nonnull errorContent;

///
/// `DBXRequestOsError` full constructor. An example of such an error
/// might be if you attempt to make a request and are not connected to the internet.
///
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXRequestOsError` instance.
///
- (nonnull instancetype)init:(NSString * _Nonnull)errorContent;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXRequestOsError` object.
///
- (NSString * _Nonnull)description;

@end


///
/// Base class for generic network request error (as opposed to route-specific
/// error).
///
/// This class is represented almost like a Stone "Union" object. As one object,
/// it can represent a number of error "states" (see all of the values of
/// `DBXRequestErrorType`). To handle each error type, call each of the
/// `is<TAG_STATE>` methods until you determine the current tag state, then
/// call the corresponding `as<TAG_STATE>` method to return an instance of the
/// appropriate error type.
///
/// For example:
/// ```
/// if ([dbxError isHTTPError]) {
///     DBXHttpError *httpError = [dbxError asHttpError];
/// } else if ([dbxError isBadInputError]) { ........
///
@interface DBXError : NSObject

typedef NS_ENUM(NSInteger, DBXRequestErrorType) {
    /// Errors produced at the HTTP layer.
    DBXRequestHttpErrorType,
    
    /// Errors due to bad input parameters to an API Operation.
    DBXRequestBadInputErrorType,
    
    /// Errors due to invalid authentication credentials.
    DBXRequestAuthErrorType,
    
    /// Error caused by rate limiting.
    DBXRequestRateLimitErrorType,
    
    /// Errors due to a problem on Dropbox.
    DBXRequestInternalServerErrorType,
    
    /// Errors due to a problem on the local operating system.
    DBXRequestOsErrorType,
};

/// Current state of the `DBXError` object type.
@property (nonatomic, readonly) DBXRequestErrorType tag;

/// The Dropbox request id of the network call. This is useful to Dropbox
/// for debugging issues with Dropbox's SDKs and API. Please include the
/// value of this field when submitting technical support inquiries to
/// Dropbox.
@property (nonatomic, readonly, copy) NSString * _Nonnull requestId;

/// The HTTP response status code of the request.
@property (nonatomic, readonly, copy) NSNumber * _Nonnull statusCode;

/// A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the
/// "error_summary" key.
@property (nonatomic, readonly, copy) NSString * _Nonnull errorContent;

/// The structured object returned by the Dropbox API in the event of a 401 auth
/// error.
@property (nonatomic, readonly) DBXAUTHAuthError * _Nonnull structuredAuthError;

/// The structured object returned by the Dropbox API in the event of a 429
/// rate-limit error.
@property (nonatomic, readonly) DBXAUTHRateLimitError * _Nonnull structuredRateLimitError;

/// The number of seconds to wait before making any additional requests in the
/// event of a rate-limit error.
@property (nonatomic, readonly, copy) NSNumber * _Nonnull backoff;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing a generic HTTP error.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXError` instance HTTP error state.
///
- (nonnull instancetype)initAsHttpError:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing a Bad Input error.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXError` instance with Bad Input error state.
///
- (nonnull instancetype)initAsBadInputError:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing an Auth error.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
/// - parameter structuredAuthError: The structured object returned by the Dropbox API in the
/// event of a 401 auth error.
///
/// - returns: An initialized `DBXError` instance with Auth error state.
///
- (nonnull instancetype)initAsAuthError:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent structuredAuthError:(DBXAUTHAuthError * _Nonnull)structuredAuthError;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing a Rate Limit error.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
/// - parameter structuredRateLimitError: The structured object returned by the Dropbox API in the
/// event of a 429 rate-limit error.
/// - parameter backoff: The number of seconds to wait before making any additional requests in the
/// event of a rate-limit error.
///
/// - returns: An initialized `DBXError` instance.
///
- (nonnull instancetype)initAsRateLimitError:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent structuredRateLimitError:(DBXAUTHRateLimitError * _Nonnull)structuredRateLimitError backoff:(NSNumber * _Nonnull)backoff;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing an Internal Server error.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXError` instance with Internal Server error state.
///
- (nonnull instancetype)initAsInternalServerError:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent;

///
/// `DBXError` convenience constructor. Initializes the `DBXError` with all the
/// required state for representing an "OS" error. An example of such an error
/// might be if you attempt to make a request and are not connected to the internet.
///
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
///
/// - returns: An initialized `DBXError` instance with OS error state.
///
- (nonnull instancetype)initAsOSError:(NSString * _Nullable)errorContent;

///
/// `DBXError` full constructor.
///
/// - parameter requestId: The Dropbox request id of the network call. This is
/// useful to Dropbox for debugging issues with Dropbox's SDKs and API.
/// - parameter statusCode: The HTTP response status code of the request.
/// - parameter errorContent: A string representation of the error body received in the reponse.
/// If for a route-specific error, this field will be the value of the "error_summary" key.
/// - parameter structuredAuthError: The structured object returned by the Dropbox API in the
/// event of a 401 auth error.
/// - parameter structuredRateLimitError: The structured object returned by the Dropbox API in the
/// event of a 429 rate-limit error.
/// - parameter backoff: The number of seconds to wait before making any additional requests in the
/// event of a rate-limit error.
///
/// - returns: An initialized `DBXError` instance.
///
- (nonnull instancetype)init:(DBXRequestErrorType)tag requestId:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorContent:(NSString * _Nullable)errorContent structuredAuthError:(DBXAUTHAuthError * _Nullable)structuredAuthError structuredRateLimitError:(DBXAUTHRateLimitError * _Nullable)structuredRateLimitError backoff:(NSNumber * _Nullable)backoff;

///
/// Retrieves whether the error's current tag state has value `HttpError`.
///
/// - returns: Whether the union's current tag state has value `HttpError`.
///
- (BOOL)isHttpError;

///
/// Retrieves whether the error's current tag state has value `BadInputError`.
///
/// - returns: Whether the union's current tag state has value `BadInputError`.
///
- (BOOL)isBadInputError;

///
/// Retrieves whether the error's current tag state has value `AuthError`.
///
/// - returns: Whether the union's current tag state has value `AuthError`.
///
- (BOOL)isAuthError;

///
/// Retrieves whether the error's current tag state has value `RateLimitError`.
///
/// - returns: Whether the union's current tag state has value `RateLimitError`.
///
- (BOOL)isRateLimitError;

///
/// Retrieves whether the error's current tag state has value `InternalServerError`.
///
/// - returns: Whether the union's current tag state has value `InternalServerError`.
///
- (BOOL)isInternalServerError;

///
/// Retrieves whether the error's current tag state has value `OSError`.
///
/// - returns: Whether the union's current tag state has value `OSError`.
///
- (BOOL)isOsError;

///
/// Creates a `DBXRequestHttpError` instance based on the data in the current `DBXError`
/// instance. Will throw error if current `DBXError` instance tag state is not
/// `HttpError`. Should only use after checking if `isHttpError` returns true
/// for the current `DBXError` instance.
///
/// - returns: An initialized `DBXRequestHttpError` instance.
///
- (DBXRequestHttpError * _Nonnull)asHttpError;

///
/// Creates a `DBXRequestBadInputError` instance based on the data in the current `DBXError`
/// instance. Will throw error if current `DBXError` instance tag state is not
/// `BadInputError`. Should only use after checking if `isBadInputError` returns true
/// for the current `DBXError` instance.
///
/// - returns: An initialized `DBXRequestBadInputError`.
///
- (DBXRequestBadInputError * _Nonnull)asBadInputError;

///
/// Creates a `DBXRequestAuthError` instance based on the data in the current `DBXError`
/// instance. Will throw error if current `DBXError` instance tag state is not
/// `AuthError`. Should only use after checking if `isAuthError` returns true
/// for the current `DBXError` instance.
///
/// - returns: An initialized `DBXRequestAuthError` instance.
///
- (DBXRequestAuthError * _Nonnull)asAuthError;

///
/// Creates a `DBXRequestRateLimitError` instance based on the data in the current `DBXError`
/// instance. Will throw error if current `DBXError` instance tag state is not
/// `RateLimitError`. Should only use after checking if `isRateLimitError` returns true
/// for the current `DBXError` instance.
///
/// - returns: An initialized `DBXRequestRateLimitError` instance.
///
- (DBXRequestRateLimitError * _Nonnull)asRateLimitError;

///
/// Creates a `DBXRequestInternalServerError` instance based on the data in the
/// current `DBXError` instance. Will throw error if current `DBXError` instance tag state
/// is not `InternalServerError`. Should only use after checking if `isInternalServerError`
/// returns true for the current `DBXError` instance.
///
/// - returns: An initialized `DBXHttpError` instance.
///
- (DBXRequestInternalServerError * _Nonnull)asInternalServerError;

///
/// Creates a `DBXRequestOsError` instance based on the data in the current `DBXError`
/// instance. Will throw error if current `DBXError` instance tag state is not
/// `OsError`. Should only use after checking if `isOsError` returns true
/// for the current `DBXError` instance.
///
/// - returns: An initialized `DBXRequestOsError` instance.
///
- (DBXRequestOsError * _Nonnull)asOsError;

///
/// Retrieves string value of union's current tag state.
///
/// - returns: A human-readable string representing the union's current tag
/// state.
///
- (NSString * _Nonnull)getTagName;

///
/// Description method.
///
/// - returns: A human-readable representation of the current `DBXError` object.
///
- (NSString * _Nonnull)description;

@end
