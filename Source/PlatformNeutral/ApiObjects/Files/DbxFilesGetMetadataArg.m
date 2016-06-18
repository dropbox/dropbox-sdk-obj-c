///
/// Auto-generated by Stone, do not modify.
///

#import "DbxFilesGetMetadataArg.h"
#import "DbxStoneSerializers.h"
#import "DbxStoneValidators.h"

@implementation DbxFilesGetMetadataArg 

- (instancetype)initWithPath:(NSString *)path includeMediaInfo:(NSNumber *)includeMediaInfo includeDeleted:(NSNumber *)includeDeleted includeHasExplicitSharedMembers:(NSNumber *)includeHasExplicitSharedMembers {
    [DbxStoneValidators stringValidator:nil maxLength:nil pattern:@"(/(.|[\\r\\n])*|id:.*)|(rev:[0-9a-f]{9,})|(ns:[0-9]+(/.*)?)"](path);

    self = [super init];
    if (self != nil) {
        _path = path;
        _includeMediaInfo = includeMediaInfo ?: @NO;
        _includeDeleted = includeDeleted ?: @NO;
        _includeHasExplicitSharedMembers = includeHasExplicitSharedMembers ?: @NO;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path {
    return [self initWithPath:path includeMediaInfo:nil includeDeleted:nil includeHasExplicitSharedMembers:nil];
}

+ (NSDictionary *)serialize:(id)obj {
    return [DbxFilesGetMetadataArgSerializer serialize:obj];
}

+ (id)deserialize:(NSDictionary *)dict {
    return [DbxFilesGetMetadataArgSerializer deserialize:dict];
}

- (NSString *)description {
    return [[DbxFilesGetMetadataArgSerializer serialize:self] description];
}

@end


@implementation DbxFilesGetMetadataArgSerializer 

+ (NSDictionary *)serialize:(DbxFilesGetMetadataArg *)valueObj {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];

    jsonDict[@"path"] = [DbxStringSerializer serialize:valueObj.path];
    jsonDict[@"include_media_info"] = [DbxBoolSerializer serialize:valueObj.includeMediaInfo];
    jsonDict[@"include_deleted"] = [DbxBoolSerializer serialize:valueObj.includeDeleted];
    jsonDict[@"include_has_explicit_shared_members"] = [DbxBoolSerializer serialize:valueObj.includeHasExplicitSharedMembers];

    return jsonDict;
}

+ (DbxFilesGetMetadataArg *)deserialize:(NSDictionary *)valueDict {
    NSString *path = [DbxStringSerializer deserialize:valueDict[@"path"]];
    NSNumber *includeMediaInfo = [DbxBoolSerializer deserialize:valueDict[@"include_media_info"]];
    NSNumber *includeDeleted = [DbxBoolSerializer deserialize:valueDict[@"include_deleted"]];
    NSNumber *includeHasExplicitSharedMembers = [DbxBoolSerializer deserialize:valueDict[@"include_has_explicit_shared_members"]];

    return [[DbxFilesGetMetadataArg alloc] initWithPath:path includeMediaInfo:includeMediaInfo includeDeleted:includeDeleted includeHasExplicitSharedMembers:includeHasExplicitSharedMembers];
}

@end