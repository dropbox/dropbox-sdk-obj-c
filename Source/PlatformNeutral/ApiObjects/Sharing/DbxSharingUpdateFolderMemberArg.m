///
/// Auto-generated by Stone, do not modify.
///

#import "DbxSharingAccessLevel.h"
#import "DbxSharingMemberSelector.h"
#import "DbxSharingUpdateFolderMemberArg.h"
#import "DbxStoneSerializers.h"
#import "DbxStoneValidators.h"

@implementation DbxSharingUpdateFolderMemberArg 

- (instancetype)initWithSharedFolderId:(NSString *)sharedFolderId member:(DbxSharingMemberSelector *)member accessLevel:(DbxSharingAccessLevel *)accessLevel {
    [DbxStoneValidators stringValidator:nil maxLength:nil pattern:@"[-_0-9a-zA-Z:]+"](sharedFolderId);

    self = [super init];
    if (self != nil) {
        _sharedFolderId = sharedFolderId;
        _member = member;
        _accessLevel = accessLevel;
    }
    return self;
}

+ (NSDictionary *)serialize:(id)obj {
    return [DbxSharingUpdateFolderMemberArgSerializer serialize:obj];
}

+ (id)deserialize:(NSDictionary *)dict {
    return [DbxSharingUpdateFolderMemberArgSerializer deserialize:dict];
}

- (NSString *)description {
    return [[DbxSharingUpdateFolderMemberArgSerializer serialize:self] description];
}

@end


@implementation DbxSharingUpdateFolderMemberArgSerializer 

+ (NSDictionary *)serialize:(DbxSharingUpdateFolderMemberArg *)valueObj {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    jsonDict[@"shared_folder_id"] = [DbxStringSerializer serialize:valueObj.sharedFolderId];
    jsonDict[@"member"] = [DbxSharingMemberSelectorSerializer serialize:valueObj.member];
    jsonDict[@"access_level"] = [DbxSharingAccessLevelSerializer serialize:valueObj.accessLevel];

    return jsonDict;
}

+ (DbxSharingUpdateFolderMemberArg *)deserialize:(NSDictionary *)valueDict {
    NSString *sharedFolderId = [DbxStringSerializer deserialize:valueDict[@"shared_folder_id"]];
    DbxSharingMemberSelector *member = [DbxSharingMemberSelectorSerializer deserialize:valueDict[@"member"]];
    DbxSharingAccessLevel *accessLevel = [DbxSharingAccessLevelSerializer deserialize:valueDict[@"access_level"]];

    return [[DbxSharingUpdateFolderMemberArg alloc] initWithSharedFolderId:sharedFolderId member:member accessLevel:accessLevel];
}

@end