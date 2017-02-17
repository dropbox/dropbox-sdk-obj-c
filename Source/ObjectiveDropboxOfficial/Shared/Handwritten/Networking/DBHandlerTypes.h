///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Public handler types.
///

#import <Foundation/Foundation.h>

@class DBASYNCPollError;
@class DBFILESUploadSessionFinishBatchJobStatus;
@class DBRequestError;

/// The progress block to be executed in the event of a request update. The first argument is the number of bytes
/// downloaded. The second argument is the number of total bytes downloaded. And the third argument is the number of
/// total bytes expected to be downloaded.
typedef void (^DBProgressBlock)(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite);

/// Special custom response block for batch upload. The first argument is the async job status object, the second object
/// is the route-specific error (or `nil`, if no erro), and the third object is the generic HTTP error (or `nil`, if no
/// error).
typedef void (^DBBatchUploadResponseBlock)(DBFILESUploadSessionFinishBatchJobStatus * _Nullable,
                                           DBASYNCPollError * _Nullable, DBRequestError * _Nullable);
