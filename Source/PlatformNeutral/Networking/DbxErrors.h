///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
@class DBXAccessToken;
@class DBXAUTHAuthError;
@class DBXAUTHRateLimitError;

@interface DBXRequestHttpError : NSObject

@property (nonatomic, copy) NSString * _Nonnull requestId;

@property (nonatomic, copy) NSNumber * _Nonnull statusCode;

@property (nonatomic, copy) NSString * _Nonnull errorBody;

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody;

- (NSString * _Nonnull)description;

@end


@interface DBXRequestRouteError<TRouteError> : DBXRequestHttpError

@property (nonatomic) TRouteError _Nonnull routeErrorObj;

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorObj:(TRouteError _Nonnull)errorObj;

- (NSString * _Nonnull)description;

@end


@interface DBXRequestBadInputError : DBXRequestHttpError

@property (nonatomic, copy) NSString * _Nonnull errorMessage;

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorMessage:(NSString * _Nonnull)errorMessage;

- (NSString * _Nonnull)description;

@end


@interface DBXRequestAuthError : DBXRequestHttpError

@property (nonatomic) DBXAUTHAuthError * _Nonnull structuredAuthError;

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredAuthError:(DBXAUTHAuthError * _Nonnull)structuredAuthError;

- (NSString * _Nonnull)description;

@end


@interface DBXRequestRateLimitError : DBXRequestHttpError

@property (nonatomic) DBXAUTHRateLimitError * _Nonnull structuredRateLimitError;

@property (nonatomic, copy) NSNumber * _Nonnull backoff;

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredRateLimitError:(DBXAUTHRateLimitError * _Nonnull)structuredRateLimitError backoff:(NSNumber * _Nonnull)backoff;

- (NSString * _Nonnull)description;

@end


@interface DBXRequestInternalServerError : DBXRequestHttpError

- (NSString * _Nonnull)description;

@end


@interface DBXRequestOsError : NSObject

@property (nonatomic, copy) NSString * _Nonnull errorDescription;

- (nonnull instancetype)init:(NSString * _Nonnull)errorDescription;

- (NSString * _Nonnull)description;

@end


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

/// Current state of the DBXStructuredError object type.
@property (nonatomic) DBXRequestErrorType tag;

@property (nonatomic, copy) NSString * _Nonnull requestId;

@property (nonatomic, copy) NSNumber * _Nonnull statusCode;

@property (nonatomic, copy) NSString * _Nonnull errorBody;

@property (nonatomic, copy) NSString * _Nonnull errorMessage;

@property (nonatomic) DBXAUTHAuthError * _Nonnull structuredAuthError;

@property (nonatomic) DBXAUTHRateLimitError * _Nonnull structuredRateLimitError;

@property (nonatomic, copy) NSNumber * _Nonnull backoff;

@property (nonatomic, copy) NSString * _Nonnull errorDescription;

- (nonnull instancetype)init:(DBXRequestErrorType)tag requestId:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorBody:(NSString * _Nullable)errorBody errorMessage:(NSString * _Nullable)errorMessage structuredAuthError:(DBXAUTHAuthError * _Nullable)structuredAuthError structuredRateLimitError:(DBXAUTHRateLimitError * _Nullable)structuredRateLimitError backoff:(NSNumber * _Nullable)backoff errorDescription:(NSString * _Nullable)errorDescription;

- (BOOL)isHTTPError;

- (BOOL)isBadInputError;

- (BOOL)isAuthError;

- (BOOL)isRateLimitError;

- (BOOL)isInternalServerError;

- (BOOL)isOSError;

- (DBXRequestHttpError * _Nonnull)asHttpError;

- (DBXRequestBadInputError * _Nonnull)asBadInputError;

- (DBXRequestAuthError * _Nonnull)asAuthError;

- (DBXRequestRateLimitError * _Nonnull)asRateLimitError;

- (DBXRequestInternalServerError * _Nonnull)asInternalServerError;

- (DBXRequestOsError * _Nonnull)asOsError;

- (NSString * _Nonnull)getTagName;

- (NSString * _Nonnull)description;

@end
