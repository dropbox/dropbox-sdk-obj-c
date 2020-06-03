///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGSecondaryEmailVerifiedDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `SecondaryEmailVerifiedDetails` struct.
///
/// Verified secondary email.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGSecondaryEmailVerifiedDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Verified secondary email.
@property (nonatomic, readonly, copy) NSString *secondaryEmail;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param secondaryEmail Verified secondary email.
///
/// @return An initialized instance.
///
- (instancetype)initWithSecondaryEmail:(NSString *)secondaryEmail;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `SecondaryEmailVerifiedDetails` struct.
///
@interface DBTEAMLOGSecondaryEmailVerifiedDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGSecondaryEmailVerifiedDetails` instances.
///
/// @param instance An instance of the `DBTEAMLOGSecondaryEmailVerifiedDetails`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGSecondaryEmailVerifiedDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGSecondaryEmailVerifiedDetails *)instance;

///
/// Deserializes `DBTEAMLOGSecondaryEmailVerifiedDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGSecondaryEmailVerifiedDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGSecondaryEmailVerifiedDetails`
/// object.
///
+ (DBTEAMLOGSecondaryEmailVerifiedDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END