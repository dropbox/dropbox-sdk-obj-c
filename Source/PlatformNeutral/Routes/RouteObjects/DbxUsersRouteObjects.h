/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"

@interface DbxUsersRouteObjects : NSObject 

+ (DbxRoute *)dbxUsersGetAccount;

+ (DbxRoute *)dbxUsersGetAccountBatch;

+ (DbxRoute *)dbxUsersGetCurrentAccount;

+ (DbxRoute *)dbxUsersGetSpaceUsage;

@end
