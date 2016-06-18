///
/// Auto-generated by Stone, do not modify.
///

#import "DbxStoneSerializers.h"
#import "DbxStoneValidators.h"
#import "DbxTeamMemberAddArg.h"
#import "DbxTeamMembersAddArg.h"

@implementation DbxTeamMembersAddArg 

- (instancetype)initWithDNewMembers:(NSArray<DbxTeamMemberAddArg *> *)dNewMembers forceAsync:(NSNumber *)forceAsync {
    [DbxStoneValidators arrayValidator:nil maxItems:nil itemValidator:nil](dNewMembers);

    self = [super init];
    if (self != nil) {
        _dNewMembers = dNewMembers;
        _forceAsync = forceAsync ?: @NO;
    }
    return self;
}

- (instancetype)initWithDNewMembers:(NSArray<DbxTeamMemberAddArg *> *)dNewMembers {
    return [self initWithDNewMembers:dNewMembers forceAsync:nil];
}

+ (NSDictionary *)serialize:(id)obj {
    return [DbxTeamMembersAddArgSerializer serialize:obj];
}

+ (id)deserialize:(NSDictionary *)dict {
    return [DbxTeamMembersAddArgSerializer deserialize:dict];
}

- (NSString *)description {
    return [[DbxTeamMembersAddArgSerializer serialize:self] description];
}

@end


@implementation DbxTeamMembersAddArgSerializer 

+ (NSDictionary *)serialize:(DbxTeamMembersAddArg *)valueObj {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    jsonDict[@"new_members"] = [DbxArraySerializer serialize:valueObj.dNewMembers withBlock:^id(id obj) { return [DbxTeamMemberAddArgSerializer serialize:obj]; }];
    jsonDict[@"force_async"] = [DbxBoolSerializer serialize:valueObj.forceAsync];

    return jsonDict;
}

+ (DbxTeamMembersAddArg *)deserialize:(NSDictionary *)valueDict {
    NSArray<DbxTeamMemberAddArg *> *dNewMembers = [DbxArraySerializer deserialize:valueDict[@"new_members"] withBlock:^id(id obj) { return [DbxTeamMemberAddArgSerializer deserialize:obj]; }];
    NSNumber *forceAsync = [DbxBoolSerializer deserialize:valueDict[@"force_async"]];

    return [[DbxTeamMembersAddArg alloc] initWithDNewMembers:dNewMembers forceAsync:forceAsync];
}

@end