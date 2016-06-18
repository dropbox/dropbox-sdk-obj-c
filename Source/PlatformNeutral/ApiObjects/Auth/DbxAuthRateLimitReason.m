///
/// Auto-generated by Stone, do not modify.
///

#import "DbxAuthRateLimitReason.h"
#import "DbxStoneSerializers.h"
#import "DbxStoneValidators.h"

@implementation DbxAuthRateLimitReason 

- (instancetype)initWithTooManyRequests {
    self = [super init];
    if (self != nil) {
        _tag = (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyRequests;
    }
    return self;
}

- (instancetype)initWithTooManyWriteOperations {
    self = [super init];
    if (self != nil) {
        _tag = (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyWriteOperations;
    }
    return self;
}

- (instancetype)initWithOther {
    self = [super init];
    if (self != nil) {
        _tag = (AuthRateLimitReasonTag)AuthRateLimitReasonOther;
    }
    return self;
}

- (BOOL)isTooManyRequests {
    return _tag == (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyRequests;
}

- (BOOL)isTooManyWriteOperations {
    return _tag == (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyWriteOperations;
}

- (BOOL)isOther {
    return _tag == (AuthRateLimitReasonTag)AuthRateLimitReasonOther;
}

- (NSString *)getTagName {
    if (_tag == (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyRequests) {
        return @"(AuthRateLimitReasonTag)AuthRateLimitReasonTooManyRequests";
    }
    if (_tag == (AuthRateLimitReasonTag)AuthRateLimitReasonTooManyWriteOperations) {
        return @"(AuthRateLimitReasonTag)AuthRateLimitReasonTooManyWriteOperations";
    }
    if (_tag == (AuthRateLimitReasonTag)AuthRateLimitReasonOther) {
        return @"(AuthRateLimitReasonTag)AuthRateLimitReasonOther";
    }

    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

+ (NSDictionary *)serialize:(id)obj {
    return [DbxAuthRateLimitReasonSerializer serialize:obj];
}

+ (id)deserialize:(NSDictionary *)dict {
    return [DbxAuthRateLimitReasonSerializer deserialize:dict];
}

- (NSString *)description {
    return [[DbxAuthRateLimitReasonSerializer serialize:self] description];
}

@end


@implementation DbxAuthRateLimitReasonSerializer 

+ (NSDictionary *)serialize:(DbxAuthRateLimitReason *)valueObj {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    if ([valueObj isTooManyRequests]) {
        jsonDict[@".tag"] = @"too_many_requests";
    }
    else if ([valueObj isTooManyWriteOperations]) {
        jsonDict[@".tag"] = @"too_many_write_operations";
    }
    else if ([valueObj isOther]) {
        jsonDict[@".tag"] = @"other";
    }
    else {
        @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
    }

    return jsonDict;
}

+ (DbxAuthRateLimitReason *)deserialize:(NSDictionary *)valueDict {
    NSString *tag = valueDict[@".tag"];

    if ([tag isEqualToString:@"too_many_requests"]) {
        return [[DbxAuthRateLimitReason alloc] initWithTooManyRequests];
    }
    if ([tag isEqualToString:@"too_many_write_operations"]) {
        return [[DbxAuthRateLimitReason alloc] initWithTooManyWriteOperations];
    }
    if ([tag isEqualToString:@"other"]) {
        return [[DbxAuthRateLimitReason alloc] initWithOther];
    }

    @throw([NSException exceptionWithName:@"InvalidTagEnum" reason:@"Supplied tag enum has an invalid value." userInfo:nil]);
}

@end