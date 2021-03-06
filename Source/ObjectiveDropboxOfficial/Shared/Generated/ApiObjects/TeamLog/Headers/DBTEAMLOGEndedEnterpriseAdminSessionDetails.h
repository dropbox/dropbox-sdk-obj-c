///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGEndedEnterpriseAdminSessionDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `EndedEnterpriseAdminSessionDetails` struct.
///
/// Ended enterprise admin session.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGEndedEnterpriseAdminSessionDetails : NSObject <DBSerializable, NSCopying>

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
/// The serialization class for the `EndedEnterpriseAdminSessionDetails` struct.
///
@interface DBTEAMLOGEndedEnterpriseAdminSessionDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGEndedEnterpriseAdminSessionDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGEndedEnterpriseAdminSessionDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGEndedEnterpriseAdminSessionDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGEndedEnterpriseAdminSessionDetails *)instance;

///
/// Deserializes `DBTEAMLOGEndedEnterpriseAdminSessionDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGEndedEnterpriseAdminSessionDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGEndedEnterpriseAdminSessionDetails` object.
///
+ (DBTEAMLOGEndedEnterpriseAdminSessionDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
