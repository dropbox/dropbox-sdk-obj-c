///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBRequestErrors.h"

// Storage blocks

typedef BOOL (^DBRpcResponseBlockStorage)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef BOOL (^DBUploadResponseBlockStorage)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef BOOL (^DBDownloadResponseBlockStorage)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

// Progress blocks

typedef void (^DBProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

// Response blocks

typedef void (^DBRpcResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable);

typedef void (^DBUploadResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable);

typedef void (^DBDownloadUrlResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable, NSURL * _Nullable);

typedef void (^DBDownloadDataResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable, NSData * _Nullable);
