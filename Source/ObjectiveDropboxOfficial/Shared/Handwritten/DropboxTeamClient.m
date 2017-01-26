///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DropboxClient.h"
#import "DropboxTeamClient.h"

@implementation DropboxTeamClient

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportClient *transportClient = [[DBTransportClient alloc] initWithAccessToken:accessToken];
  return [super initWithTransportClient:transportClient];
}

- (instancetype)initWithTransportClient:(DBTransportClient *)transportClient {
    return [super initWithTransportClient:transportClient];
}

- (DropboxClient *)asMember:(NSString *)memberId {
  return [[DropboxClient alloc] initWithAccessToken:self.transportClient.accessToken selectUser:memberId];
}

@end
