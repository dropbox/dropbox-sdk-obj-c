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
/// is the route-specific error (or `nil`, if no error), and the third object is the generic HTTP error (or `nil`, if no
/// error).
typedef void (^DBBatchUploadResponseBlock)(DBFILESUploadSessionFinishBatchJobStatus * _Nullable result,
                                           DBASYNCPollError * _Nullable routeError, DBRequestError * _Nullable error);

/// Special custom response block for performing SDK token migration between API v1 tokens and API v2 tokens. First
/// argument indicates whether the migration should be attempted again (primarily when there was no active network
/// connection). The second argument indicates whether the supplied app key and / or secret is invalid for some or
/// all tokens. The third argument is a list of token data for each token that was unsuccessfully migrated. Each
/// element in the list is a list of length 4, where the first element is the Dropbox user ID, the second element
/// is the OAuth 1 access token, the third element is the OAuth 1 access token secret, and the fourth element
/// is the consumer app key that was stored with the token.
typedef void (^DBTokenMigrationResponseBlock)(BOOL shouldRetry, BOOL invalidAppKeyOrSecret,
                                              NSArray<NSArray<NSString *> *> * _Nonnull unsuccessfullyMigratedTokenData);
