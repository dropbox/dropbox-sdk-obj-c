///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"
#import "DBTEAMLOGUserLogInfo.h"

@class DBTEAMLOGTeamLogInfo;
@class DBTEAMLOGTeamMemberLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamMemberLogInfo` struct.
///
/// Team member's logged information.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGTeamMemberLogInfo : DBTEAMLOGUserLogInfo <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Team member ID.
@property (nonatomic, readonly, copy, nullable) NSString *teamMemberId;

/// Team member external ID.
@property (nonatomic, readonly, copy, nullable) NSString *memberExternalId;

/// Details about this user&#x2019s team for enterprise event.
@property (nonatomic, readonly, nullable) DBTEAMLOGTeamLogInfo *team;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param accountId User unique ID.
/// @param displayName User display name.
/// @param email User email address.
/// @param teamMemberId Team member ID.
/// @param memberExternalId Team member external ID.
/// @param team Details about this user&#x2019s team for enterprise event.
///
/// @return An initialized instance.
///
- (instancetype)initWithAccountId:(nullable NSString *)accountId
                      displayName:(nullable NSString *)displayName
                            email:(nullable NSString *)email
                     teamMemberId:(nullable NSString *)teamMemberId
                 memberExternalId:(nullable NSString *)memberExternalId
                             team:(nullable DBTEAMLOGTeamLogInfo *)team;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamMemberLogInfo` struct.
///
@interface DBTEAMLOGTeamMemberLogInfoSerializer : NSObject

///
/// Serializes `DBTEAMLOGTeamMemberLogInfo` instances.
///
/// @param instance An instance of the `DBTEAMLOGTeamMemberLogInfo` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamMemberLogInfo` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGTeamMemberLogInfo *)instance;

///
/// Deserializes `DBTEAMLOGTeamMemberLogInfo` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGTeamMemberLogInfo` API object.
///
/// @return An instantiation of the `DBTEAMLOGTeamMemberLogInfo` object.
///
+ (DBTEAMLOGTeamMemberLogInfo *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
