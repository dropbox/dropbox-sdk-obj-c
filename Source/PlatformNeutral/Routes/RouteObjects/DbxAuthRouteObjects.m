/// 
/// Stone Route Objects
/// 

#import "DbxAuthRouteObjects.h"
#import "DbxAuthRoutes.h"
#import "DbxStoneBase.h"

@implementation DbxAuthRouteObjects 

static DbxRoute *dbxAuthTokenRevoke = nil;

+ (DbxRoute *)dbxAuthTokenRevoke {
    if (!dbxAuthTokenRevoke) {
        dbxAuthTokenRevoke = [[DbxRoute alloc] init:
            @"token/revoke"
            namespace_:@"auth"
            deprecated:@NO
            resultType:nil
            errorType: nil
            attrs: @{@"host": @"api",
                     @"style": @"rpc"}
        ];
    }
    return dbxAuthTokenRevoke;
}

@end
