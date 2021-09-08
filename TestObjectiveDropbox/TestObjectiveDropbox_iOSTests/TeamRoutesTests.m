#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

@interface TeamRoutesTests : XCTestCase
@end

@implementation TeamRoutesTests {
    DropboxTeamTester *_teamTester;
    NSOperationQueue *_delegateQueue;
    DBTeamClient* _teamClient;
}

- (void)setUp {
    self.continueAfterFailure = NO;
    _teamClient = [self createTeamClient];

    TestData * data = [[TestData alloc] init];
    data.teamMemberEmail = [TestAuthTokenGenerator environmentVariableForKey:@"TEAM_MEMBER_EMAIL"];
    data.teamMemberNewEmail = [TestAuthTokenGenerator environmentVariableForKey:@"NON_TEAM_MEMBER_EMAIL"];
    data.accountId = [TestAuthTokenGenerator environmentVariableForKey:@"REFRESH_TOKEN_ACCOUNT_ID"];
    data.accountId2 = [TestAuthTokenGenerator environmentVariableForKey:@"ANY_OTHER_ACCOUNT_ID"];
    data.accountId3 = [TestAuthTokenGenerator environmentVariableForKey:@"NON_TEAM_MEMBER_ACCOUNT_ID"];
    data.accountId3Email = data.teamMemberNewEmail;
    
    _teamTester = [[DropboxTeamTester alloc] initWithTeamClient:_teamClient testData:data];
}

- (DBTeamClient *)createTeamClient {
    // You need an API app with the "Full Dropbox" permission type and at least the scopes in DropboxTeamTester.scopesForTests
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' will be on the app's info page.
    // Then follow https://dropbox.tech/developers/pkce--what-and-why- to get a refresh token using the PKCE flow

    NSString *apiAppKey = [TestAuthTokenGenerator environmentVariableForKey:@"FULL_DROPBOX_API_APP_KEY"];
    DBAccessToken *teamRoutesTestsAuthToken = [TestAuthTokenGenerator
                                          refreshToken:[TestAuthTokenGenerator environmentVariableForKey:@"FULL_DROPBOX_TESTER_TEAM_REFRESH_TOKEN"]
                                          apiKey:apiAppKey
                                          scopes:[DropboxTeamTester scopesForTests]];
    XCTAssertNotNil(teamRoutesTestsAuthToken, @"Errors obtaining auth token.");

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
    return [[DBTeamClient alloc] initWithAccessToken:teamRoutesTestsAuthToken oauthManager:manager transportConfig:transportConfigFullDropbox];
}

- (void)testTeammemberManagement {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [_teamTester testAllTeamMemberManagementActions:^{
        [flag fulfill];
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

- (void)testTeamMemberFileAccess {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    
    [_teamTester testAllTeamMemberFileAcessActions:^(){
        [flag fulfill];
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

@end
