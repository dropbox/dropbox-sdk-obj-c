#import "DbxBase.h"
#import "DropboxClient.h"
#import "DropboxTransportClient.h"

@implementation DropboxClient

- (instancetype)init:(DropboxTransportClient *)dropboxTransportClient
{
    self = [super init:dropboxTransportClient];
    if (self != nil) {
        _dropboxTransportClient = dropboxTransportClient;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
{
    DropboxTransportClient *client = [[DropboxTransportClient alloc] initWithAccessToken:accessToken];
    self = [super init:client];
    if (self != nil) {
        _dropboxTransportClient = client;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser
{
    DropboxTransportClient *client = [[DropboxTransportClient alloc] initWithAccessToken:accessToken andSelectUser:selectUser];
    self = [super init:client];
    if (self != nil) {
        _dropboxTransportClient = client;
    }
    return self;
}

@end
