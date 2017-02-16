///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// For internal use inside the SDK.
///

#import <Foundation/Foundation.h>

@class DBRequestError;

// Storage blocks

typedef BOOL (^DBRpcResponseBlockStorage)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef BOOL (^DBUploadResponseBlockStorage)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef BOOL (^DBDownloadResponseBlockStorage)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

// Response blocks

typedef void (^DBRpcResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable);

typedef void (^DBUploadResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable);

typedef void (^DBDownloadUrlResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable, NSURL * _Nullable);

typedef void (^DBDownloadDataResponseBlock)(id _Nullable, id _Nullable, DBRequestError * _Nullable, NSData * _Nullable);
