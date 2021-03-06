///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGGovernancePolicyReportCreatedDetails;
@class DBTEAMLOGPolicyType;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `GovernancePolicyReportCreatedDetails` struct.
///
/// Created a summary report for a policy.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGGovernancePolicyReportCreatedDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Policy ID.
@property (nonatomic, readonly, copy) NSString *governancePolicyId;

/// Policy name.
@property (nonatomic, readonly, copy) NSString *name;

/// Policy type.
@property (nonatomic, readonly, nullable) DBTEAMLOGPolicyType *policyType;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param governancePolicyId Policy ID.
/// @param name Policy name.
/// @param policyType Policy type.
///
/// @return An initialized instance.
///
- (instancetype)initWithGovernancePolicyId:(NSString *)governancePolicyId
                                      name:(NSString *)name
                                policyType:(nullable DBTEAMLOGPolicyType *)policyType;

///
/// Convenience constructor (exposes only non-nullable instance variables with
/// no default value).
///
/// @param governancePolicyId Policy ID.
/// @param name Policy name.
///
/// @return An initialized instance.
///
- (instancetype)initWithGovernancePolicyId:(NSString *)governancePolicyId name:(NSString *)name;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `GovernancePolicyReportCreatedDetails`
/// struct.
///
@interface DBTEAMLOGGovernancePolicyReportCreatedDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGGovernancePolicyReportCreatedDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGGovernancePolicyReportCreatedDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGGovernancePolicyReportCreatedDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGGovernancePolicyReportCreatedDetails *)instance;

///
/// Deserializes `DBTEAMLOGGovernancePolicyReportCreatedDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGGovernancePolicyReportCreatedDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGGovernancePolicyReportCreatedDetails` object.
///
+ (DBTEAMLOGGovernancePolicyReportCreatedDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
