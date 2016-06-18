///
/// Result types for OAuth linking.
///

#import "DbxOAuth.h"
#import "DbxOAuthResult.h"

@implementation DbxOAuthResult

static NSDictionary<NSString *, NSNumber *> *errorTypeLookup;

+ (DbxAuthErrorType)getErrorType:(NSString *) errorDescription {
    if (!errorTypeLookup) {
        errorTypeLookup = @{
            @"unauthorized_client": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthUnauthorizedClient],
            @"access_denied": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthAccessDenied],
            @"unsupported_response_type": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthUnsupportedResponseType],
            @"invalid_scope": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthInvalidScope],
            @"server_error": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthServerError],
            @"temporarily_unavailable": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthTemporarilyUnavailable],
            @"": [NSNumber numberWithInt:(DbxAuthErrorType)DbxAuthUnknown],
        };
    }

    NSNumber *result = errorTypeLookup[errorDescription];
    
    if (!result) {
        return (DbxAuthErrorType)DbxAuthUnknown;
    }
    
    return (DbxAuthErrorType)result;
}

- (nonnull instancetype)initWithSuccess:(DbxAccessToken *)accessToken {
    self = [super init];
    if (self) {
        _tag = (DbxAuthResultTag)DbxAuthSuccess;
        _accessToken = accessToken;
    }
    return self;
}

- (nonnull instancetype)initWithError:(NSString *)errorType errorDescription:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        _tag = (DbxAuthResultTag)DbxAuthError;
        _errorType = [[self class] getErrorType:errorType];
        _errorDescription = errorDescription;
    }
    return self;
}

- (nonnull instancetype)initWithCancel {
    self = [super init];
    if (self) {
        _tag = (DbxAuthResultTag)DbxAuthCancel;
    }
    return self;
}

- (BOOL)isSuccess {
    return _tag == (DbxAuthResultTag)DbxAuthSuccess;
}

- (BOOL)isError {
    return _tag == (DbxAuthResultTag)DbxAuthError;
}

- (BOOL)isCancel {
    return _tag == (DbxAuthResultTag)DbxAuthCancel;
}

- (NSString *)getTagName {
    if (_tag == (DbxAuthResultTag)DbxAuthSuccess) {
        return @"(DbxAuthResultTag)DbxAuthSuccess";
    }
    if (_tag == (DbxAuthResultTag)DbxAuthError) {
        return @"(DbxAuthResultTag)DbxAuthError";
    }
    if (_tag == (DbxAuthResultTag)DbxAuthCancel) {
        return @"(DbxAuthResultTag)DbxAuthCancel";
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

- (DbxAccessToken *)accessToken {
    if (_tag != (DbxAuthResultTag)DbxAuthSuccess) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required (DbxAuthResultTag)DbxAuthSuccess, but was %@.", [self getTagName]];
    }
    return _accessToken;
}

- (NSString *)errorMessage {
    if (_tag != (DbxAuthResultTag)DbxAuthError) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required (DbxAuthResultTag)DbxAuthError, but was %@.", [self getTagName]];
    }
    return _errorDescription;
}

- (DbxAuthErrorType)errorType {
    if (_tag != (DbxAuthResultTag)DbxAuthError) {
        [NSException raise:@"IllegalStateException" format:@"Invalid tag: required (DbxAuthResultTag)DbxAuthError, but was %@.", [self getTagName]];
    }
    return _errorType;
}

- (NSString *)description {
    if (_tag == (DbxAuthResultTag)DbxAuthSuccess) {
        return [NSString stringWithFormat:@"Success:[Token: %@]", _accessToken.accessToken];
    }
    if (_tag == (DbxAuthResultTag)DbxAuthError) {
        return [NSString stringWithFormat:@"Error:[ErrorType: %ld ErrorDescription: %@]", (long)_errorType, _errorDescription];
    }
    if (_tag == (DbxAuthResultTag)DbxAuthCancel) {
        return [NSString stringWithFormat:@"Cancel:[]"];
    }
    
    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

@end
