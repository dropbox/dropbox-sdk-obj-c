///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBTransportBaseClient.h"

/// Used by internal classes of `DBTransportBaseClient`
@interface DBTransportBaseClient (Internal)

+ (DBRequestError * _Nullable)dBRequestErrorWithErrorData:(NSData * _Nullable)errorData
                                             clientError:(NSError * _Nullable)clientError
                                              statusCode:(int)statusCode
                                             httpHeaders:(NSDictionary * _Nullable)httpHeaders;

+ (id _Nullable)routeErrorWithRouteData:(DBRoute * _Nullable)route
                                   data:(NSData * _Nullable)data
                             statusCode:(int)statusCode;

+ (id _Nullable)routeResultWithRouteData:(DBRoute * _Nullable)route
                                    data:(NSData * _Nullable)data
                      serializationError:(NSError * _Nullable * _Nullable)serializationError;

+ (BOOL)statusCodeIsRouteError:(int)statusCode;

+ (NSString * _Nullable)caseInsensitiveLookupWithKey:(NSString * _Nullable)lookupKey
                                         dictionary:(NSDictionary<id, id> * _Nullable)dictionary;

+ (NSString * _Nonnull)sdkVersion;

+ (NSString * _Nonnull)defaultUserAgent;

@end
