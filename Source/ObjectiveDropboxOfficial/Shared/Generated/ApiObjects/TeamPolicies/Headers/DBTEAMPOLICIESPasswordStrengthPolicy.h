///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMPOLICIESPasswordStrengthPolicy;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `PasswordStrengthPolicy` union.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMPOLICIESPasswordStrengthPolicy : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The `DBTEAMPOLICIESPasswordStrengthPolicyTag` enum type represents the
/// possible tag states with which the `DBTEAMPOLICIESPasswordStrengthPolicy`
/// union can exist.
typedef NS_CLOSED_ENUM(NSInteger, DBTEAMPOLICIESPasswordStrengthPolicyTag){
    /// User passwords will adhere to the minimal password strength policy.
    DBTEAMPOLICIESPasswordStrengthPolicyMinimalRequirements,

    /// User passwords will adhere to the moderate password strength policy.
    DBTEAMPOLICIESPasswordStrengthPolicyModeratePassword,

    /// User passwords will adhere to the very strong password strength policy.
    DBTEAMPOLICIESPasswordStrengthPolicyStrongPassword,

    /// (no description).
    DBTEAMPOLICIESPasswordStrengthPolicyOther,

};

/// Represents the union's current tag state.
@property (nonatomic, readonly) DBTEAMPOLICIESPasswordStrengthPolicyTag tag;

#pragma mark - Constructors

///
/// Initializes union class with tag state of "minimal_requirements".
///
/// Description of the "minimal_requirements" tag state: User passwords will
/// adhere to the minimal password strength policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithMinimalRequirements;

///
/// Initializes union class with tag state of "moderate_password".
///
/// Description of the "moderate_password" tag state: User passwords will adhere
/// to the moderate password strength policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithModeratePassword;

///
/// Initializes union class with tag state of "strong_password".
///
/// Description of the "strong_password" tag state: User passwords will adhere
/// to the very strong password strength policy.
///
/// @return An initialized instance.
///
- (instancetype)initWithStrongPassword;

///
/// Initializes union class with tag state of "other".
///
/// @return An initialized instance.
///
- (instancetype)initWithOther;

- (instancetype)init NS_UNAVAILABLE;

#pragma mark - Tag state methods

///
/// Retrieves whether the union's current tag state has value
/// "minimal_requirements".
///
/// @return Whether the union's current tag state has value
/// "minimal_requirements".
///
- (BOOL)isMinimalRequirements;

///
/// Retrieves whether the union's current tag state has value
/// "moderate_password".
///
/// @return Whether the union's current tag state has value "moderate_password".
///
- (BOOL)isModeratePassword;

///
/// Retrieves whether the union's current tag state has value "strong_password".
///
/// @return Whether the union's current tag state has value "strong_password".
///
- (BOOL)isStrongPassword;

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
/// The serialization class for the `DBTEAMPOLICIESPasswordStrengthPolicy`
/// union.
///
@interface DBTEAMPOLICIESPasswordStrengthPolicySerializer : NSObject

///
/// Serializes `DBTEAMPOLICIESPasswordStrengthPolicy` instances.
///
/// @param instance An instance of the `DBTEAMPOLICIESPasswordStrengthPolicy`
/// API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMPOLICIESPasswordStrengthPolicy` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMPOLICIESPasswordStrengthPolicy *)instance;

///
/// Deserializes `DBTEAMPOLICIESPasswordStrengthPolicy` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMPOLICIESPasswordStrengthPolicy` API object.
///
/// @return An instantiation of the `DBTEAMPOLICIESPasswordStrengthPolicy`
/// object.
///
+ (DBTEAMPOLICIESPasswordStrengthPolicy *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END