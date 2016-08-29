#import <Foundation/Foundation.h>
#import "DBXOAuth.h"
#import "DBXAuthAuthError.h"
#import "DBXAuthRateLimitError.h"
#import "DBXErrors.h"

@implementation DBXRequestHttpError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    self = [super init];
    if (self) {
        _requestId = requestId;
        _statusCode = statusCode;
        _errorContent = errorContent;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": _requestId ?: @"nil", @"StatusCode": _statusCode ?: @"nil", @"ErrorContent": _errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxHttpError[%@];", values];
}

@end


@implementation DBXRequestBadInputError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent errorMessage:(NSString *)errorMessage {
    return [super init:requestId statusCode:statusCode errorContent:errorContent];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxBadInputError[%@];", values];
}

@end


@implementation DBXRequestAuthError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBXAUTHAuthError *)structuredAuthError {
    self = [super init:requestId statusCode:statusCode errorContent:errorContent];
    if (self) {
        _structuredAuthError = structuredAuthError;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil", @"StructuredAuthError": [NSString stringWithFormat:@"%@", _structuredAuthError] ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxAuthError[%@];", values];
}

@end


@implementation DBXRequestRateLimitError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredRateLimitError:(DBXAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    self = [super init:requestId statusCode:statusCode errorContent:errorContent];
    if (self) {
        _structuredRateLimitError = structuredRateLimitError;
        _backoff = backoff;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil", @"StructuredRateLimitError": _structuredRateLimitError ?: @"nil", @"BackOff": _backoff ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxRateLimitError[%@];", values];
}

@end


@implementation DBXRequestInternalServerError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [super init:requestId statusCode:statusCode errorContent:errorContent];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxInternalServerError[%@];", values];
}

@end


@implementation DBXRequestOsError

- (instancetype)init:(NSString *)errorContent {
    self = [super init];
    if (self) {
        _errorContent = errorContent;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"ErrorContent": _errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DBXOsError[%@];", values];
}

@end


@implementation DBXError

- (instancetype)initAsHttpError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBXRequestHttpErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsBadInputError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBXRequestBadInputErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsAuthError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBXAUTHAuthError *)structuredAuthError {
    return [self init:DBXRequestAuthErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:structuredAuthError structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsRateLimitError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredRateLimitError:(DBXAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    return [self init:DBXRequestRateLimitErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:structuredRateLimitError backoff:backoff];
}

- (instancetype)initAsInternalServerError:requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBXRequestInternalServerErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsOSError:(NSString *)errorContent {
    return [self init:DBXRequestOsErrorType requestId:nil statusCode:nil errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)init:(DBXRequestErrorType)tag requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBXAUTHAuthError *)structuredAuthError structuredRateLimitError:(DBXAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    self = [super init];
    if (self) {
        _tag = tag;
        _requestId = requestId;
        _statusCode = statusCode;
        _errorContent = errorContent;
        _structuredAuthError = structuredAuthError;
        _structuredRateLimitError = structuredRateLimitError;
        _backoff = backoff;
    }
    return self;
}

- (BOOL)isHttpError {
    return _tag == DBXRequestHttpErrorType;
}

- (BOOL)isBadInputError {
    return _tag == DBXRequestBadInputErrorType;
}

- (BOOL)isAuthError {
    return _tag == DBXRequestAuthErrorType;
}

- (BOOL)isRateLimitError {
    return _tag == DBXRequestRateLimitErrorType;
}

- (BOOL)isInternalServerError {
    return _tag == DBXRequestInternalServerErrorType;
}

- (BOOL)isOsError {
    return _tag == DBXRequestOsErrorType;
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
    if (![self isHttpError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestHttpErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestHttpError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBXRequestBadInputError * _Nonnull)asBadInputError {
    if (![self isBadInputError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestBadInputErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestBadInputError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBXRequestAuthError * _Nonnull)asAuthError {
    if (![self isAuthError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestAuthErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestAuthError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent structuredAuthError:_structuredAuthError];
}

- (DBXRequestRateLimitError * _Nonnull)asRateLimitError {
    if (![self isRateLimitError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestRateLimitErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestRateLimitError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent structuredRateLimitError:_structuredRateLimitError backoff:_backoff];
}

- (DBXRequestInternalServerError * _Nonnull)asInternalServerError {
    if (![self isInternalServerError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestInternalServerErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestInternalServerError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBXRequestOsError * _Nonnull)asOsError {
    if (![self isOsError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXRequestOsErrorType`, but was %@.", [self getTagName]];
    }
    return [[DBXRequestOsError alloc] init:_errorContent];
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
