///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBHandlerTypes.h"
#import "DBTasks.h"
#import <Foundation/Foundation.h>

@class DBRoute;

@interface DBRpcTask (Protected)

- (DBRpcResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:(DBRpcResponseBlock _Nonnull)responseBlock
                                                              route:(DBRoute * _Nonnull)route;

@end

@interface DBUploadTask (Protected)

- (DBUploadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:(DBUploadResponseBlock _Nonnull)responseBlock
                                                                 route:(DBRoute * _Nonnull)route;

@end

@interface DBDownloadUrlTask (Protected)

- (DBDownloadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:
                                               (DBDownloadUrlResponseBlock _Nonnull)responseBlock
                                                                   route:(DBRoute * _Nonnull)route
                                                             destination:(NSURL * _Nonnull)destination
                                                               overwrite:(BOOL)overwrite;

@end

@interface DBDownloadDataTask (Protected)

- (DBDownloadResponseBlockStorage _Nonnull)storageBlockWithResponseBlock:
                                               (DBDownloadDataResponseBlock _Nonnull)responseBlock
                                                                   route:(DBRoute * _Nonnull)route;

@end
