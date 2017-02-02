///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBHandlerTypes.h"
#import "DBTasks.h"
#import <Foundation/Foundation.h>

@class DBRoute;

@interface DBRpcTask (Protected)

- (DBRpcResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:(DBRpcResponseBlock _Nonnull)responseBlock;

@end

@interface DBUploadTask (Protected)

- (DBUploadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:(DBUploadResponseBlock _Nonnull)responseBlock;

@end

@interface DBDownloadUrlTask (Protected)

- (DBDownloadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:
                                               (DBDownloadUrlResponseBlock _Nonnull)responseBlock
                                                             destination:(NSURL * _Nonnull)destination
                                                               overwrite:(BOOL)overwrite;

@end

@interface DBDownloadDataTask (Protected)

- (DBDownloadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:
                                               (DBDownloadDataResponseBlock _Nonnull)responseBlock;

@end
