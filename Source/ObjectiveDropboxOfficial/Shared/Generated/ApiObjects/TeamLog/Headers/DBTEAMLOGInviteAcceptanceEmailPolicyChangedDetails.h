///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGInviteAcceptanceEmailPolicy;
@class DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `InviteAcceptanceEmailPolicyChangedDetails` struct.
///
/// Changed invite accept email policy for team.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// To.
@property (nonatomic, readonly) DBTEAMLOGInviteAcceptanceEmailPolicy *dNewValue;

/// From.
@property (nonatomic, readonly) DBTEAMLOGInviteAcceptanceEmailPolicy *previousValue;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param dNewValue To.
/// @param previousValue From.
///
/// @return An initialized instance.
///
- (instancetype)initWithDNewValue:(DBTEAMLOGInviteAcceptanceEmailPolicy *)dNewValue
                    previousValue:(DBTEAMLOGInviteAcceptanceEmailPolicy *)previousValue;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `InviteAcceptanceEmailPolicyChangedDetails`
/// struct.
///
@interface DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails *)instance;

///
/// Deserializes `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails` object.
///
+ (DBTEAMLOGInviteAcceptanceEmailPolicyChangedDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
