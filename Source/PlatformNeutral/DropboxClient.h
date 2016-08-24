///
/// The client for the User API. Call routes using the namespaces inside this object (inherited from parent).
///

#import <Foundation/Foundation.h>
#import "DbxBase.h"

@interface DropboxClient : DbxBase

- (nonnull instancetype)init:(DropboxTransportClient * _Nonnull)dropboxTransportClient;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andSelectUser:(NSString * _Nonnull)selectUser;

@property (nonatomic) DropboxTransportClient * _Nonnull dropboxTransportClient;

@end
