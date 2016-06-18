///
/// The client for the Business API. Call routes using the namespaces inside this object (inherited from parent).
///

#import "DbxBase.h"
#import "DropboxClient.h"
#import "DropboxTeamClient.h"
#import "DropboxTransportClient.h"

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
