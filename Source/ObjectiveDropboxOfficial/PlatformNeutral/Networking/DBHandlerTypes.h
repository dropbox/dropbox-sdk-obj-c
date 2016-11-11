///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

typedef void (^DBProgressBlock)(int64_t committed, int64_t totalCommitted, int64_t expectedToCommit);

typedef void (^DBRpcResponseBlock)(NSData * _Nullable responseBody, NSURLResponse * _Nullable responseMetadata, NSError * _Nullable responseError);

typedef void (^DBUploadResponseBlock)(NSData * _Nullable responseBody, NSURLResponse * _Nullable responseMetadata, NSError * _Nullable responseError);

typedef void (^DBDownloadResponseBlock)(NSURL * _Nullable urlOutput, NSURLResponse * _Nullable responseMetadata, NSError * _Nullable responseError);
