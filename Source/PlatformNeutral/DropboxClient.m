#import "DBXBase.h"
#import "DBXTransportClient.h"
#import "DropboxClient.h"

@implementation DropboxClient

- (instancetype)init:(DBXTransportClient *)transportClient {
    self = [super init:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken];
    self = [super init:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser {
    DBXTransportClient *transportClient = [[DBXTransportClient alloc] initWithAccessToken:accessToken andSelectUser:selectUser];
    self = [super init:transportClient];
    if (self != nil) {
        _transportClient = transportClient;
    }
    return self;
}

@end
