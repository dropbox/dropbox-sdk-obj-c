///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBBase.h"
#import "DBTransportClient.h"
#import "DropboxClient.h"

@implementation DropboxClient

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  DBTransportClient *transportClient = [[DBTransportClient alloc] initWithAccessToken:accessToken];
  return [super initWithTransportClient:transportClient];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken selectUser:(NSString *)selectUser {
  DBTransportClient *transportClient =
      [[DBTransportClient alloc] initWithAccessToken:accessToken selectUser:selectUser];
  return [super initWithTransportClient:transportClient];
}

- (instancetype)initWithTransportClient:(DBTransportClient *)transportClient {
  return [super initWithTransportClient:transportClient];
}

@end
