///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
@class DbxAccessToken;
@class DbxAuthAuthError;
@class DbxAuthRateLimitError;

@interface DbxRequestHttpError : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull requestId;
@property (nonatomic, copy) NSNumber * _Nonnull statusCode;
@property (nonatomic, copy) NSString * _Nonnull errorBody;

@end


@interface DbxRequestRouteError<TRouteError> : DbxRequestHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorObj:(TRouteError _Nonnull)errorObj;

- (NSString * _Nonnull)description;

@property (nonatomic) TRouteError _Nonnull routeErrorObj;

@end


@interface DbxRequestBadInputError : DbxRequestHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorMessage:(NSString * _Nonnull)errorMessage;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull errorMessage;

@end


@interface DbxRequestAuthError : DbxRequestHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredAuthError:(DbxAuthAuthError * _Nonnull)structuredAuthError;

- (NSString * _Nonnull)description;

@property (nonatomic) DbxAuthAuthError * _Nonnull structuredAuthError;

@end


@interface DbxRequestRateLimitError : DbxRequestHttpError


- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredRateLimitError:(DbxAuthRateLimitError * _Nonnull)structuredRateLimitError backoff:(NSNumber * _Nonnull)backoff;

- (NSString * _Nonnull)description;

@property (nonatomic) DbxAuthRateLimitError * _Nonnull structuredRateLimitError;
@property (nonatomic) NSNumber * _Nonnull backoff;

@end


@interface DbxRequestInternalServerError : DbxRequestHttpError

- (NSString * _Nonnull)description;

@end


@interface DbxRequestOsError : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)errorDescription;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull errorDescription;

@end


@interface DbxError : NSObject

- (NSString * _Nonnull)description;

typedef NS_ENUM(NSInteger, DbxRequestErrorType) {
    /// Errors produced at the HTTP layer.
    DbxRequestHttpErrorType,
    
    /// Errors due to bad input parameters to an API Operation.
    DbxRequestBadInputErrorType,
    
    /// Errors due to invalid authentication credentials.
    DbxRequestAuthErrorType,
    
    /// Error caused by rate limiting.
    DbxRequestRateLimitErrorType,
    
    /// Errors due to a problem on Dropbox.
    DbxRequestInternalServerErrorType,
    
    /// Errors due to a problem on the local operating system.
    DbxRequestOsErrorType,
};

- (nonnull instancetype)init:(DbxRequestErrorType)tag requestId:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorBody:(NSString * _Nullable)errorBody errorMessage:(NSString * _Nullable)errorMessage structuredAuthError:(DbxAuthAuthError * _Nullable)structuredAuthError structuredRateLimitError:(DbxAuthRateLimitError * _Nullable)structuredRateLimitError backoff:(NSNumber * _Nullable)backoff errorDescription:(NSString * _Nullable)errorDescription;

- (BOOL)isHTTPError;

- (BOOL)isBadInputError;

- (BOOL)isAuthError;

- (BOOL)isRateLimitError;

- (BOOL)isInternalServerError;

- (BOOL)isOSError;

- (DbxRequestHttpError * _Nonnull)asHttpError;

- (DbxRequestBadInputError * _Nonnull)asBadInputError;

- (DbxRequestAuthError * _Nonnull)asAuthError;

- (DbxRequestRateLimitError * _Nonnull)asRateLimitError;

- (DbxRequestInternalServerError * _Nonnull)asInternalServerError;

- (DbxRequestOsError * _Nonnull)asOsError;

- (NSString * _Nonnull)getTagName;

/// Current state of the DbxStructuredError object type.
@property (nonatomic) DbxRequestErrorType tag;

@property (nonatomic, copy) NSString * _Nonnull requestId;
@property (nonatomic, copy) NSNumber * _Nonnull statusCode;
@property (nonatomic, copy) NSString * _Nonnull errorBody;
@property (nonatomic, copy) NSString * _Nonnull errorMessage;
@property (nonatomic) DbxAuthAuthError * _Nonnull structuredAuthError;
@property (nonatomic) DbxAuthRateLimitError * _Nonnull structuredRateLimitError;
@property (nonatomic) NSNumber * _Nonnull backoff;
@property (nonatomic, copy) NSString * _Nonnull errorDescription;

@end
