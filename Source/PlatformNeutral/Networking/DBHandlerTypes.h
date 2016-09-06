///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

/// These are internal handler block types used by the SDK. The client-facing handler blocks
/// look somewhat different. All are for internal use only.

typedef void (^DBProgressBlock)(int64_t, int64_t, int64_t);

typedef void (^DBRpcResponseBlock)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef void (^DBUploadResponseBlock)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

typedef void (^DBDownloadResponseBlock)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
