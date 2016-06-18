///
/// Auto-generated by Stone, do not modify.
///

#import "DbxFilesSearchMatch.h"
#import "DbxFilesSearchResult.h"
#import "DbxStoneSerializers.h"
#import "DbxStoneValidators.h"

@implementation DbxFilesSearchResult 

- (instancetype)initWithMatches:(NSArray<DbxFilesSearchMatch *> *)matches more:(NSNumber *)more start:(NSNumber *)start {
    [DbxStoneValidators arrayValidator:nil maxItems:nil itemValidator:nil](matches);

    self = [super init];
    if (self != nil) {
        _matches = matches;
        _more = more;
        _start = start;
    }
    return self;
}

+ (NSDictionary *)serialize:(id)obj {
    return [DbxFilesSearchResultSerializer serialize:obj];
}

+ (id)deserialize:(NSDictionary *)dict {
    return [DbxFilesSearchResultSerializer deserialize:dict];
}

- (NSString *)description {
    return [[DbxFilesSearchResultSerializer serialize:self] description];
}

@end


@implementation DbxFilesSearchResultSerializer 

+ (NSDictionary *)serialize:(DbxFilesSearchResult *)valueObj {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    jsonDict[@"matches"] = [DbxArraySerializer serialize:valueObj.matches withBlock:^id(id obj) { return [DbxFilesSearchMatchSerializer serialize:obj]; }];
    jsonDict[@"more"] = [DbxBoolSerializer serialize:valueObj.more];
    jsonDict[@"start"] = [DbxNSNumberSerializer serialize:valueObj.start];

    return jsonDict;
}

+ (DbxFilesSearchResult *)deserialize:(NSDictionary *)valueDict {
    NSArray<DbxFilesSearchMatch *> *matches = [DbxArraySerializer deserialize:valueDict[@"matches"] withBlock:^id(id obj) { return [DbxFilesSearchMatchSerializer deserialize:obj]; }];
    NSNumber *more = [DbxBoolSerializer deserialize:valueDict[@"more"]];
    NSNumber *start = [DbxNSNumberSerializer deserialize:valueDict[@"start"]];

    return [[DbxFilesSearchResult alloc] initWithMatches:matches more:more start:start];
}

@end