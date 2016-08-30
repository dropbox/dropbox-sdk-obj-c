///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "DBOAuth.h"
#import "DBAuthAuthError.h"
#import "DBAuthRateLimitError.h"
#import "DBErrors.h"

#pragma mark - HTTP error

@implementation DBRequestHttpError

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


#pragma mark - Bad Input error

@implementation DBRequestBadInputError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [super init:requestId statusCode:statusCode errorContent:errorContent];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxBadInputError[%@];", values];
}

@end


#pragma mark - Auth error

@implementation DBRequestAuthError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBAUTHAuthError *)structuredAuthError {
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


#pragma mark - Rate Limit error

@implementation DBRequestRateLimitError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredRateLimitError:(DBAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
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


#pragma mark - Internal Server error

@implementation DBRequestInternalServerError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [super init:requestId statusCode:statusCode errorContent:errorContent];
}

- (NSString *)description {
    NSDictionary *values = @{@"RequestId": self.requestId ?: @"nil", @"StatusCode": self.statusCode ?: @"nil", @"ErrorContent": self.errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DropboxInternalServerError[%@];", values];
}

@end


#pragma mark - OS error

@implementation DBRequestOsError

- (instancetype)init:(NSString *)errorContent {
    self = [super init];
    if (self) {
        _errorContent = errorContent;
    }
    return self;
}

- (NSString *)description {
    NSDictionary *values = @{@"ErrorContent": _errorContent ?: @"nil"};
    return [NSString stringWithFormat:@"DBOsError[%@];", values];
}

@end


#pragma mark - DBError generic error

@implementation DBError

#pragma mark - Constructors

- (instancetype)initAsHttpError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBRequestHttpErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsBadInputError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBRequestBadInputErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsAuthError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBAUTHAuthError *)structuredAuthError {
    return [self init:DBRequestAuthErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:structuredAuthError structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsRateLimitError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredRateLimitError:(DBAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    return [self init:DBRequestRateLimitErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:structuredRateLimitError backoff:backoff];
}

- (instancetype)initAsInternalServerError:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent {
    return [self init:DBRequestInternalServerErrorType requestId:requestId statusCode:statusCode errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)initAsOSError:(NSString *)errorContent {
    return [self init:DBRequestOsErrorType requestId:nil statusCode:nil errorContent:errorContent structuredAuthError:nil structuredRateLimitError:nil backoff:nil];
}

- (instancetype)init:(DBRequestErrorType)tag requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorContent:(NSString *)errorContent structuredAuthError:(DBAUTHAuthError *)structuredAuthError structuredRateLimitError:(DBAUTHRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
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

#pragma mark - Tag state methods

- (BOOL)isHttpError {
    return _tag == DBRequestHttpErrorType;
}

- (BOOL)isBadInputError {
    return _tag == DBRequestBadInputErrorType;
}

- (BOOL)isAuthError {
    return _tag == DBRequestAuthErrorType;
}

- (BOOL)isRateLimitError {
    return _tag == DBRequestRateLimitErrorType;
}

- (BOOL)isInternalServerError {
    return _tag == DBRequestInternalServerErrorType;
}

- (BOOL)isOsError {
    return _tag == DBRequestOsErrorType;
}

#pragma mark - Error subtype retrieval methods

- (DBRequestHttpError * _Nonnull)asHttpError {
    if (![self isHttpError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestHttpErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestHttpError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBRequestBadInputError * _Nonnull)asBadInputError {
    if (![self isBadInputError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestBadInputErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestBadInputError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBRequestAuthError * _Nonnull)asAuthError {
    if (![self isAuthError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestAuthErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestAuthError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent structuredAuthError:_structuredAuthError];
}

- (DBRequestRateLimitError * _Nonnull)asRateLimitError {
    if (![self isRateLimitError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestRateLimitErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestRateLimitError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent structuredRateLimitError:_structuredRateLimitError backoff:_backoff];
}

- (DBRequestInternalServerError * _Nonnull)asInternalServerError {
    if (![self isInternalServerError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestInternalServerErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestInternalServerError alloc] init:_requestId statusCode:_statusCode errorContent:_errorContent];
}

- (DBRequestOsError * _Nonnull)asOsError {
    if (![self isOsError]) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBRequestOsErrorType`, but was %@.", [self tagName]];
    }
    return [[DBRequestOsError alloc] init:_errorContent];
}

#pragma mark - Tag name method

- (NSString *)tagName {
    switch (_tag) {
        case DBRequestHttpErrorType:
            return @"DBRequestHttpErrorType";
        case DBRequestBadInputErrorType:
            return @"DBRequestBadInputErrorType";
        case DBRequestAuthErrorType:
            return @"DBRequestAuthErrorType";
        case DBRequestRateLimitErrorType:
            return @"DBRequestRateLimitErrorType";
        case DBRequestInternalServerErrorType:
            return @"DBRequestInternalServerErrorType";
        case DBRequestOsErrorType:
            return @"DBRequestOsErrorType";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Tag has an invalid value." userInfo:nil]);
}

#pragma mark - Description method

- (NSString *)description {
    switch (_tag) {
        case DBRequestHttpErrorType:
            return [NSString stringWithFormat:@"%@", [self asHttpError]];
        case DBRequestBadInputErrorType:
            return [NSString stringWithFormat:@"%@", [self asBadInputError]];
        case DBRequestAuthErrorType:
            return [NSString stringWithFormat:@"%@", [self asAuthError]];
        case DBRequestRateLimitErrorType:
            return [NSString stringWithFormat:@"%@", [self asRateLimitError]];
        case DBRequestInternalServerErrorType:
            return @"DBRequestInternalServerErrorType";
        case DBRequestOsErrorType:
            return [NSString stringWithFormat:@"%@", [self asOsError]];
    }
    
    return [NSString stringWithFormat:@"GenericDropboxError[%@];", [self tagName]];
}

@end
