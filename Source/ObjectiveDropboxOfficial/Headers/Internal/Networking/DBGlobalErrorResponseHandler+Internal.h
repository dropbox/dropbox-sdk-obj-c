///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBGlobalErrorResponseHandler.h"

@interface DBGlobalErrorResponseHandler (Internal)

+ (void)executeRegisteredResponseBlocksWithRouteError:(id _Nullable)routeError error:(DBRequestError * _Nullable)error;

@end
