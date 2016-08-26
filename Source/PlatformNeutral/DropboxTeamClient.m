#import "DropboxClient.h"
#import "DropboxTeamClient.h"

@implementation DropboxTeamClient

- (instancetype)init:(DropboxTransportClient *)dropboxTransportClient
{
    self = [super init:dropboxTransportClient];
    if (self != nil) {
        _dropboxTransportClient = dropboxTransportClient;
        _accessToken = dropboxTransportClient.accessToken;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
{
    DropboxTransportClient *client = [[DropboxTransportClient alloc] initWithAccessToken:accessToken];
    self = [super init:client];
    if (self != nil) {
        _dropboxTransportClient = client;
        _accessToken = accessToken;
    }
    return self;
}

- (DropboxClient *)asMember:(NSString *)memberId
{
    return [[DropboxClient alloc] initWithAccessToken:self.accessToken andSelectUser:memberId];
}

@end
