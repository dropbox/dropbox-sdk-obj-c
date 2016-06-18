///
/// Classes for possible SDK errors.
///

#import <Foundation/Foundation.h>
#import "DbxOAuth.h"
#import "DbxAuthAuthError.h"
#import "DbxAuthRateLimitError.h"
#import "DbxErrors.h"

@implementation DbxHttpError

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
    return [NSString stringWithFormat:@"DropboxHttpError[RequestId: %@ StatusCode: %@ ErrorBody: %@];", self.requestId, _statusCode, _errorBody];
}

@end


@implementation DbxBadInputError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody errorMessage:(NSString *)errorMessage {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _errorMessage = errorMessage;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DropboxBadInputError[RequestId: %@ StatusCode: %@ ErrorBody: %@ ErrorMessage: %@];", self.requestId, self.statusCode, self.errorBody, _errorMessage];
}

@end


@implementation DbxAuthError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredAuthError:(DbxAuthAuthError *)structuredAuthError {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _structuredAuthError = structuredAuthError;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DropboxAuthError[RequestId: %@ StatusCode: %@ ErrorBody: %@ StructuredAuthError: %@];", self.requestId, self.statusCode, self.errorBody, _structuredAuthError];
}

@end


@implementation DbxRateLimitError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody structuredRateLimitError:(DbxAuthRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff {
    self = [super init:requestId statusCode:statusCode errorBody:errorBody];
    if (self) {
        _structuredRateLimitError = structuredRateLimitError;
        _backoff = backoff;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DropboxRateLimitError[RequestId: %@ StatusCode: %@ ErrorBody: %@ StructuredRateLimitError: %@ BackOff: %@];", self.requestId, self.statusCode, self.errorBody, _structuredRateLimitError, _backoff];
}

@end


@implementation DbxInternalServerError

- (instancetype)init:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody {
    return [super init:requestId statusCode:statusCode errorBody:errorBody];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DropboxInternalServerError[RequestId: %@ StatusCode: %@ ErrorBody: %@];", self.requestId, self.statusCode, self.errorBody];
}

@end


@implementation DbxOsError

- (instancetype)init:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        _errorDescription = errorDescription;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"DbxOsError[Error: %@];", @"TODO"];
}

@end


@implementation DbxError

- (instancetype)init:(DbxErrorTypeTag)tag requestId:(NSString *)requestId statusCode:(NSNumber *)statusCode errorBody:(NSString *)errorBody errorMessage:(NSString *)errorMessage structuredAuthError:(DbxAuthAuthError *)structuredAuthError structuredRateLimitError:(DbxAuthRateLimitError *)structuredRateLimitError backoff:(NSNumber *)backoff errorDescription:(NSString *)errorDescription {
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
    return _tag == (DbxErrorTypeTag)DbxErrorHttpError;
}

- (BOOL)isBadInputError {
    return _tag == (DbxErrorTypeTag)DbxErrorBadInputError;
}

- (BOOL)isAuthError {
    return _tag == (DbxErrorTypeTag)DbxErrorAuthError;
}

- (BOOL)isRateLimitError {
    return _tag == (DbxErrorTypeTag)DbxErrorRateLimitError;
}

- (BOOL)isInternalServerError {
    return _tag == (DbxErrorTypeTag)DbxErrorInternalServerError;
}

- (BOOL)isOSError {
    return _tag == (DbxErrorTypeTag)DbxErrorOsError;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"GenericDropboxError[%@];", [self getTagName]];
}

- (DbxHttpError * _Nonnull)asHttpError {
    return [[DbxHttpError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxBadInputError * _Nonnull)asBadInputError {
    return [[DbxBadInputError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxAuthError * _Nonnull)asAuthError {
    return [[DbxAuthError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredAuthError:_structuredAuthError];
}

- (DbxRateLimitError * _Nonnull)asRateLimitError {
    return [[DbxRateLimitError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody structuredRateLimitError:_structuredRateLimitError backoff:_backoff];
}

- (DbxInternalServerError * _Nonnull)asInternalServerError {
    return [[DbxInternalServerError alloc] init:_requestId statusCode:_statusCode errorBody:_errorBody];
}

- (DbxOsError * _Nonnull)asOsError {
    return [[DbxOsError alloc] init:_errorDescription];
}

- (NSString *)getTagName {
    if (_tag == (DbxErrorTypeTag)DbxErrorHttpError) {
        return @"(DbxErrorTypeTag)DbxErrorHttpError";
    }
    if (_tag == (DbxErrorTypeTag)DbxErrorBadInputError) {
        return @"(DbxErrorTypeTag)DbxErrorBadInputError";
    }
    if (_tag == (DbxErrorTypeTag)DbxErrorAuthError) {
        return @"(DbxErrorTypeTag)DbxErrorAuthError";
    }
    if (_tag == (DbxErrorTypeTag)DbxErrorRateLimitError) {
        return @"(DbxErrorTypeTag)DbxErrorRateLimitError";
    }
    if (_tag == (DbxErrorTypeTag)DbxErrorInternalServerError) {
        return @"(DbxErrorTypeTag)DbxErrorInternalServerError";
    }
    if (_tag == (DbxErrorTypeTag)DbxErrorOsError) {
        return @"(DbxErrorTypeTag)DbxErrorOsError";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

@end
