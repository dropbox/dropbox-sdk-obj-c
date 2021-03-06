///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGAdminConsoleAppPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `AdminConsoleAppPolicy` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGAdminConsoleAppPolicy : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMLOGAdminConsoleAppPolicyTag` enum type represents the possible
/// tag states with which the `DBTEAMLOGAdminConsoleAppPolicy` union can exist.
typedef NS_CLOSED_ENUM(NSInteger, DBTEAMLOGAdminConsoleAppPolicyTag){
    /// (no description).
    DBTEAMLOGAdminConsoleAppPolicyAllow,

    /// (no description).
    DBTEAMLOGAdminConsoleAppPolicyBlock,

    /// (no description).
    DBTEAMLOGAdminConsoleAppPolicyDefault_,

    /// (no description).
    DBTEAMLOGAdminConsoleAppPolicyOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMLOGAdminConsoleAppPolicyTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "allow".
///
/// @return An initialized instance.
///
- (instancetype)initWithAllow;

///
/// Initializes union class with tag state of "block".
///
/// @return An initialized instance.
///
- (instancetype)initWithBlock;

///
/// Initializes union class with tag state of "default".
///
/// @return An initialized instance.
///
- (instancetype)initWithDefault_;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value "allow".
///
/// @return Whether the union's current tag state has value "allow".
///
- (BOOL)isAllow;

///
/// Retrieves whether the union's current tag state has value "block".
///
/// @return Whether the union's current tag state has value "block".
///
- (BOOL)isBlock;

///
/// Retrieves whether the union's current tag state has value "default".
///
/// @return Whether the union's current tag state has value "default".
///
- (BOOL)isDefault_;

///
/// Retrieves whether the union's current tag state has value "other".
///
/// @return Whether the union's current tag state has value "other".
///
- (BOOL)isOther;

///
/// Retrieves string value of union's current tag state.
///
/// @return A human-readable string representing the union's current tag state.
///
- (NSString *)tagName;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DBTEAMLOGAdminConsoleAppPolicy` union.
///
@interface DBTEAMLOGAdminConsoleAppPolicySerializer : NSObject

///
/// Serializes `DBTEAMLOGAdminConsoleAppPolicy` instances.
///
/// @param instance An instance of the `DBTEAMLOGAdminConsoleAppPolicy` API
/// object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGAdminConsoleAppPolicy` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGAdminConsoleAppPolicy *)instance;

///
/// Deserializes `DBTEAMLOGAdminConsoleAppPolicy` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGAdminConsoleAppPolicy` API object.
///
/// @return An instantiation of the `DBTEAMLOGAdminConsoleAppPolicy` object.
///
+ (DBTEAMLOGAdminConsoleAppPolicy *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
