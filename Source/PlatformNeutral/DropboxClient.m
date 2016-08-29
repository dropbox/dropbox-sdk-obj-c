#import "DBXBase.h"
#import "DBXTransportClient.h"
#import "DropboxClient.h"

@implementation DropboxClient

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken];
    self = [super initWithTransportClient:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken selectUser:(NSString *)selectUser {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken selectUser:selectUser];
    self = [super initWithTransportClient:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

- (instancetype)initWithTransportClient:(DBXTransportClient *)transportClient {
    self = [super initWithTransportClient:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

@end
