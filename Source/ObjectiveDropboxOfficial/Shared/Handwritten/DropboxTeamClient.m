///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DropboxClient.h"
#import "DropboxTeamClient.h"

@implementation DropboxTeamClient {
  DBTransportClient *_transportClient;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportClient *transportClient = [[DBTransportClient alloc] initWithAccessToken:accessToken];
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

- (DropboxClient *)asMember:(NSString *)memberId {
  return [[DropboxClient alloc] initWithAccessToken:_transportClient.accessToken selectUser:memberId];
}

- (void)updateAccessToken:(NSString *)accessToken {
  _transportClient.accessToken = accessToken;
}

- (BOOL)isAuthorized {
  return _transportClient.accessToken != nil;
}

@end
