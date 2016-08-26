///
/// The client for the Business API. Call routes using the namespaces inside this object (inherited from parent).
///

#import <Foundation/Foundation.h>
#import "DBXBaseTeam.h"

@interface DropboxTeamClient : DBXBaseTeam

- (nonnull instancetype)init:(DBXTransportClient * _Nonnull)transportClient;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

- (DropboxClient * _Nonnull)asMember:(NSString * _Nonnull)memberId;

@property (nonatomic) DBXTransportClient * _Nonnull transportClient;
@property (nonatomic) NSString * _Nullable accessToken;

@end
