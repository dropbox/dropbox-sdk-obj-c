#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

static NSString *scopesForTeamRoutesTests = @"groups.read groups.write members.delete members.read members.write sessions.list team_data.member team_info.read";

@interface TeamRoutesTests : XCTestCase
@end

@implementation TeamRoutesTests {
    DropboxTeamTester *_teamTester;
    NSOperationQueue *_delegateQueue;
    DBTeamClient* _teamClient;
}

- (void)setUp {
    self.continueAfterFailure = NO;
    // You need an API app with the "Full Dropbox" permission type and at least the scopes in scopesForTeamRoutesTests
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' will be on the app's info page.
    // Then follow https://dropbox.tech/developers/pkce--what-and-why- to get a refresh token using the PKCE flow
    NSDictionary<NSString *, NSString *> *processInfoDict = [[NSProcessInfo processInfo] environment];
    NSString *apiAppKey = processInfoDict[@"FULL_DROPBOX_API_APP_KEY"];
    XCTAssertNotEqual(apiAppKey.length, 0, @"FULL_DROPBOX_API_APP_KEY needs to be set in the test Scheme");

    NSString *teamRoutesTestsAuthToken = [TestAuthTokenGenerator
                                refreshToken:processInfoDict[@"FULL_DROPBOX_TESTER_TEAM_REFRESH_TOKEN"]
                                apiKey:apiAppKey
                                scopes:[scopesForTeamRoutesTests componentsSeparatedByString:@" "]];
    XCTAssertNotNil(teamRoutesTestsAuthToken, @"Errors obtaining auth token.");

    NSString *teamMemberEmail = processInfoDict[@"TEAM_MEMBER_EMAIL"];
    NSString *emailToAddAsTeamMember = processInfoDict[@"EMAIL_TO_ADD_AS_TEAM_MEMBER"];

    XCTAssertNotEqual(teamMemberEmail.length, 0, @"TEAM_MEMBER_EMAIL needs to be set in the test Scheme");
    XCTAssertNotEqual(emailToAddAsTeamMember.length, 0, @"EMAIL_TO_ADD_AS_TEAM_MEMBER needs to be set in the test Scheme");

    _delegateQueue = [[NSOperationQueue alloc] init];
    DBTransportDefaultConfig *transportConfigFullDropbox =
      [[DBTransportDefaultConfig alloc] initWithAppKey:apiAppKey
                                             appSecret:nil // not needed
                                             userAgent:nil
                                            asMemberId:nil
                                         delegateQueue:_delegateQueue
                                forceForegroundSession:YES // NO here will cause downloadURL to fail on OSX
                             sharedContainerIdentifier:nil];
    _teamClient = [[DBTeamClient alloc] initWithAccessToken:teamRoutesTestsAuthToken transportConfig:transportConfigFullDropbox];
    TestData * data = [[TestData alloc] init];
    data.teamMemberEmail = teamMemberEmail;
    data.teamMemberNewEmail = emailToAddAsTeamMember;
    _teamTester = [[DropboxTeamTester alloc] initWithTeamRoutes:_teamClient.teamRoutes testData:data];
}

- (void)testTeamRoutes {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [_teamTester testAllTeamMemberManagementActions:^{
        [flag fulfill];
    }];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);

    XCTestExpectation *flag2 = [[XCTestExpectation alloc] init];
    [_teamTester testTeamMemberFileAcessActions:^(TeamTests * tester){
        [flag2 fulfill];
    }];
    XCTWaiterResult result2 = [XCTWaiter waitForExpectations:@[flag2] timeout:60*5];
    XCTAssertEqual(result2, XCTWaiterResultCompleted);
}

@end
