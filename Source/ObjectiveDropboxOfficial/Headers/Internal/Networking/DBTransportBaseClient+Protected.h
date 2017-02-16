///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBTransportBaseClient.h"

/// Used by subclasses of `DBTransportBaseClient`
@interface DBTransportBaseClient (Protected)

- (NSDictionary *)headersWithRouteInfo:(NSDictionary<NSString *, NSString *> *)routeAttributes
                           accessToken:(NSString *)accessToken
                         serializedArg:(NSString *)serializedArg;

+ (NSURLRequest *)requestWithHeaders:(NSDictionary *)httpHeaders
                                 url:(NSURL *)url
                             content:(NSData *)content
                              stream:(NSInputStream *)stream;

+ (NSURL *)urlWithRoute:(DBRoute *)route;

+ (NSData *)serializeDataWithRoute:(DBRoute *)route routeArg:(id<DBSerializable>)arg;

+ (NSString *)serializeStringWithRoute:(DBRoute *)route routeArg:(id<DBSerializable>)arg;

@end
