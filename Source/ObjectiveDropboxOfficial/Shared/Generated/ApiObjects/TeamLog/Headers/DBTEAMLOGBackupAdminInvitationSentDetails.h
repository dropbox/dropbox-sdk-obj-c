///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGBackupAdminInvitationSentDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `BackupAdminInvitationSentDetails` struct.
///
/// Invited members to activate Backup.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGBackupAdminInvitationSentDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `BackupAdminInvitationSentDetails` struct.
///
@interface DBTEAMLOGBackupAdminInvitationSentDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGBackupAdminInvitationSentDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGBackupAdminInvitationSentDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGBackupAdminInvitationSentDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGBackupAdminInvitationSentDetails *)instance;

///
/// Deserializes `DBTEAMLOGBackupAdminInvitationSentDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGBackupAdminInvitationSentDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGBackupAdminInvitationSentDetails`
/// object.
///
+ (DBTEAMLOGBackupAdminInvitationSentDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END