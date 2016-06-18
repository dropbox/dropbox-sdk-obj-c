@class DbxTeamRoutes;
@class DropboxTransportClient;

@interface DbxBaseTeam : NSObject 

- (nonnull instancetype)init:(DropboxTransportClient * _Nonnull)client;

/// Routes within the team namespace. See DbxTeamRoutes for details.
@property (nonatomic) DbxTeamRoutes * _Nonnull teamRoutes;

@end
