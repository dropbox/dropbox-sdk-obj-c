#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

static NSString *scopesForTeamRoutesTests = @"groups.read groups.write members.delete members.read members.write sessions.list team_data.member team_info.read";
static NSString *scopesForMemberFileAccessUserTests = @"files.content.write files.content.read sharing.write account_info.read";

@interface TeamRoutesTests : XCTestCase
@end

@implementation TeamRoutesTests {
    DropboxTeamTester *_teamTester;
    NSOperationQueue *_delegateQueue;
    DBTeamClient* _teamClient;
}

- (NSString *)environmentVariableForKey:(NSString *)key {
    NSDictionary<NSString *, NSString *> *processInfoDict = [[NSProcessInfo processInfo] environment];
    NSString *value = processInfoDict[key];
    XCTAssertNotNil(value, @"%@ environment variable must exist", key);
    XCTAssertNotEqual(value.length, 0, @"%@ environment variable must be longer than 0", key);
    return value;
}

- (void)setUp {
    self.continueAfterFailure = NO;
    _teamClient = [self createTeamClient];

    TestData * data = [[TestData alloc] init];
    data.teamMemberEmail = [self environmentVariableForKey:@"TEAM_MEMBER_EMAIL"];
    data.teamMemberNewEmail = [self environmentVariableForKey:@"NON_TEAM_MEMBER_EMAIL"];
    data.accountId = [self environmentVariableForKey:@"REFRESH_TOKEN_ACCOUNT_ID"];
    data.accountId2 = [self environmentVariableForKey:@"ANY_OTHER_ACCOUNT_ID"];
    data.accountId3 = [self environmentVariableForKey:@"NON_TEAM_MEMBER_ACCOUNT_ID"];
    data.accountId3Email = data.teamMemberNewEmail;
    
    _teamTester = [[DropboxTeamTester alloc] initWithTeamClient:_teamClient testData:data];
}

- (DBTeamClient *)createTeamClient {
    // You need an API app with the "Full Dropbox" permission type and at least the scopes in scopesForTeamRoutesTests+scopesForMemberFileAccessUserTests
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' will be on the app's info page.
    // Then follow https://dropbox.tech/developers/pkce--what-and-why- to get a refresh token using the PKCE flow

    NSMutableArray<NSString *>*scopes = [[scopesForTeamRoutesTests componentsSeparatedByString:@" "] mutableCopy];
    [scopes addObjectsFromArray:[scopesForMemberFileAccessUserTests componentsSeparatedByString:@" "]];

    NSString *apiAppKey = [self environmentVariableForKey:@"FULL_DROPBOX_API_APP_KEY"];
    NSString *teamRoutesTestsAuthToken = [TestAuthTokenGenerator
                                          refreshToken:[self environmentVariableForKey:@"FULL_DROPBOX_TESTER_TEAM_REFRESH_TOKEN"]
                                          apiKey:apiAppKey
                                          scopes:scopes];
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
    
    return [[DBTeamClient alloc] initWithAccessToken:teamRoutesTestsAuthToken transportConfig:transportConfigFullDropbox];
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
