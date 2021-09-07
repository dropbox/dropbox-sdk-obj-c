#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

@interface FileRoutesTests : XCTestCase
@end

@implementation FileRoutesTests {
    NSOperationQueue *_delegateQueue;
    DBUserClient* _userClient;
    DropboxTester *_tester;
    TestData *_testData;
}

- (DBUserClient *)createUserClient {
    self.continueAfterFailure = NO;
    // You need an API app with the "Full Dropbox" permission type and at least the scopes in DropoboxTester.scopesForTests
    // and no team scopes.
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' will be on the app's info page.
    // Then follow https://dropbox.tech/developers/pkce--what-and-why- to get a refresh token using the PKCE flow
    NSString *apiAppKey = [TestAuthTokenGenerator environmentVariableForKey:@"FULL_DROPBOX_API_APP_KEY"];

    DBAccessToken *fileRoutesTestsAuthToken = [TestAuthTokenGenerator
                                          refreshToken:[TestAuthTokenGenerator environmentVariableForKey:@"FULL_DROPBOX_TESTER_USER_REFRESH_TOKEN"]
                                          apiKey:apiAppKey
                                          scopes:[DropboxTester scopesForTests]];
    XCTAssertNotNil(fileRoutesTestsAuthToken, @"Error obtaining auth token.");

    _delegateQueue = [[NSOperationQueue alloc] init];
    DBTransportDefaultConfig *transportConfigFullDropbox =
      [[DBTransportDefaultConfig alloc] initWithAppKey:apiAppKey
                                             appSecret:nil // not needed
                                             userAgent:nil
                                            asMemberId:nil
                                         delegateQueue:_delegateQueue
                                forceForegroundSession:YES // NO here will cause downloadURL to fail on OSX
                             sharedContainerIdentifier:nil];

    DBOAuthManager *manager = [[DBOAuthManager alloc] initWithAppKey:transportConfigFullDropbox.appKey];
    return [[DBUserClient alloc] initWithAccessToken:fileRoutesTestsAuthToken oauthManager:manager transportConfig:transportConfigFullDropbox];
}

- (void)setUp {
    self.continueAfterFailure = NO;
    _userClient = [self createUserClient];

    TestData * data = [[TestData alloc] init];
    data.teamMemberEmail = [TestAuthTokenGenerator environmentVariableForKey:@"TEAM_MEMBER_EMAIL"];
    data.teamMemberNewEmail = [TestAuthTokenGenerator environmentVariableForKey:@"NON_TEAM_MEMBER_EMAIL"];
    data.accountId = [TestAuthTokenGenerator environmentVariableForKey:@"REFRESH_TOKEN_ACCOUNT_ID"];
    data.accountId2 = [TestAuthTokenGenerator environmentVariableForKey:@"ANY_OTHER_ACCOUNT_ID"];
    data.accountId3 = [TestAuthTokenGenerator environmentVariableForKey:@"NON_TEAM_MEMBER_ACCOUNT_ID"];
    data.accountId3Email = data.teamMemberNewEmail;
    
    _tester = [[DropboxTester alloc] initWithUserClient:_userClient testData:data];
    _testData = data;
}

- (void)tearDown {
    NSLog(@"tearDown: delete folder");
    if (_userClient == nil) {
        return;
    }
    FilesTests *filesTests = [[FilesTests alloc] init:_userClient.filesRoutes
                                             testData:_testData];

    // delete to cleanup
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [filesTests deleteV2:^{
        [flag fulfill];
    }];
    [self waitForExpectations:@[flag] timeout:30]; // don't need to check result
}

- (void)testAllUserEndpoints {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [_tester testAllUserAPIEndpoints:^{
        [flag fulfill];
    } asMember:NO];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

@end
