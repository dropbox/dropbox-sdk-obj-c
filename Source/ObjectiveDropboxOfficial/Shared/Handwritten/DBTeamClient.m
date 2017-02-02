///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBTeamClient.h"
#import "DBUserClient.h"

@implementation DBTeamClient {
  DBTransportDefaultClient *_transportClient;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportDefaultClient *transportClient = [[DBTransportDefaultClient alloc] initWithAccessToken:accessToken];
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

- (DBUserClient *)asMember:(NSString *)memberId {
  return [[DBUserClient alloc] initWithAccessToken:_transportClient.accessToken selectUser:memberId];
}

- (void)updateAccessToken:(NSString *)accessToken {
  _transportClient.accessToken = accessToken;
}

- (BOOL)isAuthorized {
  return _transportClient.accessToken != nil;
}

@end
