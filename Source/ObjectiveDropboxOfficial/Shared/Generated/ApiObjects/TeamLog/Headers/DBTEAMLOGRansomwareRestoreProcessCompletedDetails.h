///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBTEAMLOGRansomwareRestoreProcessCompletedDetails;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `RansomwareRestoreProcessCompletedDetails` struct.
///
/// Completed ransomware restore process.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBTEAMLOGRansomwareRestoreProcessCompletedDetails : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// The status of the restore process.
@property (nonatomic, readonly, copy) NSString *status;

/// Restored files count.
@property (nonatomic, readonly) NSNumber *restoredFilesCount;

/// Restored files failed count.
@property (nonatomic, readonly) NSNumber *restoredFilesFailedCount;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param status The status of the restore process.
/// @param restoredFilesCount Restored files count.
/// @param restoredFilesFailedCount Restored files failed count.
///
/// @return An initialized instance.
///
- (instancetype)initWithStatus:(NSString *)status
            restoredFilesCount:(NSNumber *)restoredFilesCount
      restoredFilesFailedCount:(NSNumber *)restoredFilesFailedCount;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `RansomwareRestoreProcessCompletedDetails`
/// struct.
///
@interface DBTEAMLOGRansomwareRestoreProcessCompletedDetailsSerializer : NSObject

///
/// Serializes `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` instances.
///
/// @param instance An instance of the
/// `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBTEAMLOGRansomwareRestoreProcessCompletedDetails *)instance;

///
/// Deserializes `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` API object.
///
/// @return An instantiation of the
/// `DBTEAMLOGRansomwareRestoreProcessCompletedDetails` object.
///
+ (DBTEAMLOGRansomwareRestoreProcessCompletedDetails *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
