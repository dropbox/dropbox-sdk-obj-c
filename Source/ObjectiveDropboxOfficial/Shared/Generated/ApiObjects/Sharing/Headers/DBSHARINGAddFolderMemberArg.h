///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBSHARINGAddFolderMemberArg;
@class DBSHARINGAddMember;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `AddFolderMemberArg` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBSHARINGAddFolderMemberArg : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The ID for the shared folder.
@property (nonatomic, readonly, copy) NSString *sharedFolderId;

/// The intended list of members to add.  Added members will receive invites to
/// join the shared folder.
@property (nonatomic, readonly) NSArray<DBSHARINGAddMember *> *members;

/// Whether added members should be notified via email and device notifications
/// of their invite.
@property (nonatomic, readonly) NSNumber *quiet;

/// Optional message to display to added members in their invitation.
@property (nonatomic, readonly, copy, nullable) NSString *customMessage;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param sharedFolderId The ID for the shared folder.
/// @param members The intended list of members to add.  Added members will
/// receive invites to join the shared folder.
/// @param quiet Whether added members should be notified via email and device
/// notifications of their invite.
/// @param customMessage Optional message to display to added members in their
/// invitation.
///
/// @return An initialized instance.
///
- (instancetype)initWithSharedFolderId:(NSString *)sharedFolderId
                               members:(NSArray<DBSHARINGAddMember *> *)members
                                 quiet:(nullable NSNumber *)quiet
                         customMessage:(nullable NSString *)customMessage;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param sharedFolderId The ID for the shared folder.
/// @param members The intended list of members to add.  Added members will
/// receive invites to join the shared folder.
///
/// @return An initialized instance.
///
- (instancetype)initWithSharedFolderId:(NSString *)sharedFolderId members:(NSArray<DBSHARINGAddMember *> *)members;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `AddFolderMemberArg` struct.
///
@interface DBSHARINGAddFolderMemberArgSerializer : NSObject

///
/// Serializes `DBSHARINGAddFolderMemberArg` instances.
///
/// @param instance An instance of the `DBSHARINGAddFolderMemberArg` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBSHARINGAddFolderMemberArg` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBSHARINGAddFolderMemberArg *)instance;

///
/// Deserializes `DBSHARINGAddFolderMemberArg` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBSHARINGAddFolderMemberArg` API object.
///
/// @return An instantiation of the `DBSHARINGAddFolderMemberArg` object.
///
+ (DBSHARINGAddFolderMemberArg *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
