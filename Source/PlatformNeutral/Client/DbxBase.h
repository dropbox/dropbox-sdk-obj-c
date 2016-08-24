#import "DbxAuthRoutes.h"
#import "DbxFilesRoutes.h"
#import "DbxSharingRoutes.h"
#import "DbxUsersRoutes.h"
#import "DropboxTransportClient.h"

@interface DbxBase : NSObject 

- (nonnull instancetype)init:(DropboxTransportClient * _Nonnull)client;

/// Routes within the auth namespace. See DbxAuthRoutes for details.
@property (nonatomic) DbxAuthRoutes * _Nonnull authRoutes;
/// Routes within the files namespace. See DbxFilesRoutes for details.
@property (nonatomic) DbxFilesRoutes * _Nonnull filesRoutes;
/// Routes within the sharing namespace. See DbxSharingRoutes for details.
@property (nonatomic) DbxSharingRoutes * _Nonnull sharingRoutes;
/// Routes within the users namespace. See DbxUsersRoutes for details.
@property (nonatomic) DbxUsersRoutes * _Nonnull usersRoutes;

@end
