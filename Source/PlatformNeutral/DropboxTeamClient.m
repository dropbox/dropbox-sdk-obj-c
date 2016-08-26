#import "DropboxClient.h"
#import "DropboxTeamClient.h"

@implementation DropboxTeamClient

- (instancetype)init:(DBXTransportClient *)transportClient {
    self = [super init:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
        _accessToken = transportClient.accessToken;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken];
    self = [super init:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
        _accessToken = accessToken;
    }
    return self;
}

- (DropboxClient *)asMember:(NSString *)memberId {
    return [[DropboxClient alloc] initWithAccessToken:self.accessToken andSelectUser:memberId];
}

@end
