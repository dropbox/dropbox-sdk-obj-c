//
//  DBTransportBaseClient+Protected.h
//  ObjectiveDropboxOfficial
//
//  Created by Stephen Cobbe on 1/30/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBTransportBaseClient.h"

@interface DBTransportBaseClient (Protected)

- (NSDictionary *)headersWithRouteInfo:(NSDictionary<NSString *, NSString *> *)routeAttributes
                           accessToken:(NSString *)accessToken
                         serializedArg:(NSString *)serializedArg;

+ (NSURLRequest *)requestWithHeaders:(NSDictionary *)httpHeaders
                                 url:(NSURL *)url
                             content:(NSData *)content
                              stream:(NSInputStream *)stream;

+ (NSURL *)urlWithRoute:(DBRoute *)route;

+ (NSData *)serializeArgData:(DBRoute *)route routeArg:(id<DBSerializable>)arg;

+ (NSString *)serializeArgString:(DBRoute *)route routeArg:(id<DBSerializable>)arg;

@end
