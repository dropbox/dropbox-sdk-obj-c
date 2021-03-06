///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMTeamMemberInfoV2;
@class DBTEAMTeamMemberProfile;
@class DBTEAMTeamMemberRole;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `TeamMemberInfoV2` struct.
///
/// Information about a team member.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMTeamMemberInfoV2 : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Profile of a user as a member of a team.
@property (nonatomic, readonly) DBTEAMTeamMemberProfile *profile;

/// The user's roles in the team.
@property (nonatomic, readonly, nullable) NSArray<DBTEAMTeamMemberRole *> *roles;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param profile Profile of a user as a member of a team.
/// @param roles The user's roles in the team.
///
/// @return An initialized instance.
///
- (instancetype)initWithProfile:(DBTEAMTeamMemberProfile *)profile
                          roles:(nullable NSArray<DBTEAMTeamMemberRole *> *)roles;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param profile Profile of a user as a member of a team.
///
/// @return An initialized instance.
///
- (instancetype)initWithProfile:(DBTEAMTeamMemberProfile *)profile;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `TeamMemberInfoV2` struct.
///
@interface DBTEAMTeamMemberInfoV2Serializer : NSObject

///
/// Serializes `DBTEAMTeamMemberInfoV2` instances.
///
/// @param instance An instance of the `DBTEAMTeamMemberInfoV2` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMTeamMemberInfoV2` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMTeamMemberInfoV2 *)instance;

///
/// Deserializes `DBTEAMTeamMemberInfoV2` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMTeamMemberInfoV2` API object.
///
/// @return An instantiation of the `DBTEAMTeamMemberInfoV2` object.
///
+ (DBTEAMTeamMemberInfoV2 *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
