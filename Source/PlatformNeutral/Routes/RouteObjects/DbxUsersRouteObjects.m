/// 
/// Stone Route Objects
/// 

#import "DbxStoneBase.h"
#import "DbxUsersAccount.h"
#import "DbxUsersAccountType.h"
#import "DbxUsersBasicAccount.h"
#import "DbxUsersFullAccount.h"
#import "DbxUsersFullTeam.h"
#import "DbxUsersGetAccountArg.h"
#import "DbxUsersGetAccountBatchArg.h"
#import "DbxUsersGetAccountBatchError.h"
#import "DbxUsersGetAccountError.h"
#import "DbxUsersName.h"
#import "DbxUsersRouteObjects.h"
#import "DbxUsersRoutes.h"
#import "DbxUsersSpaceAllocation.h"
#import "DbxUsersSpaceUsage.h"

@implementation DbxUsersRouteObjects 

static DbxRoute *dbxUsersGetAccount = nil;
static DbxRoute *dbxUsersGetAccountBatch = nil;
static DbxRoute *dbxUsersGetCurrentAccount = nil;
static DbxRoute *dbxUsersGetSpaceUsage = nil;

+ (DbxRoute *)dbxUsersGetAccount {
    if (!dbxUsersGetAccount) {
        dbxUsersGetAccount = [[DbxRoute alloc] init:
            @"get_account"
            namespace_:@"users"
            deprecated:@NO
            resultType:[DbxUsersBasicAccount class]
            errorType: [DbxUsersGetAccountError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxUsersGetAccount;
}

+ (DbxRoute *)dbxUsersGetAccountBatch {
    if (!dbxUsersGetAccountBatch) {
        dbxUsersGetAccountBatch = [[DbxRoute alloc] init:
            @"get_account_batch"
            namespace_:@"users"
            deprecated:@NO
            resultType:[NSArray<DbxUsersBasicAccount *> class]
            errorType: [DbxUsersGetAccountBatchError class]
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxUsersGetAccountBatch;
}

+ (DbxRoute *)dbxUsersGetCurrentAccount {
    if (!dbxUsersGetCurrentAccount) {
        dbxUsersGetCurrentAccount = [[DbxRoute alloc] init:
            @"get_current_account"
            namespace_:@"users"
            deprecated:@NO
            resultType:[DbxUsersFullAccount class]
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxUsersGetCurrentAccount;
}

+ (DbxRoute *)dbxUsersGetSpaceUsage {
    if (!dbxUsersGetSpaceUsage) {
        dbxUsersGetSpaceUsage = [[DbxRoute alloc] init:
            @"get_space_usage"
            namespace_:@"users"
            deprecated:@NO
            resultType:[DbxUsersSpaceUsage class]
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxUsersGetSpaceUsage;
}

@end
