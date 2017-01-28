///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBBase.h"
#import "DBTransportClient.h"
#import "DropboxClient.h"

@implementation DropboxClient {
  DBTransportClient *_transportClient;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportClient *transportClient = [[DBTransportClient alloc] initWithAccessToken:accessToken];
  if (self = [super initWithTransportClient:transportClient]) {
    _transportClient = transportClient;
  }
  return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken selectUser:(NSString *)selectUser {
  DBTransportClient *transportClient =
      [[DBTransportClient alloc] initWithAccessToken:accessToken selectUser:selectUser];
  if (self = [super initWithTransportClient:transportClient]) {
    _transportClient = transportClient;
  }
  return self;
}

- (instancetype)initWithTransportClient:(DBTransportClient *)transportClient {
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
