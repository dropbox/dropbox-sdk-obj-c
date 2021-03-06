///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMMembersAddArgBase;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `MembersAddArgBase` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMMembersAddArgBase : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Whether to force the add to happen asynchronously.
@property (nonatomic, readonly) NSNumber *forceAsync;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param forceAsync Whether to force the add to happen asynchronously.
///
/// @return An initialized instance.
///
- (instancetype)initWithForceAsync:(nullable NSNumber *)forceAsync;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
///
/// @return An initialized instance.
///
- (instancetype)initDefault;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `MembersAddArgBase` struct.
///
@interface DBTEAMMembersAddArgBaseSerializer : NSObject

///
/// Serializes `DBTEAMMembersAddArgBase` instances.
///
/// @param instance An instance of the `DBTEAMMembersAddArgBase` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMMembersAddArgBase` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMMembersAddArgBase *)instance;

///
/// Deserializes `DBTEAMMembersAddArgBase` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMMembersAddArgBase` API object.
///
/// @return An instantiation of the `DBTEAMMembersAddArgBase` object.
///
+ (DBTEAMMembersAddArgBase *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
