//
//  DBTransportClientBase.m
//  ObjectiveDropboxOfficial
//
//  Created by Stephen Cobbe on 12/1/16.
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DBAUTHAuthError.h"
#import "DBAuthRateLimitError.h"
#import "DBDelegate.h"
#import "DBRequestErrors.h"
#import "DBStoneBase.h"
#import "DBTasks.h"
#import "DBTransportClient.h"
#import "DBTransportClientBase.h"

static NSString const * _Nonnull const kVersion = @"2.0.2";
static NSString const *const kDefaultUserAgentPrefix = @"OfficialDropboxObjCSDKv2";
NSDictionary<NSString *, NSString *> *baseHosts = nil;

#pragma mark - Internal serialization helpers

@implementation DBTransportClientBase

+ (void)initialize {
  baseHosts = @{
    @"api" : @"https://api.dropbox.com/2",
    @"content" : @"https://api-content.dropbox.com/2",
    @"notify" : @"https://notify.dropboxapi.com/2",
  };
}

- (instancetype)init:(NSString *)selectUser
           userAgent:(NSString *)userAgent
              appKey:(NSString *)appKey
           appSecret:(NSString *)appSecret {
  self = [super init];
  if (self) {
    NSString *defaultUserAgent = [NSString stringWithFormat:@"%@/%@", kDefaultUserAgentPrefix, kVersion];

    _selectUser = selectUser;
    _userAgent = userAgent ? [[userAgent stringByAppendingString:@"/"] stringByAppendingString:defaultUserAgent]
                           : defaultUserAgent;
    _appKey = appKey;
    _appSecret = appSecret;
  }
  return self;
}

- (NSDictionary *)headersWithRouteInfo:(NSDictionary<NSString *, NSString *> *)routeAttributes
                           accessToken:(NSString *)accessToken
                         serializedArg:(NSString *)serializedArg {
  NSString *routeStyle = routeAttributes[@"style"];
  NSString *routeHost = routeAttributes[@"host"];
  NSString *routeAuth = routeAttributes[@"auth"];

  NSMutableDictionary<NSString *, NSString *> *headers = [[NSMutableDictionary alloc] init];
  [headers setObject:_userAgent forKey:@"User-Agent"];

  BOOL noauth = [routeHost isEqualToString:@"notify"];

  if (!noauth) {
    if (_selectUser) {
      [headers setObject:_selectUser forKey:@"Dropbox-Api-Select-User"];
    }

    if (routeAuth && [routeAuth isEqualToString:@"app"]) {
      if (!_appKey || !_appSecret) {
        NSLog(@"App key and/or secret not properly configured. Use custom `DBTransportClient` instance to set.");
      }
      NSString *authString = [NSString stringWithFormat:@"%@:%@", _appKey, _appSecret];
      NSData *authData = [authString dataUsingEncoding:NSUTF8StringEncoding];
      [headers setObject:[NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]]
                  forKey:@"Authorization"];
    } else {
      [headers setObject:[NSString stringWithFormat:@"Bearer %@", accessToken] forKey:@"Authorization"];
    }
  }

  if ([routeStyle isEqualToString:@"rpc"]) {
    if (serializedArg) {
      [headers setObject:@"application/json" forKey:@"Content-Type"];
    }
  } else if ([routeStyle isEqualToString:@"upload"]) {
    [headers setObject:@"application/octet-stream" forKey:@"Content-Type"];
    if (serializedArg) {
      [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
    }
  } else if ([routeStyle isEqualToString:@"download"]) {
    if (serializedArg) {
      [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
    }
  }

  return headers;
}

+ (NSURLRequest *)requestWithHeaders:(NSDictionary *)httpHeaders
                                 url:(NSURL *)url
                             content:(NSData *)content
                              stream:(NSInputStream *)stream {
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  for (NSString *key in httpHeaders) {
    [request addValue:httpHeaders[key] forHTTPHeaderField:key];
  }
  request.HTTPMethod = @"POST";
  if (content) {
    request.HTTPBody = content;
  }
  if (stream) {
    request.HTTPBodyStream = stream;
  }
  return request;
}

+ (NSURL *)urlWithRoute:(DBRoute *)route {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", baseHosts[route.attrs[@"host"]], route.namespace_,
                                                         route.name]];
}

+ (NSData *)serializeArgData:(DBRoute *)route routeArg:(id<DBSerializable>)arg {
  if (!arg) {
    return nil;
  }

  if (route.arraySerialBlock) {
    NSArray *serializedArray = route.arraySerialBlock(arg);
    return [[self class] jsonDataWithJsonObj:serializedArray];
  }

  NSDictionary *serializedDict = [[arg class] serialize:arg];
  return [[self class] jsonDataWithJsonObj:serializedDict];
}

+ (NSString *)serializeArgString:(DBRoute *)route routeArg:(id<DBSerializable>)arg {
  if (!arg) {
    return nil;
  }
  NSData *jsonData = [self serializeArgData:route routeArg:arg];
  NSString *asciiEscapedStr = [[self class] asciiEscapeWithString:[[self class] utf8StringWithData:jsonData]];
  NSMutableString *filteredStr = [[NSMutableString alloc] initWithString:asciiEscapedStr];
  [filteredStr replaceOccurrencesOfString:@"\\/"
                               withString:@"/"
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [filteredStr length])];
  return filteredStr;
}

+ (NSData *)jsonDataWithJsonObj:(id)jsonObj {
  if (!jsonObj) {
    return nil;
  }

  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];

  if (!jsonData) {
    NSLog(@"Error serializing dictionary: %@", error.localizedDescription);
    return nil;
  } else {
    return jsonData;
  }
}

+ (NSString *)utf8StringWithData:(NSData *)jsonData {
  return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)asciiEscapeWithString:(NSString *)string {
  NSMutableString *result = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i < string.length; i++) {
    NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
    if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding]) {
      [result appendString:substring];
    } else {
      [result appendFormat:@"\\u%04x", [string characterAtIndex:i]];
    }
  }
  return result;
}

@end
