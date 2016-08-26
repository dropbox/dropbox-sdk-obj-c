///
/// The client for the User API. Call routes using the namespaces inside this object (inherited from parent).
///

#import <Foundation/Foundation.h>
#import "DBXBase.h"

@interface DropboxClient : DBXBase

- (nonnull instancetype)init:(DBXTransportClient * _Nonnull)transportClient;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andSelectUser:(NSString * _Nonnull)selectUser;

@property (nonatomic) DBXTransportClient * _Nonnull transportClient;

@end
