///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGAccessLevel;
@class DBSHARINGSharedFolderMetadataBase;
@class DBUSERSTeam;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SharedFolderMetadataBase` struct.
///
/// Properties of the shared folder.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGSharedFolderMetadataBase : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The current user's access level for this shared folder.
@property (nonatomic, readonly) DBSHARINGAccessLevel *accessType;

/// Whether this folder is inside of a team folder.
@property (nonatomic, readonly) NSNumber *isInsideTeamFolder;

/// Whether this folder is a team folder https://www.dropbox.com/en/help/986.
@property (nonatomic, readonly) NSNumber *isTeamFolder;

/// The display names of the users that own the folder. If the folder is part of
/// a team folder, the display names of the team admins are also included.
/// Absent if the owner display names cannot be fetched.
@property (nonatomic, readonly, nullable) NSArray<NSString *> *ownerDisplayNames;

/// The team that owns the folder. This field is not present if the folder is
/// not owned by a team.
@property (nonatomic, readonly, nullable) DBUSERSTeam *ownerTeam;

/// The ID of the parent shared folder. This field is present only if the folder
/// is contained within another shared folder.
@property (nonatomic, readonly, copy, nullable) NSString *parentSharedFolderId;

/// The full path of this shared folder. Absent for unmounted folders.
@property (nonatomic, readonly, copy, nullable) NSString *pathDisplay;

/// The lower-cased full path of this shared folder. Absent for unmounted
/// folders.
@property (nonatomic, readonly, copy, nullable) NSString *pathLower;

/// Display name for the parent folder.
@property (nonatomic, readonly, copy, nullable) NSString *parentFolderName;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param accessType The current user's access level for this shared folder.
/// @param isInsideTeamFolder Whether this folder is inside of a team folder.
/// @param isTeamFolder Whether this folder is a team folder
/// https://www.dropbox.com/en/help/986.
/// @param ownerDisplayNames The display names of the users that own the folder.
/// If the folder is part of a team folder, the display names of the team admins
/// are also included. Absent if the owner display names cannot be fetched.
/// @param ownerTeam The team that owns the folder. This field is not present if
/// the folder is not owned by a team.
/// @param parentSharedFolderId The ID of the parent shared folder. This field
/// is present only if the folder is contained within another shared folder.
/// @param pathDisplay The full path of this shared folder. Absent for unmounted
/// folders.
/// @param pathLower The lower-cased full path of this shared folder. Absent for
/// unmounted folders.
/// @param parentFolderName Display name for the parent folder.
///
/// @return An initialized instance.
///
- (instancetype)initWithAccessType:(DBSHARINGAccessLevel *)accessType
                isInsideTeamFolder:(NSNumber *)isInsideTeamFolder
                      isTeamFolder:(NSNumber *)isTeamFolder
                 ownerDisplayNames:(nullable NSArray<NSString *> *)ownerDisplayNames
                         ownerTeam:(nullable DBUSERSTeam *)ownerTeam
              parentSharedFolderId:(nullable NSString *)parentSharedFolderId
                       pathDisplay:(nullable NSString *)pathDisplay
                         pathLower:(nullable NSString *)pathLower
                  parentFolderName:(nullable NSString *)parentFolderName;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param accessType The current user's access level for this shared folder.
/// @param isInsideTeamFolder Whether this folder is inside of a team folder.
/// @param isTeamFolder Whether this folder is a team folder
/// https://www.dropbox.com/en/help/986.
///
/// @return An initialized instance.
///
- (instancetype)initWithAccessType:(DBSHARINGAccessLevel *)accessType
                isInsideTeamFolder:(NSNumber *)isInsideTeamFolder
                      isTeamFolder:(NSNumber *)isTeamFolder;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SharedFolderMetadataBase` struct.
///
@interface DBSHARINGSharedFolderMetadataBaseSerializer : NSObject

///
/// Serializes `DBSHARINGSharedFolderMetadataBase` instances.
///
/// @param instance An instance of the `DBSHARINGSharedFolderMetadataBase` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGSharedFolderMetadataBase` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBSHARINGSharedFolderMetadataBase *)instance;

///
/// Deserializes `DBSHARINGSharedFolderMetadataBase` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGSharedFolderMetadataBase` API object.
///
/// @return An instantiation of the `DBSHARINGSharedFolderMetadataBase` object.
///
+ (DBSHARINGSharedFolderMetadataBase *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
