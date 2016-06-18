///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
@class DbxAccessToken;
@class DbxAuthAuthError;
@class DbxAuthRateLimitError;

@interface DbxHttpError : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull requestId;
@property (nonatomic, copy) NSNumber * _Nonnull statusCode;
@property (nonatomic, copy) NSString * _Nonnull errorBody;

@end


@interface DbxRouteError<TRouteError> : DbxHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorObj:(TRouteError _Nonnull)errorObj;

- (NSString * _Nonnull)description;

@property (nonatomic) TRouteError _Nonnull routeErrorObj;

@end


@interface DbxBadInputError : DbxHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody errorMessage:(NSString * _Nonnull)errorMessage;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull errorMessage;

@end


@interface DbxAuthError : DbxHttpError

- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredAuthError:(DbxAuthAuthError * _Nonnull)structuredAuthError;

- (NSString * _Nonnull)description;

@property (nonatomic) DbxAuthAuthError * _Nonnull structuredAuthError;

@end


@interface DbxRateLimitError : DbxHttpError


- (nonnull instancetype)init:(NSString * _Nonnull)requestId statusCode:(NSNumber * _Nonnull)statusCode errorBody:(NSString * _Nonnull)errorBody structuredRateLimitError:(DbxAuthRateLimitError * _Nonnull)structuredRateLimitError backoff:(NSNumber * _Nonnull)backoff;

- (NSString * _Nonnull)description;

@property (nonatomic) DbxAuthRateLimitError * _Nonnull structuredRateLimitError;
@property (nonatomic) NSNumber * _Nonnull backoff;

@end


@interface DbxInternalServerError : DbxHttpError

- (NSString * _Nonnull)description;

@end


@interface DbxOsError : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)errorDescription;

- (NSString * _Nonnull)description;

@property (nonatomic, copy) NSString * _Nonnull errorDescription;

@end


@interface DbxError : NSObject

- (NSString * _Nonnull)description;

typedef NS_ENUM(NSInteger, DbxErrorTypeTag) {
    /// Errors produced at the HTTP layer.
    DbxErrorHttpError,
    
    /// Errors due to bad input parameters to an API Operation.
    DbxErrorBadInputError,
    
    /// Errors due to invalid authentication credentials.
    DbxErrorAuthError,
    
    /// Error caused by rate limiting.
    DbxErrorRateLimitError,
    
    /// Errors due to a problem on Dropbox.
    DbxErrorInternalServerError,
    
    /// Errors due to a problem on the local operating system.
    DbxErrorOsError,
};

- (nonnull instancetype)init:(DbxErrorTypeTag)tag requestId:(NSString * _Nullable)requestId statusCode:(NSNumber * _Nullable)statusCode errorBody:(NSString * _Nullable)errorBody errorMessage:(NSString * _Nullable)errorMessage structuredAuthError:(DbxAuthAuthError * _Nullable)structuredAuthError structuredRateLimitError:(DbxAuthRateLimitError * _Nullable)structuredRateLimitError backoff:(NSNumber * _Nullable)backoff errorDescription:(NSString * _Nullable)errorDescription;

- (BOOL)isHTTPError;

- (BOOL)isBadInputError;

- (BOOL)isAuthError;

- (BOOL)isRateLimitError;

- (BOOL)isInternalServerError;

- (BOOL)isOSError;

- (DbxHttpError * _Nonnull)asHttpError;

- (DbxBadInputError * _Nonnull)asBadInputError;

- (DbxAuthError * _Nonnull)asAuthError;

- (DbxRateLimitError * _Nonnull)asRateLimitError;

- (DbxInternalServerError * _Nonnull)asInternalServerError;

- (DbxOsError * _Nonnull)asOsError;

- (NSString * _Nonnull)getTagName;

/// Current state of the DbxStructuredError object type.
@property (nonatomic) DbxErrorTypeTag tag;

@property (nonatomic, copy) NSString * _Nonnull requestId;
@property (nonatomic, copy) NSNumber * _Nonnull statusCode;
@property (nonatomic, copy) NSString * _Nonnull errorBody;
@property (nonatomic, copy) NSString * _Nonnull errorMessage;
@property (nonatomic) DbxAuthAuthError * _Nonnull structuredAuthError;
@property (nonatomic) DbxAuthRateLimitError * _Nonnull structuredRateLimitError;
@property (nonatomic) NSNumber * _Nonnull backoff;
@property (nonatomic, copy) NSString * _Nonnull errorDescription;

@end
