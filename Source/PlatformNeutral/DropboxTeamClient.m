#import "DropboxClient.h"
#import "DropboxTeamClient.h"

@implementation DropboxTeamClient

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken];
    self = [super initWithTransportClient:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
        _accessToken = accessToken;
    }
    return self;
}

- (instancetype)initWithTransportClient:(DBXTransportClient *)transportClient {
    self = [super initWithTransportClient:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
        _accessToken = transportClient.accessToken;
    }
    return self;
}

- (DropboxClient *)asMember:(NSString *)memberId {
    return [[DropboxClient alloc] initWithAccessToken:self.accessToken selectUser:memberId];
}

@end
