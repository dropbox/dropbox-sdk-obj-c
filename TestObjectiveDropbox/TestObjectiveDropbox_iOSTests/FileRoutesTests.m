#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

static NSString *scopesForFileRoutesTests = @"account_info.read files.content.read files.content.write files.metadata.read files.metadata.write";

@interface FileRoutesTests : XCTestCase
@end

@implementation FileRoutesTests {
    NSOperationQueue *_delegateQueue;
    DBUserClient* _userClient;
    DropboxTester *_tester;
    TestData *_testData;
    BOOL _shouldFail;
}

- (void)setUp {
    self.continueAfterFailure = NO;
    NSDictionary<NSString *, NSString *> *processInfoDict = [[NSProcessInfo processInfo] environment];

    // You need an API app with the "Full Dropbox" permission type and at least the scopes in scopesForFileRoutesTests
    // and no team scopes.
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' will be on the app's info page.
    // Then follow https://dropbox.tech/developers/pkce--what-and-why- to get a refresh token using the PKCE flow
    NSString *apiAppKey = processInfoDict[@"FULL_DROPBOX_API_APP_KEY"];
    XCTAssertNotNil(apiAppKey, @"FULL_DROPBOX_API_APP_KEY needs to be set in the test Scheme");

    NSString *fileRoutesTestsAuthToken = [TestAuthTokenGenerator
                                refreshToken:processInfoDict[@"FULL_DROPBOX_TESTER_USER_REFRESH_TOKEN"]
                                apiKey:apiAppKey
                                scopes:[scopesForFileRoutesTests componentsSeparatedByString:@" "]];
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

    _userClient = [[DBUserClient alloc] initWithAccessToken:fileRoutesTestsAuthToken
        transportConfig:transportConfigFullDropbox];

    _testData = [[TestData alloc] init];
    _tester = [[DropboxTester alloc] initWithUserClient:_userClient testData:_testData];
}

-(void)tearDown {
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
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

- (void)testFileRoutes {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [_tester testFilesEndpoints:^{
        [flag fulfill];
    } asMember:NO];
    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:60*5];
    XCTAssertEqual(result, XCTWaiterResultCompleted);
}

@end
