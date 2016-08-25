///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
#import "DbxOAuth.h"
#import "DbxAuthAuthError.h"
#import "DbxAuthRateLimitError.h"
#import "DbxErrors.h"

@implementation DbxRequestHttpError

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


@implementation DbxRequestBadInputError

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


@implementation DbxRequestAuthError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredAuthError:(DbxAuthAuthError *)structuredAuthError {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _structuredAuthError = structuredAuthError;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil", @"StructuredAuthError": _structuredAuthError ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxAuthError[%@];", values];
}

@end


@implementation DbxRequestRateLimitError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredRateLimitError:(DbxAuthRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
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


@implementation DbxRequestInternalServerError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody {
    return [super init:requestId statusCode:statusCode errorBody:errorBody];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorBody": self.errorBody ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxInternalServerError[%@];", values];
}

@end


@implementation DbxRequestOsError

- (instancetype)init:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        _errorDescription = errorDescription;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"ErrorDescription": _errorDescription ?: @"nil"};
    return [NSString stringWithFormat:@"DbxOsError[%@];", values];
}

@end


@implementation DbxError

- (instancetype)init:(DbxRequestErrorType)tag requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody errorMessage:(NSString *)errorMessage structuredAuthError:(DbxAuthAuthError *)structuredAuthError structuredRateLimitError:(DbxAuthRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff errorDescription:(NSString *)errorDescription {
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
    return _tag == (DbxRequestErrorType)DbxRequestHttpErrorType;
}

- (BOOL)isBadInputError {
    return _tag == (DbxRequestErrorType)DbxRequestBadInputErrorType;
}

- (BOOL)isAuthError {
    return _tag == (DbxRequestErrorType)DbxRequestAuthErrorType;
}

- (BOOL)isRateLimitError {
    return _tag == (DbxRequestErrorType)DbxRequestRateLimitErrorType;
}

- (BOOL)isInternalServerError {
    return _tag == (DbxRequestErrorType)DbxRequestInternalServerErrorType;
}

- (BOOL)isOSError {
    return _tag == (DbxRequestErrorType)DbxRequestOsErrorType;
}

- (NSString *)description {
    if (_tag == DbxRequestHttpErrorType) {
        return [NSString stringWithFormat:@"%@", [self asHttpError]];
    }
    if (_tag == DbxRequestBadInputErrorType) {
        return [NSString stringWithFormat:@"%@", [self asBadInputError]];
    }
    if (_tag == DbxRequestAuthErrorType) {
        return [NSString stringWithFormat:@"%@", [self asAuthError]];
    }
    if (_tag == DbxRequestRateLimitErrorType) {
        return [NSString stringWithFormat:@"%@", [self asRateLimitError]];
    }
    if (_tag == DbxRequestInternalServerErrorType) {
        return [NSString stringWithFormat:@"%@", [self asInternalServerError]];
    }
    if (_tag == DbxRequestOsErrorType) {
        return [NSString stringWithFormat:@"%@", [self asOsError]];
    }
    return [NSString stringWithFormat:@"GenericDropboxError[%@];", [self getTagName]];
}

- (DbxRequestHttpError * _Nonnull)asHttpError {
    return [[DbxRequestHttpError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxRequestBadInputError * _Nonnull)asBadInputError {
    return [[DbxRequestBadInputError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxRequestAuthError * _Nonnull)asAuthError {
    return [[DbxRequestAuthError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredAuthError:_structuredAuthError];
}

- (DbxRequestRateLimitError * _Nonnull)asRateLimitError {
    return [[DbxRequestRateLimitError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredRateLimitError:_structuredRateLimitError backoff:_backoff];
}

- (DbxRequestInternalServerError * _Nonnull)asInternalServerError {
    return [[DbxRequestInternalServerError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxRequestOsError * _Nonnull)asOsError {
    return [[DbxRequestOsError alloc] init:_errorDescription];
}

- (NSString *)getTagName {
    if (_tag == DbxRequestHttpErrorType) {
        return @"(DbxRequestErrorType)DbxRequestHttpErrorType";
    }
    if (_tag == DbxRequestBadInputErrorType) {
        return @"(DbxRequestErrorType)DbxRequestBadInputErrorType";
    }
    if (_tag == DbxRequestAuthErrorType) {
        return @"(DbxRequestErrorType)DbxRequestAuthErrorType";
    }
    if (_tag == DbxRequestRateLimitErrorType) {
        return @"(DbxRequestErrorType)DbxRequestRateLimitErrorType";
    }
    if (_tag == DbxRequestInternalServerErrorType) {
        return @"(DbxRequestErrorType)DbxRequestInternalServerErrorType";
    }
    if (_tag == DbxRequestOsErrorType) {
        return @"(DbxRequestErrorType)DbxRequestOsErrorType";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

@end
