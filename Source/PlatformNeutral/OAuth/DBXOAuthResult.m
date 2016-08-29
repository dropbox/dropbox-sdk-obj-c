#import "DBXOAuth.h"
#import "DBXOAuthResult.h"

@implementation DBXOAuthResult

@synthesize accessToken = _accessToken;
@synthesize errorType = _errorType;
@synthesize errorDescription = _errorDescription;

static NSDictionary<NSString *, NSNumber *> *errorTypeLookup;

+ (DBXAuthErrorType)getErrorType:(NSString *) errorDescription {
    if (!errorTypeLookup) {
        errorTypeLookup = @{
            @"unauthorized_client": [NSNumber numberWithInt:DBXAuthUnauthorizedClient],
            @"access_denied": [NSNumber numberWithInt:DBXAuthAccessDenied],
            @"unsupported_response_type": [NSNumber numberWithInt:DBXAuthUnsupportedResponseType],
            @"invalid_scope": [NSNumber numberWithInt:DBXAuthInvalidScope],
            @"server_error": [NSNumber numberWithInt:DBXAuthServerError],
            @"temporarily_unavailable": [NSNumber numberWithInt:DBXAuthTemporarilyUnavailable],
            @"": [NSNumber numberWithInt:DBXAuthUnknown],
        };
    }
    return (DBXAuthErrorType)errorTypeLookup[errorDescription] ?: DBXAuthUnknown;
}

- (instancetype)initWithSuccess:(DBXAccessToken *)accessToken {
    self = [super init];
    if (self) {
        _tag = DBXAuthSuccess;
        _accessToken = accessToken;
    }
    return self;
}

- (instancetype)initWithError:(NSString *)errorType errorDescription:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        _tag = DBXAuthError;
        _errorType = [[self class] getErrorType:errorType];
        _errorDescription = errorDescription;
    }
    return self;
}

- (instancetype)initWithCancel {
    self = [super init];
    if (self) {
        _tag = DBXAuthCancel;
    }
    return self;
}

- (BOOL)isSuccess {
    return _tag == DBXAuthSuccess;
}

- (BOOL)isError {
    return _tag == DBXAuthError;
}

- (BOOL)isCancel {
    return _tag == DBXAuthCancel;
}

- (NSString *)getTagName {
    switch (_tag) {
        case DBXAuthSuccess:
            return @"DBXAuthSuccess";
        case DBXAuthError:
            return @"DBXAuthError";
        case DBXAuthCancel:
            return @"DBXAuthCancel";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Tag has an invalid value." userInfo:nil]);
}

- (DBXAccessToken *)accessToken {
    if (_tag != DBXAuthSuccess) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXAuthSuccess`, but was %@.", [self getTagName]];
    }
    return _accessToken;
}

- (DBXAuthErrorType)errorType {
    if (_tag != DBXAuthError) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXAuthError`, but was %@.", [self getTagName]];
    }
    return _errorType;
}

- (NSString *)errorDescription {
    if (_tag != DBXAuthError) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required `DBXAuthError`, but was %@.", [self getTagName]];
    }
    return _errorDescription;
}

- (NSString *)description {
    switch (_tag) {
        case DBXAuthSuccess:
            return [NSString stringWithFormat:@"Success:[Token: %@]", _accessToken.accessToken];
        case DBXAuthError:
            return [NSString stringWithFormat:@"Error:[ErrorType: %ld ErrorDescription: %@]", (long)_errorType, _errorDescription];
        case DBXAuthCancel:
            return [NSString stringWithFormat:@"Cancel:[]"];
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Tag has an invalid value." userInfo:nil]);
}

@end
