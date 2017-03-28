///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBGlobalErrorResponseHandler.h"

@class DBTask;

@interface DBGlobalErrorResponseHandler (Internal)

+ (void)executeRegisteredResponseBlocksWithRouteError:(id _Nullable)routeError
                                         networkError:(DBRequestError * _Nullable)networkError
                                          restartTask:(DBTask * _Nonnull)restartTask;

@end
