#import <XCTest/XCTest.h>
#import "TestClasses.h"
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface FilesTestCase : XCTestCase

@end

@implementation FilesTestCase {
    NSOperationQueue *_delegateQueue;
    DBUserClient* _userClient;
    FilesTests *_fileTests;
}

- (void)setUp {
    NSDictionary<NSString *, NSString *> *processInfoDict = [[NSProcessInfo processInfo] environment];

    // You need an API app with the "Full Dropbox" permission type.
    // You can create one for testing here: https://www.dropbox.com/developers/apps/create
    // The 'App key' and 'App secret' will be on the app's info page.
    // Then click 'Generate' under "Generated access token" to get an oauth2 token.
    // Once you have these 3 values, add them to the Scheme's Test action's environment variables.
    NSString *apiAppKey = processInfoDict[@"FULL_DROPBOX_API_APP_KEY"];
    NSString *apiAppSecret = processInfoDict[@"FULL_DROPBOX_API_APP_SECRET"];
    NSString *oauth2Token = processInfoDict[@"FULL_DROPBOX_USER_OAUTH2_TOKEN"];
    XCTAssertNotNil(apiAppKey, @"FULL_DROPBOX_API_APP_KEY needs to be set in the test Scheme");
    XCTAssertNotNil(apiAppSecret, @"FULL_DROPBOX_API_APP_SECRET needs to be set in the test Scheme");
    XCTAssertNotNil(oauth2Token, @"FULL_DROPBOX_USER_OAUTH2_TOKEN needs to be set in the test Scheme");

    _delegateQueue = [[NSOperationQueue alloc] init];
    DBTransportDefaultConfig *transportConfigFullDropbox =
      [[DBTransportDefaultConfig alloc] initWithAppKey:apiAppKey
                                             appSecret:apiAppSecret
                                             userAgent:nil
                                            asMemberId:nil
                                         delegateQueue:_delegateQueue
                                forceForegroundSession:NO
                             sharedContainerIdentifier:nil];
    _userClient = [[DBUserClient alloc] initWithAccessToken:oauth2Token
        transportConfig:transportConfigFullDropbox];
    _fileTests = [[FilesTests alloc] init:_userClient.filesRoutes testData:[[TestData alloc] init]];
}

-(void)tearDown {
    [self runTestAndWait:@selector(deleteV2:)]; // delete to cleanup
}

// This is an XCTest implementation of the files tests.
// Ordering seems to matter, since the account has state, so we can't split
// this into multiple tests.
// Failures will assert (ie crash the runner). This can be changed to XCTFail
// in the future so that we can at least cleanup the account (ie delete the folder).
- (void)testFileRoutes {

    [TestFormat printTestBegin:NSStringFromSelector(_cmd)];

    [self runTestAndWait:@selector(deleteV2:)]; // delete in case of leftover from another test
    [self runTestAndWait:@selector(createFolderV2:)];
    [self runTestAndWait:@selector(listFolderError:)];
    [self runTestAndWait:@selector(listFolder:)];
    [self runTestAndWait:@selector(uploadData:)];
    [self runTestAndWait:@selector(uploadDataSession:)];
    [self runTestAndWait:@selector(dCopyV2:)];
    [self runTestAndWait:@selector(dCopyReferenceGet:)];
    [self runTestAndWait:@selector(getMetadataError:)];
    [self runTestAndWait:@selector(getTemporaryLink:)];
    [self runTestAndWait:@selector(listRevisions:)];
    [self runTestAndWait:@selector(moveV2:)];

    // do this manually since this one has an extra argument
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    [_fileTests saveUrl:^{
        [flag fulfill];
    } asMember:NO];
    [self waitForExpectations:@[flag] timeout:3];

    [self runTestAndWait:@selector(downloadToFile:)];
    [self runTestAndWait:@selector(downloadToFileAgain:)];
    [self runTestAndWait:@selector(downloadToMemory:)];
    [self runTestAndWait:@selector(downloadToMemoryWithRange:)];
    [self runTestAndWait:@selector(uploadFile:)];
    [self runTestAndWait:@selector(uploadStream:)];
    [self runTestAndWait:@selector(listFolderLongpollAndTrigger:)];

    [TestFormat printTestEnd];
}

// Test selector must have completion block as only argument
// This is dirty I know, this would be cleaner in Swift since methods are objects.
- (void)runTestAndWait:(SEL)testSelector {
    XCTestExpectation *flag = [[XCTestExpectation alloc] init];

    // supress "performSelector may cause a leak because its selector is unknown" warning
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [_fileTests performSelector:testSelector withObject:^{
        [flag fulfill];
    }];
#pragma clang diagnostic pop

    [self waitForExpectations:@[flag] timeout:3];
}

@end
