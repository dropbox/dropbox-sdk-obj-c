///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Auto-generated by Stone, do not modify.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBFILESPaperCreateResult;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - API Object

///
/// The `PaperCreateResult` struct.
///
/// This class implements the `DBSerializable` protocol (serialize and
/// deserialize instance methods), which is required for all Obj-C SDK API route
/// objects.
///
@interface DBFILESPaperCreateResult : NSObject <DBSerializable, NSCopying>

#pragma mark - Instance fields

/// URL to open the Paper Doc.
@property (nonatomic, readonly, copy) NSString *url;

/// The fully qualified path the Paper Doc was actually created at.
@property (nonatomic, readonly, copy) NSString *resultPath;

/// The id to use in Dropbox APIs when referencing the Paper Doc.
@property (nonatomic, readonly, copy) NSString *fileId;

/// The current doc revision.
@property (nonatomic, readonly) NSNumber *paperRevision;

#pragma mark - Constructors

///
/// Full constructor for the struct (exposes all instance variables).
///
/// @param url URL to open the Paper Doc.
/// @param resultPath The fully qualified path the Paper Doc was actually
/// created at.
/// @param fileId The id to use in Dropbox APIs when referencing the Paper Doc.
/// @param paperRevision The current doc revision.
///
/// @return An initialized instance.
///
- (instancetype)initWithUrl:(NSString *)url
                 resultPath:(NSString *)resultPath
                     fileId:(NSString *)fileId
              paperRevision:(NSNumber *)paperRevision;

- (instancetype)init NS_UNAVAILABLE;

@end

#pragma mark - Serializer Object

///
/// The serialization class for the `PaperCreateResult` struct.
///
@interface DBFILESPaperCreateResultSerializer : NSObject

///
/// Serializes `DBFILESPaperCreateResult` instances.
///
/// @param instance An instance of the `DBFILESPaperCreateResult` API object.
///
/// @return A json-compatible dictionary representation of the
/// `DBFILESPaperCreateResult` API object.
///
+ (nullable NSDictionary<NSString *, id> *)serialize:(DBFILESPaperCreateResult *)instance;

///
/// Deserializes `DBFILESPaperCreateResult` instances.
///
/// @param dict A json-compatible dictionary representation of the
/// `DBFILESPaperCreateResult` API object.
///
/// @return An instantiation of the `DBFILESPaperCreateResult` object.
///
+ (DBFILESPaperCreateResult *)deserialize:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
