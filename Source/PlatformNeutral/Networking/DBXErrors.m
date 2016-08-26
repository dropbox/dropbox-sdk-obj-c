///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
#import "DBXOAuth.h"
#import "DBXAuthAuthError.h"
#import "DBXAuthRateLimitError.h"
#import "DBXErrors.h"

@implementation DBXRequestHttpError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody {
    self = [super init];
    if (self) {
        _requestId = requestId;
        _statusCode = statusCode;
        _errorBody = errorBody;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxHttpError[%@];", values];
}

@end


@implementation DBXRequestBadInputError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody errorMessage:(NSString *)errorMessage {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _errorMessage = errorMessage;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil", @"ErrorMessage": _errorMessage ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxBadInputError[%@];", values];
}

@end


@implementation DBXRequestAuthError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredAuthError:(DBXAUTHAuthError *)structuredAuthError {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _structuredAuthError = structuredAuthError;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil", @"StructuredAuthError": [NSString stringWithFormat:@"%@", _structuredAuthError] ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxAuthError[%@];", values];
}

@end


@implementation DBXRequestRateLimitError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredRateLimitError:(DBXAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _structuredRateLimitError = structuredRateLimitError;
        _backoff = backoff;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil", @"StructuredRateLimitError": _structuredRateLimitError ?: @"nil", @"BackOff": _backoff ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxRateLimitError[%@];", values];
}

@end


@implementation DBXRequestInternalServerError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody {
    return [super init:requestId statusCode:statusCode errorBody:errorBody];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxInternalServerError[%@];", values];
}

@end


@implementation DBXRequestOsError

- (instancetype)init:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        _errorDescription = errorDescription;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"ErrorDescription": _errorDescription ?: @"nil"};
    return [NSString stringWithFormat:@"DBXOsError[%@];", values];
}

@end


@implementation DBXError

- (instancetype)init:(DBXRequestErrorType)tag requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody errorMessage:(NSString *)errorMessage structuredAuthError:(DBXAUTHAuthError *)structuredAuthError structuredRateLimitError:(DBXAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff errorDescription:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        self.tag = tag;
        _requestId = requestId;
        _statusCode = statusCode;
        _errorBody = errorBody;
        _errorMessage = errorMessage;
        _structuredAuthError = structuredAuthError;
        _structuredRateLimitError = structuredRateLimitError;
        _backoff = backoff;
        _errorDescription = errorDescription;
    }
    return self;
}

- (BOOL)isHTTPError {
    return _tag == (DBXRequestErrorType)DBXRequestHttpErrorType;
}

- (BOOL)isBadInputError {
    return _tag == (DBXRequestErrorType)DBXRequestBadInputErrorType;
}

- (BOOL)isAuthError {
    return _tag == (DBXRequestErrorType)DBXRequestAuthErrorType;
}

- (BOOL)isRateLimitError {
    return _tag == (DBXRequestErrorType)DBXRequestRateLimitErrorType;
}

- (BOOL)isInternalServerError {
    return _tag == (DBXRequestErrorType)DBXRequestInternalServerErrorType;
}

- (BOOL)isOSError {
    return _tag == (DBXRequestErrorType)DBXRequestOsErrorType;
}

- (NSString *)description {
    switch (_tag) {
        case DBXRequestHttpErrorType:
            return [NSString stringWithFormat:@"%@", [self asHttpError]];
        case DBXRequestBadInputErrorType:
            return [NSString stringWithFormat:@"%@", [self asBadInputError]];
        case DBXRequestAuthErrorType:
            return [NSString stringWithFormat:@"%@", [self asAuthError]];
        case DBXRequestRateLimitErrorType:
            return [NSString stringWithFormat:@"%@", [self asRateLimitError]];
        case DBXRequestInternalServerErrorType:
            return @"DBXRequestInternalServerErrorType";
        case DBXRequestOsErrorType:
            return [NSString stringWithFormat:@"%@", [self asOsError]];
    }

    return [NSString stringWithFormat:@"GenericDropboxError[%@];", [self getTagName]];
}

- (DBXRequestHttpError * _Nonnull)asHttpError {
    return [[DBXRequestHttpError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DBXRequestBadInputError * _Nonnull)asBadInputError {
    return [[DBXRequestBadInputError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DBXRequestAuthError * _Nonnull)asAuthError {
    return [[DBXRequestAuthError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredAuthError:_structuredAuthError];
}

- (DBXRequestRateLimitError * _Nonnull)asRateLimitError {
    return [[DBXRequestRateLimitError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredRateLimitError:_structuredRateLimitError backoff:_backoff];
}

- (DBXRequestInternalServerError * _Nonnull)asInternalServerError {
    return [[DBXRequestInternalServerError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DBXRequestOsError * _Nonnull)asOsError {
    return [[DBXRequestOsError alloc] init:_errorDescription];
}

- (NSString *)getTagName {
    switch (_tag) {
        case DBXRequestHttpErrorType:
            return @"DBXRequestHttpErrorType";
        case DBXRequestBadInputErrorType:
            return @"DBXRequestBadInputErrorType";
        case DBXRequestAuthErrorType:
            return @"DBXRequestAuthErrorType";
        case DBXRequestRateLimitErrorType:
            return @"DBXRequestRateLimitErrorType";
        case DBXRequestInternalServerErrorType:
            return @"DBXRequestInternalServerErrorType";
        case DBXRequestOsErrorType:
            return @"DBXRequestOsErrorType";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Tag has an invalid value." userInfo:nil]);
}

@end
