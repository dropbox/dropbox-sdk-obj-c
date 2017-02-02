///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBTransportDefaultClient.h"
#import "DBUserBaseClient.h"
#import "DBUserClient.h"

@implementation DBUserClient {
  DBTransportDefaultClient *_transportClient;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportDefaultClient *transportClient = [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken];
  if (self = [super initWithTransportClient:transportClient]) {
    _transportClient = transportClient;
  }
  return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken selectUser:(NSString *)selectUser {
  DBTransportDefaultClient *transportClient =
      [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken selectUser:selectUser];
  if (self = [super initWithTransportClient:transportClient]) {
    _transportClient = transportClient;
  }
  return self;
}

- (instancetype)initWithTransportClient:(DBTransportDefaultClient *)transportClient {
  if (self = [super initWithTransportClient:transportClient]) {
    _transportClient = transportClient;
  }
  return self;
}

- (void)updateAccessToken:(NSString *)accessToken {
  _transportClient.accessToken = accessToken;
}

- (BOOL)isAuthorized {
  return _transportClient.accessToken != nil;
}

@end
