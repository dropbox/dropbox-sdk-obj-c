#import <XCTest/XCTest.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

@implementation TestAuthTokenGenerator

+ (NSString *)environmentVariableForKey:(NSString *)key {
    NSDictionary<NSString *, NSString *> *processInfoDict = [[NSProcessInfo processInfo] environment];
    NSString *value = processInfoDict[key];
    XCTAssertNotNil(value, @"%@ environment variable must exist", key);
    XCTAssertNotEqual(value.length, 0, @"%@ environment variable must be longer than 0", key);
    XCTAssertFalse([value hasSuffix:@" "], @"%@ environment variable value must not end in whitespace", key);
    return value;
}

// Easy way for all tests to get an auth token for the scopes they use.
+ (nullable DBAccessToken *)refreshToken:(nullable NSString *)refreshToken
                             apiKey:(nullable NSString *)apiKey
                             scopes:(nonnull NSArray<NSString *>*)scopes {
    XCTAssertNotEqual(refreshToken.length, 0, @"Error: refreshToken needs to be set");
    if (refreshToken.length == 0) {
        return nil;
    }
    XCTAssertNotEqual(apiKey.length, 0, @"Error: api key needs to be set");
    if(apiKey.length == 0) {
        return nil;
    }

    DBAccessToken *defaultToken = [[DBAccessToken alloc]
                                   initWithAccessToken:@"" // no previous token
                                   uid:@"" // don't need uid
                                   refreshToken:refreshToken
                                   tokenExpirationTimestamp:0];

    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    DBOAuthManager *manager = [[DBOAuthManager alloc] initWithAppKey:apiKey];
    __block DBAccessToken *authToken = nil;
    [manager refreshAccessToken:defaultToken
                         scopes:scopes
                          queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                     completion:^(DBOAuthResult * result) {
        if(!result.isSuccess) {
            XCTFail(@"Error: failed to refresh access token (%@)", result.errorDescription);
        } else {
            authToken = result.accessToken;
        }
        [flag fulfill];
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:10];
    XCTAssertEqual(result, XCTWaiterResultCompleted, @"Error: Timeout refreshing access token");
    return authToken;
}

@end
