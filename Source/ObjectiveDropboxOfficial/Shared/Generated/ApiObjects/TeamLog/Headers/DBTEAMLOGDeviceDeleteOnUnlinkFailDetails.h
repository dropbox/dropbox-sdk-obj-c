///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGDeviceDeleteOnUnlinkFailDetails;
@class DBTEAMLOGDeviceLogInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `DeviceDeleteOnUnlinkFailDetails` struct.
///
/// Failed to delete all files from an unlinked device.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGDeviceDeleteOnUnlinkFailDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// Device information.
@property (nonatomic, readonly) DBTEAMLOGDeviceLogInfo *deviceInfo;

/// The number of times that remote file deletion failed.
@property (nonatomic, readonly) NSNumber *numFailures;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param deviceInfo Device information.
/// @param numFailures The number of times that remote file deletion failed.
///
/// @return An initialized instance.
///
- (instancetype)initWithDeviceInfo:(DBTEAMLOGDeviceLogInfo *)deviceInfo numFailures:(NSNumber *)numFailures;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `DeviceDeleteOnUnlinkFailDetails` struct.
///
@interface DBTEAMLOGDeviceDeleteOnUnlinkFailDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails` API object.
///
+ (NSDictionary *)serialize:(DBTEAMLOGDeviceDeleteOnUnlinkFailDetails *)instance;

///
/// Deserializes `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails` API object.
///
/// @return An instantiation of the `DBTEAMLOGDeviceDeleteOnUnlinkFailDetails`
/// object.
///
+ (DBTEAMLOGDeviceDeleteOnUnlinkFailDetails *)deserialize:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END