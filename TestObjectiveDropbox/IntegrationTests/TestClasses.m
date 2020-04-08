//
//  TestClasses.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "TestClasses.h"
#import "TestData.h"

static DBUserClient *s_teamAdminUserClient = nil;

void MyLog(NSString *format, ...) {
  va_list args;
  va_start(args, format);
  NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:args];
  va_end(args);
  [[NSFileHandle fileHandleWithStandardOutput] writeData:[formattedString dataUsingEncoding:NSNEXTSTEPStringEncoding]];
}

@implementation DropboxTester

- (instancetype)initWithTestData:(TestData *)testData {
  self = [super init];
  if (self) {
    DBUserClient *clientToUse = s_teamAdminUserClient ?: [DBClientsManager authorizedClient];
    NSAssert(clientToUse, @"No authorized user client.");
    _testData = testData;
    DBAppClient *unauthorizedClient = [[DBAppClient alloc] initWithAppKey:_testData.fullDropboxAppKey appSecret:_testData.fullDropboxAppSecret];
    _unauthorizedClient = unauthorizedClient;
    _auth = clientToUse.authRoutes;
    _appAuth = unauthorizedClient.authRoutes;
    _files = clientToUse.filesRoutes;
    _sharing = clientToUse.sharingRoutes;
    _users = clientToUse.usersRoutes;
  }
  return self;
}

// Test user app with 'Full Dropbox' permission
- (void)testAllUserAPIEndpoints:(void (^)(void))nextTest asMember:(BOOL)asMember {
    void (^end)(void) = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
    void (^testAuthEndpoints)(void) = ^{
    [self testAuthEndpoints:end];
  };
    void (^testUsersEndpoints)(void) = ^{
    [self testUsersEndpoints:testAuthEndpoints];
  };
    void (^testSharingEndpoints)(void) = ^{
    [self testSharingEndpoints:testUsersEndpoints];
  };
    void (^testFilesEndpoints)(void) = ^{
    [self testFilesEndpoints:testSharingEndpoints asMember:asMember];
  };
    void (^start)(void) = ^{
    testFilesEndpoints();
  };
  
  start();
}

- (void)testAuthEndpoints:(void (^)(void))nextTest {
  AuthTests *authTests = [[AuthTests alloc] init:self];
  
    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
    void (^tokenFromOauth1)(void) = ^{
    [authTests tokenFromOauth1:end];
  };
    void (^tokenRevoke)(void) = ^{
    [authTests tokenRevoke:tokenFromOauth1];
  };
    void (^start)(void) = ^{
    tokenRevoke();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testFilesEndpoints:(void (^)(void))nextTest asMember:(BOOL)asMember {
  FilesTests *filesTests = [[FilesTests alloc] init:self];
  
    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
    void (^listFolderLongpollAndTrigger)(void) = ^{
    [filesTests listFolderLongpollAndTrigger:end];
  };
    void (^uploadStream)(void) = ^{
    [filesTests uploadStream:listFolderLongpollAndTrigger];
  };
    void (^uploadFile)(void) = ^{
    [filesTests uploadFile:uploadStream];
  };
    void (^downloadToMemoryWithRange)(void) = ^{
    [filesTests downloadToMemoryWithRange:uploadFile];
  };
    void (^downloadToMemory)(void) = ^{
    [filesTests downloadToMemory:downloadToMemoryWithRange];
  };
    void (^downloadToFileAgain)(void) = ^{
    [filesTests downloadToFileAgain:downloadToMemory];
  };
    void (^downloadToFile)(void) = ^{
    [filesTests downloadToFile:downloadToFileAgain];
  };
    void (^saveUrl)(void) = ^{
    [filesTests saveUrl:downloadToFile asMember:asMember];
  };
    void (^move)(void) = ^{
    [filesTests moveV2:saveUrl];
  };
    void (^listRevisions)(void) = ^{
    [filesTests listRevisions:move];
  };
    void (^getTemporaryLink)(void) = ^{
    [filesTests getTemporaryLink:listRevisions];
  };
    void (^getMetadataError)(void) = ^{
    [filesTests getMetadataError:getTemporaryLink];
  };
    void (^getMetadata)(void) = ^{
    [filesTests getMetadata:getMetadataError];
  };
    void (^dCopyReferenceGet)(void) = ^{
    [filesTests dCopyReferenceGet:getMetadata];
  };
    void (^dCopy)(void) = ^{
    [filesTests dCopyV2:dCopyReferenceGet];
  };
    void (^uploadDataSession)(void) = ^{
    [filesTests uploadDataSession:dCopy];
  };
    void (^uploadData)(void) = ^{
    [filesTests uploadData:uploadDataSession];
  };
    void (^listFolder)(void) = ^{
    [filesTests listFolder:uploadData];
  };
    void (^listFolderError)(void) = ^{
    [filesTests listFolderError:listFolder];
  };
    void (^createFolder)(void) = ^{
    [filesTests createFolderV2:listFolderError];
  };
    void (^delete_)(void) = ^{
    [filesTests deleteV2:createFolder];
  };
    void (^start)(void) = ^{
    delete_();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testSharingEndpoints:(void (^)(void))nextTest {
  SharingTests *sharingTests = [[SharingTests alloc] init:self];
  
    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
    void (^unshareFolder)(void) = ^{
    [sharingTests updateFolderPolicy:end];
  };
    void (^updateFolderPolicy)(void) = ^{
    [sharingTests updateFolderPolicy:unshareFolder];
  };
    void (^mountFolder)(void) = ^{
    [sharingTests mountFolder:updateFolderPolicy];
  };
    void (^unmountFolder)(void) = ^{
    [sharingTests unmountFolder:mountFolder];
  };
    void (^revokeSharedLink)(void) = ^{
    [sharingTests revokeSharedLink:unmountFolder];
  };
    void (^removeFolderMember)(void) = ^{
    [sharingTests removeFolderMember:revokeSharedLink];
  };
    void (^listSharedLinks)(void) = ^{
    [sharingTests listSharedLinks:removeFolderMember];
  };
    void (^listFolders)(void) = ^{
    [sharingTests listFolders:listSharedLinks];
  };
    void (^listFolderMembers)(void) = ^{
    [sharingTests listFolderMembers:listFolders];
  };
    void (^addFolderMember)(void) = ^{
    [sharingTests addFolderMember:listFolderMembers];
  };
    void (^getFolderMetadata)(void) = ^{
    [sharingTests getFolderMetadata:addFolderMember];
  };
    void (^createSharedLinkWithSettings)(void) = ^{
    [sharingTests createSharedLinkWithSettings:getFolderMetadata];
  };
    void (^shareFolder)(void) = ^{
    [sharingTests shareFolder:createSharedLinkWithSettings];
  };
    void (^start)(void) = ^{
    shareFolder();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testUsersEndpoints:(void (^)(void))nextTest {
  UsersTests *usersTests = [[UsersTests alloc] init:self];
  
    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
    void (^getSpaceUsage)(void) = ^{
    [usersTests getSpaceUsage:end];
  };
    void (^getCurrentAccount)(void) = ^{
    [usersTests getCurrentAccount:getSpaceUsage];
  };
    void (^getAccountBatch)(void) = ^{
    [usersTests getAccountBatch:getCurrentAccount];
  };
    void (^getAccount)(void) = ^{
    [usersTests getAccount:getAccountBatch];
  };
    void (^start)(void) = ^{
    getAccount();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

@end

@implementation DropboxTeamTester

- (instancetype)initWithTestData:(TestData *)testData {
  self = [super init];
  if (self) {
    NSAssert([DBClientsManager authorizedTeamClient], @"No authorized team client.");

    _testData = testData;
    _team = [DBClientsManager authorizedTeamClient].teamRoutes;
  }
  return self;
}

// Test business app with 'Team member file access' permission
- (void)testAllTeamMemberFileAcessActions:(void (^)(void))nextTest {
    void (^end)(void) = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testPerformActionAsMember)(TeamTests *) = ^(TeamTests *teamTests) {
    [teamTests initMembersGetInfo:^{}];
      DropboxTester *tester = [[DropboxTester alloc] initWithTestData:self->_testData];
    [tester testAllUserAPIEndpoints:end asMember:YES];
  };
    void (^testTeamMemberFileAcessActions)(void) = ^{
    [self testTeamMemberFileAcessActions:testPerformActionAsMember];
  };
    void (^start)(void) = ^{
    testTeamMemberFileAcessActions();
  };
  
  start();
}

// Test business app with 'Team member management' permission
- (void)testAllTeamMemberManagementActions:(void (^)(void))nextTest {
    void (^end)(void) = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
    void (^testTeamMemberManagementActions)(void) = ^{
    [self testTeamMemberManagementActions:end];
  };
    void (^start)(void) = ^{
    testTeamMemberManagementActions();
  };
  
  start();
}

- (void)testTeamMemberFileAcessActions:(void (^)(TeamTests *))nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:self];

    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest(teamTests);
  };
    void (^reportsGetStorage)(void) = ^{
    [teamTests reportsGetStorage:end];
  };
    void (^reportsGetMembership)(void) = ^{
    [teamTests reportsGetMembership:reportsGetStorage];
  };
    void (^reportsGetDevices)(void) = ^{
    [teamTests reportsGetDevices:reportsGetMembership];
  };
    void (^reportsGetActivity)(void) = ^{
    [teamTests reportsGetActivity:reportsGetDevices];
  };
    void (^getInfo)(void) = ^{
    [teamTests getInfo:reportsGetActivity];
  };
    void (^linkedAppsListMembersLinkedApps)(void) = ^{
    [teamTests linkedAppsListMembersLinkedApps:getInfo];
  };
    void (^linkedAppsListMemberLinkedApps)(void) = ^{
    [teamTests linkedAppsListMemberLinkedApps:linkedAppsListMembersLinkedApps];
  };
    void (^listMembersDevices)(void) = ^{
    [teamTests listMembersDevices:linkedAppsListMemberLinkedApps];
  };
    void (^listMemberDevices)(void) = ^{
    [teamTests listMemberDevices:listMembersDevices];
  };
    void (^initMembersGetInfo)(void) = ^{
    [teamTests initMembersGetInfo:listMemberDevices];
  };
    void (^start)(void) = ^{
    initMembersGetInfo();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testTeamMemberManagementActions:(void (^)(void))nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:self];
  
    void (^end)(void) = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
    void (^membersRemove)(void) = ^{
    [teamTests membersRemove:end];
  };
    void (^membersSetProfile)(void) = ^{
    [teamTests membersSetProfile:membersRemove];
  };
    void (^membersSetAdminPermissions)(void) = ^{
    [teamTests membersSetAdminPermissions:membersSetProfile];
  };
    void (^membersSendWelcomeEmail)(void) = ^{
    [teamTests membersSendWelcomeEmail:membersSetAdminPermissions];
  };
    void (^membersList)(void) = ^{
    [teamTests membersList:membersSendWelcomeEmail];
  };
    void (^membersGetInfo)(void) = ^{
    [teamTests membersGetInfo:membersList];
  };
    void (^membersAdd)(void) = ^{
    [teamTests membersAdd:membersGetInfo];
  };
    void (^groupsDelete)(void) = ^{
    [teamTests groupsDelete:membersAdd];
  };
    void (^groupsUpdate)(void) = ^{
    [teamTests groupsUpdate:groupsDelete];
  };
    void (^groupsMembersList)(void) = ^{
    [teamTests groupsMembersList:groupsUpdate];
  };
    void (^groupsMembersAdd)(void) = ^{
    [teamTests groupsMembersAdd:groupsMembersList];
  };
    void (^groupsList)(void) = ^{
    [teamTests groupsList:groupsMembersAdd];
  };
    void (^groupsGetInfo)(void) = ^{
    [teamTests groupsGetInfo:groupsList];
  };
    void (^groupsCreate)(void) = ^{
    [teamTests groupsCreate:groupsGetInfo];
  };
    void (^initMembersGetInfo)(void) = ^{
    [teamTests initMembersGetInfo:groupsCreate];
  };
    void (^start)(void) = ^{
    initMembersGetInfo();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

@end

/**
 Custom Tests
 */

@implementation BatchUploadTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

- (void)batchUploadFiles {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  // create working folder
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSString *workingDirectoryName = @"MyOutputFolder";
  NSURL *workingDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0]
                       URLByAppendingPathComponent:workingDirectoryName];
  
  [fileManager createDirectoryAtPath:[workingDirectory path]
         withIntermediateDirectories:YES
                          attributes:nil
                               error:nil];
  
  NSMutableDictionary<NSURL *, DBFILESCommitInfo *> *uploadFilesUrlsToCommitInfo = [NSMutableDictionary new];

  NSLog(@"\n\nCreating files in: %@\n\n", [workingDirectory path]);
  // create a bunch of fake files
  for (int i = 0; i < 150; i++) {
    NSString *fileName = [NSString stringWithFormat:@"test_file_%d", i];
    NSString *fileContent = [NSString stringWithFormat:@"%@'s content. Test content here.", fileName];
    NSURL *fileUrl = [workingDirectory URLByAppendingPathComponent:fileName];

    // set to test large file
    BOOL testLargeFile = YES;

    // don't create a file for the name test_file_5 so we use a custom large file
    // there instead
    if (i != 5 || !testLargeFile) {
      NSError *fileCreationError;
      [fileContent writeToFile:[fileUrl path]
                    atomically:NO
                      encoding:NSStringEncodingConversionAllowLossy
                         error:&fileCreationError];
      
      if (fileCreationError) {
        NSLog(@"Error creating file: %@", fileCreationError);
        NSLog(@"Terminating...");
        exit(0);
      }
    } else {
      if (![fileManager fileExistsAtPath:[fileUrl path]]) {
        NSLog(@"\n\nPlease create a large file named %@ to test chunked uploading\n\n", [fileUrl lastPathComponent]);
        exit(0);
      }
    }
    
    DBFILESCommitInfo *commitInfo =
      [[DBFILESCommitInfo alloc] initWithPath:[NSString stringWithFormat:@"%@/%@", _tester.testData.testFolderPath, fileName]];
    
    [uploadFilesUrlsToCommitInfo setObject:commitInfo forKey:fileUrl];
  }

  [_tester.files batchUploadFiles:uploadFilesUrlsToCommitInfo queue:nil progressBlock:^(int64_t uploaded,
                                                                                        int64_t uploadedTotal,
                                                                                        int64_t expectedToUploadTotal) {
    NSLog(@"Uploaded: %lld  UploadedTotal: %lld  ExpectedToUploadTotal: %lld", uploaded, uploadedTotal, expectedToUploadTotal);
  } responseBlock:^(NSDictionary<NSURL *,DBFILESUploadSessionFinishBatchResultEntry *> *fileUrlsToBatchResultEntries,
                    DBASYNCPollError *finishBatchRouteError, DBRequestError *finishBatchRequestError,
                    NSDictionary<NSURL *,DBRequestError *> *fileUrlsToRequestErrors) {
    if (fileUrlsToBatchResultEntries) {
      for (NSURL *clientSideFileUrl in fileUrlsToBatchResultEntries) {
        DBFILESUploadSessionFinishBatchResultEntry *resultEntry = fileUrlsToBatchResultEntries[clientSideFileUrl];
        if ([resultEntry isSuccess]) {
          NSString *dropboxFilePath = resultEntry.success.pathDisplay;
          NSLog(@"File successfully uploaded from %@ on local machine to %@ in Dropbox.",
                [clientSideFileUrl absoluteString], dropboxFilePath);
        } else if ([resultEntry isFailure]) {
          // This particular file was not uploaded successfully, although the other
          // files may have been uploaded successfully. Perhaps implement some retry
          // logic here based on `uploadError`
          DBRequestError *uploadNetworkError = fileUrlsToRequestErrors[clientSideFileUrl];
          DBFILESUploadSessionFinishError *uploadSessionFinishError = resultEntry.failure;

          NSLog(@"%@\n", uploadNetworkError);
          NSLog(@"%@\n", uploadSessionFinishError);
        }
      }
    }

    if (finishBatchRouteError) {
      NSLog(@"Either bug in SDK code, or transient error on Dropbox server: %@", finishBatchRouteError);
    } else if (finishBatchRequestError) {
      NSLog(@"Request error from calling `/upload_session/finish_batch/check`");
      NSLog(@"%@", finishBatchRequestError);
    } else if ([fileUrlsToRequestErrors count] > 0) {
      NSLog(@"Other additional errors (e.g. file doesn't exist client-side, etc.).");
      NSLog(@"%@", fileUrlsToRequestErrors);
    }
  }];
}

@end

@implementation GlobalResponseTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

- (void)runGlobalResponseTests {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^listFolderGlobalResponseBlock)(DBFILESListFolderError *, DBRequestError *, DBTask *) = ^(DBFILESListFolderError *folderError, DBRequestError *networkError, DBTask *restartTask) {
#pragma unused(networkError)
#pragma unused(restartTask)
    MyLog(@"\n\nListFolder: listFolderGlobalResponseBlock Global execution error:%@\n\n", folderError);
  };

  void (^lookupErrorGlobalResponseBlock)(DBFILESLookupError *, DBRequestError *, DBTask *) = ^(DBFILESLookupError *lookupError, DBRequestError *networkError, DBTask *restartTask) {
#pragma unused(networkError)
#pragma unused(restartTask)
    MyLog(@"\n\nLookupError: lookupErrorGlobalResponseBlock Global execution error:%@\n\n", lookupError);
  };

  void (^downloadDataGlobalResponseBlock)(DBFILESDownloadError *, DBRequestError *, DBTask *) = ^(DBFILESDownloadError *downloadError, DBRequestError *networkError, DBTask *restartTask) {
#pragma unused(downloadError)
#pragma unused(networkError)
#pragma unused(restartTask)
    MyLog(@"\n\nDownloadData: downloadDataGlobalResponseBlock Global execution error\n\n");
  };

  void (^networkGlobalResponseBlock)(DBRequestError *, DBTask *) = ^(DBRequestError *networkError, DBTask *restartTask) {
#pragma unused(restartTask)
    MyLog(@"\n\n NetworkData: networkGlobalResponseBlock Global execution error:%@\n\n", networkError);

    if ([networkError isAuthError]) {
      [TestFormat printOffset:@"Auth error detected!"];
    }
  };

  [DBGlobalErrorResponseHandler registerRouteErrorResponseBlock:listFolderGlobalResponseBlock routeErrorType:[DBFILESListFolderError class]];
  [DBGlobalErrorResponseHandler registerRouteErrorResponseBlock:lookupErrorGlobalResponseBlock routeErrorType:[DBFILESLookupError class]];
  [DBGlobalErrorResponseHandler registerRouteErrorResponseBlock:downloadDataGlobalResponseBlock routeErrorType:[DBFILESDownloadError class]];

  [DBGlobalErrorResponseHandler registerNetworkErrorResponseBlock:networkGlobalResponseBlock];

  [TestFormat printOffset:@"Registered handlers for listfoldererror, lookuperror, downloaderror, and network errors"];
  dispatch_semaphore_t continueSemaphore = dispatch_semaphore_create(0);

  [[_tester.files listFolder:@""]
    setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
      if (!result) {
        [TestFormat abort:error routeError:routeError];
      }
      [TestFormat printOffset:@"listFolder Call finished with no error."];
      dispatch_semaphore_signal(continueSemaphore);
    } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [[_tester.files listFolder:@"/does/not/exist"]
    setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
      if (result) {
        [TestFormat abort:error routeError:routeError];
      }
      [TestFormat printOffset:@"listFolder Call finished with error."];
      dispatch_semaphore_signal(continueSemaphore);
    } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [TestFormat printOffset:@"Removing listfoldererror listener"];
  [DBGlobalErrorResponseHandler removeRouteErrorResponseBlockWithRouteErrorType:[DBFILESListFolderError class]];

  [[_tester.files listFolder:@"/does/not/exist"]
   setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
     if (result) {
       [TestFormat abort:error routeError:routeError];
     }
     [TestFormat printOffset:@"listFolder Call finished with error after removal of DBFILESListFolderError global callback."];
     dispatch_semaphore_signal(continueSemaphore);
   } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [[_tester.files downloadData:@"/does/not/exist"] setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileData) {
      if (result) {
        [TestFormat abort:error routeError:routeError];
      }
    [TestFormat printOffset:@"downloadData Call with route error."];
      dispatch_semaphore_signal(continueSemaphore);
  } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [TestFormat printOffset:@"Calling listfolder with auth error."];
  [[_tester.files listFolder:@"/does/not/exist"] setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *networkError) {
    if (result) {
      [TestFormat abort:networkError routeError:routeError];
    }
    [TestFormat printOffset:@"Call with auth network error."];
    dispatch_semaphore_signal(continueSemaphore);
  } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [TestFormat printOffset:@"Removing network error listener"];
  [DBGlobalErrorResponseHandler registerNetworkErrorResponseBlock:networkGlobalResponseBlock];

  [[_tester.auth tokenRevoke] setResponseBlock:^(DBNilObject * _Nullable result, DBNilObject * _Nullable routeError, DBRequestError * _Nullable networkError) {
    [TestFormat printOffset:@"Token revoked."];
    dispatch_semaphore_signal(continueSemaphore);
  } queue:[NSOperationQueue new]];

  dispatch_semaphore_wait(continueSemaphore, DISPATCH_TIME_FOREVER);

  [TestFormat printOffset:@"Calling listfolder with auth error."];
  [[_tester.files listFolder:@"/does/not/exist"] setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *networkError) {
    if (result) {
      [TestFormat abort:networkError routeError:routeError];
    }
    [TestFormat printOffset:@"Call with auth network error after removal of global callback."];
    dispatch_semaphore_signal(continueSemaphore);
  } queue:[NSOperationQueue new]];

  [DBClientsManager unlinkAndResetClients];
}

@end

/**
    Dropbox User API Endpoint Tests
 */

@implementation AuthTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

- (void)tokenRevoke:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.auth tokenRevoke] setResponseBlock:^(DBNilObject *result, DBNilObject *routeError, DBRequestError *error) {
    MyLog(@"%@\n", result);
    [TestFormat printOffset:@"Token successfully revoked"];
    [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
    nextTest();
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)tokenFromOauth1:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.appAuth tokenFromOauth1:_tester.testData.oauth1Token oauth1TokenSecret:_tester.testData.oauth1TokenSecret]
    setResponseBlock:^(DBAUTHTokenFromOAuth1Result *result, DBAUTHTokenFromOAuth1Error *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [[DBOAuthManager sharedOAuthManager] storeAccessToken:[[DBAccessToken alloc] initWithAccessToken:result.oauth2Token uid:@"123"]];
      [DBClientsManager authorizeClientFromKeychain:@"123"];
      [[[DBClientsManager authorizedClient].filesRoutes listFolder:@""]
       setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }];
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

@end

@implementation FilesTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

- (void)deleteV2:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
    [[[_tester.files delete_V2:_tester.testData.baseFolder]
      setResponseBlock:^(DBFILESDeleteResult * _Nullable result, DBFILESDeleteError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat printErrors:networkError routeError:routeError];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)createFolderV2:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files createFolderV2:_tester.testData.testFolderPath]
    setResponseBlock:^(DBFILESCreateFolderResult * _Nullable result, DBFILESCreateFolderError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:networkError routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderError:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listFolder:@"/does/not/exist/folder"]
      setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"Something went wrong...\n");
          [TestFormat abort:error routeError:routeError];
        } else {
          [TestFormat printOffset:@"Intentionally errored.\n"];
          [TestFormat printErrors:error routeError:routeError];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolder:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listFolder:_tester.testData.testFolderPath]
      setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadData:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = _tester.testData.testFilePath;
  [[[_tester.files uploadData:outputPath inputData:_tester.testData.fileData]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadDataSession:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^uploadSessionAppendV2)(NSString *, DBFILESUploadSessionCursor *) = ^(NSString *sessionId,
                                                                              DBFILESUploadSessionCursor *cursor) {
      [[[self->_tester.files uploadSessionAppendV2Data:cursor inputData:self->_tester.testData.fileData]
        setResponseBlock:^(DBNilObject *result, DBFILESUploadSessionLookupError *routeError, DBRequestError *error) {
          // response type for this route is nil
          if (!error) {
            DBFILESUploadSessionCursor *cursor = [[DBFILESUploadSessionCursor alloc]
                initWithSessionId:sessionId
                                                  offset:[NSNumber numberWithUnsignedLong:(self->_tester.testData.fileData.length * 2)]];
            DBFILESCommitInfo *commitInfo = [[DBFILESCommitInfo alloc]
                                             initWithPath:[NSString stringWithFormat:@"%@%@", self->_tester.testData.testFilePath, @"_session"]];

              [[[self->_tester.files uploadSessionFinishData:cursor commit:commitInfo inputData:self->_tester.testData.fileData]
                setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadSessionFinishError *routeError, DBRequestError *error) {
                  if (result) {
                    MyLog(@"%@\n", result);
                    [TestFormat printOffset:@"Upload session complete"];
                    [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
                    nextTest();
                  } else {
                    [TestFormat abort:error routeError:routeError];
                  }
                } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
              [TestFormat printSentProgress:bytesSent
                             totalBytesSent:totalBytesSent
                   totalBytesExpectedToSend:totalBytesExpectedToSend];
            }];
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  [[[_tester.files uploadSessionStartData:_tester.testData.fileData]
      setResponseBlock:^(DBFILESUploadSessionStartResult *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printOffset:@"Acquiring sessionId"];
          uploadSessionAppendV2(
              result.sessionId,
              [[DBFILESUploadSessionCursor alloc]
                  initWithSessionId:result.sessionId
               offset:[NSNumber numberWithUnsignedLong:(self->_tester.testData.fileData.length)]]);
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)dCopyV2:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *copyOutputPath = [NSString
      stringWithFormat:@"%@%@%@%@", _tester.testData.testFilePath, @"_duplicate", @"_", _tester.testData.testId];
  [[[_tester.files dCopyV2:_tester.testData.testFilePath toPath:copyOutputPath]
    setResponseBlock:^(DBFILESRelocationResult * _Nullable result, DBFILESRelocationError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:networkError routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)dCopyReferenceGet:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files dCopyReferenceGet:_tester.testData.testFilePath]
      setResponseBlock:^(DBFILESGetCopyReferenceResult *result, DBFILESGetCopyReferenceError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getMetadata:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getMetadata:_tester.testData.testFilePath]
      setResponseBlock:^(DBFILESMetadata *result, DBFILESGetMetadataError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getMetadataError:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getMetadata:@"/this/path/does/not/exist"]
      setResponseBlock:^(DBFILESMetadata *result, DBFILESGetMetadataError *routeError, DBRequestError *error) {
        if (result) {
          NSAssert(NO, @"This call should have errored.");
        } else {
          NSAssert(error, @"This call should have errored.");
          [TestFormat printOffset:@"Error properly detected"];
          MyLog(@"%@\n", error);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getTemporaryLink:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getTemporaryLink:_tester.testData.testFilePath]
      setResponseBlock:^(DBFILESGetTemporaryLinkResult *result, DBFILESGetTemporaryLinkError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listRevisions:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listRevisions:_tester.testData.testFilePath]
      setResponseBlock:^(DBFILESListRevisionsResult *result, DBFILESListRevisionsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)moveV2:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *folderPath = [NSString stringWithFormat:@"%@%@%@", _tester.testData.testFolderPath, @"/", @"movedLocation"];
  [[[_tester.files createFolderV2:folderPath]
    setResponseBlock:^(DBFILESCreateFolderResult * _Nullable result, DBFILESCreateFolderError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printOffset:@"Created destination folder"];

            NSString *fileToMove = [NSString stringWithFormat:@"%@%@", self->_tester.testData.testFilePath, @"_session"];
          NSString *destPath =
            [NSString stringWithFormat:@"%@%@%@%@", folderPath, @"/", self->_tester.testData.testFileName, @"_session"];

            [[[self->_tester.files moveV2:fileToMove toPath:destPath]
            setResponseBlock:^(DBFILESRelocationResult * _Nullable result, DBFILESRelocationError * _Nullable routeError, DBRequestError * _Nullable networkError) {
                if (result) {
                  MyLog(@"%@\n", result);
                  [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
                  nextTest();
                } else {
                  [TestFormat abort:networkError routeError:routeError];
                }
              } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            [TestFormat printSentProgress:bytesSent
                           totalBytesSent:totalBytesSent
                 totalBytesExpectedToSend:totalBytesExpectedToSend];
          }];
        } else {
          [TestFormat abort:networkError routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)saveUrl:(void (^)(void))nextTest asMember:(BOOL)asMember {
  if (asMember) {
    nextTest();
    return;
  }
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *folderPath = [NSString stringWithFormat:@"%@%@%@", _tester.testData.testFolderPath, @"/", @"dbx-test.html"];
  [[[_tester.files saveUrl:folderPath url:@"https://www.google.com"]
      setResponseBlock:^(DBFILESSaveUrlResult *result, DBFILESSaveUrlError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFile:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadUrl:_tester.testData.testFilePath overwrite:YES destination:_tester.testData.destURL]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
        if (result) {
          MyLog(@"%@\n", result);
          NSData *data = [[NSFileManager defaultManager] contentsAtPath:[destination path]];
          NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          [TestFormat printOffset:@"File contents:"];
          MyLog(@"%@\n", dataStr);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFileAgain:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadUrl:_tester.testData.testFilePath overwrite:YES destination:_tester.testData.destURL]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
        if (result) {
          MyLog(@"%@\n", result);
          NSData *data = [[NSFileManager defaultManager] contentsAtPath:[destination path]];
          NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          [TestFormat printOffset:@"File contents:"];
          MyLog(@"%@\n", dataStr);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFileError:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *filePath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_does_not_exist"];
  [[[_tester.files downloadUrl:filePath overwrite:YES destination:_tester.testData.destURL]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
        if (result) {
          NSAssert(NO, @"This call should have errored!");
        } else {
            NSAssert(![[NSFileManager defaultManager] fileExistsAtPath:[self->_tester.testData.destURLException path]],
                   @"File should not exist here.");
          [TestFormat printOffset:@"Error properly detected"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToMemory:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadData:_tester.testData.testFilePath]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileContents) {
        if (result) {
          MyLog(@"%@\n", result);
          NSString *dataStr = [[NSString alloc] initWithData:fileContents encoding:NSUTF8StringEncoding];
          [TestFormat printOffset:@"File contents:"];
          MyLog(@"%@\n", dataStr);
          NSUInteger len = [fileContents length];
          MyLog(@"\nFile size: %lld\n", (long)len);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToMemoryWithRange:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadData:_tester.testData.testFilePath byteOffsetStart:@(0) byteOffsetEnd:@(10)]
    setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileContents) {
      if (result) {
        MyLog(@"%@\n", result);
        [TestFormat printOffset:@"Number of bytes (expecting 11)"];
        NSUInteger len = [fileContents length];
        MyLog(@"\nFile size: %lld\n", (long)len);
        if (len != 11) {
          [TestFormat abort:error routeError:routeError];
        }
        [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
        nextTest();
      } else {
        [TestFormat abort:error routeError:routeError];
      }
    } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
}

- (void)uploadFile:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_from_file"];
  [[[_tester.files uploadUrl:outputPath inputUrl:[_tester.testData.destURL path]]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadStream:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_from_stream"];
  [[[_tester.files uploadStream:outputPath inputStream:[[NSInputStream alloc] initWithURL:_tester.testData.destURL]]
      setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderLongpollAndTrigger:(void (^)(void))nextTest {
    void (^copy)(void) = ^{
    [TestFormat printOffset:@"Making change that longpoll will detect (copy file)"];
    NSString *copyOutputPath =
        [NSString stringWithFormat:@"%@%@%@", self->_tester.testData.testFilePath, @"_duplicate2_", self->_tester.testData.testId];

        [[[self->_tester.files dCopyV2:self->_tester.testData.testFilePath toPath:copyOutputPath]
      setResponseBlock:^(DBFILESRelocationResult * _Nullable result, DBFILESRelocationError * _Nullable routeError, DBRequestError * _Nullable networkError) {
          if (result) {
            MyLog(@"%@\n", result);
          } else {
            [TestFormat abort:networkError routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  void (^listFolderContinue)(NSString *) = ^(NSString *cursor) {
      [[[self->_tester.files listFolderContinue:cursor]
        setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderContinueError *routeError, DBRequestError *error) {
          if (result) {
            [TestFormat printOffset:@"Here are the changes:"];
            MyLog(@"%@\n", result);
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  void (^listFolderLongpoll)(NSString *) = ^(NSString *cursor) {
    [TestFormat printOffset:@"Establishing longpoll"];
      [[[self->_tester.files listFolderLongpoll:cursor] setResponseBlock:^(DBFILESListFolderLongpollResult *result,
                                                           DBFILESListFolderLongpollError *routeError, DBRequestError *error) {
      if (result) {
        MyLog(@"%@\n", result);
        if (result.changes) {
          [TestFormat printOffset:@"Changes found"];
          listFolderContinue(cursor);
        } else {
          [TestFormat printOffset:@"Improperly set up changes trigger"];
        }
      } else {
        [TestFormat abort:error routeError:routeError];
      }
    } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];

    copy();
  };

  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  [TestFormat printOffset:@"Acquring cursor"];
  [[[_tester.files listFolderGetLatestCursor:_tester.testData.testFolderPath]
      setResponseBlock:^(DBFILESListFolderGetLatestCursorResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          [TestFormat printOffset:@"Cursor acquired"];
          MyLog(@"%@\n", result);
          listFolderLongpoll(result.cursor);
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

@end

@implementation SharingTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
    _sharedFolderId = @"placeholder";
    _sharedLink = @"placeholder";
  }
  return self;
}

- (void)shareFolder:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing shareFolder:_tester.testData.testShareFolderPath]
      setResponseBlock:^(DBSHARINGShareFolderLaunch *result, DBSHARINGShareFolderError *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat
                printOffset:[NSString stringWithFormat:@"Folder not yet shared! Job id: %@. Please adjust test order.",
                                                       result.asyncJobId]];
          } else if ([result isComplete]) {
            MyLog(@"%@\n", result.complete);
              self->_sharedFolderId = result.complete.sharedFolderId;
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          } else {
            [TestFormat printOffset:@"Improperly handled share folder result"];
            [TestFormat abort:error routeError:routeError];
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)createSharedLinkWithSettings:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing createSharedLinkWithSettings:_tester.testData.testShareFolderPath]
      setResponseBlock:^(DBSHARINGSharedLinkMetadata *result, DBSHARINGCreateSharedLinkWithSettingsError *routeError,
                 DBRequestError *error) {
        if (result || [routeError isSharedLinkAlreadyExists]) {
          if ([routeError isSharedLinkAlreadyExists]) {
          }
          MyLog(@"%@\n", result);
            self->_sharedLink = result.url;
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getFolderMetadata:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing getFolderMetadata:_sharedFolderId]
      setResponseBlock:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGSharedFolderAccessError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)addFolderMember:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBSHARINGMemberSelector *memberSelector =
      [[DBSHARINGMemberSelector alloc] initWithEmail:_tester.testData.accountId3Email];
  DBSHARINGAddMember *addFolderMemberArg = [[DBSHARINGAddMember alloc] initWithMember:memberSelector];
  [[[_tester.sharing addFolderMember:_sharedFolderId
                             members:@[ addFolderMemberArg ]
                               quiet:[NSNumber numberWithBool:YES]
                       customMessage:nil]
      setResponseBlock:^(DBNilObject *result, DBSHARINGAddFolderMemberError *routeError, DBRequestError *error) {
        if (!error) {
          [TestFormat printOffset:@"Folder member added"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderMembers:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listFolderMembers:_sharedFolderId]
      setResponseBlock:^(DBSHARINGSharedFolderMembers *result, DBSHARINGSharedFolderAccessError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolders:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listFolders:[NSNumber numberWithInteger:2] actions:nil]
      setResponseBlock:^(DBSHARINGListFoldersResult *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listSharedLinks:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listSharedLinks]
      setResponseBlock:^(DBSHARINGListSharedLinksResult *result, DBSHARINGListSharedLinksError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)removeFolderMember:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBSHARINGMemberSelector *memberSelector =
      [[DBSHARINGMemberSelector alloc] initWithDropboxId:_tester.testData.accountId3];

  void (^checkJobStatus)(NSString *) = ^(NSString *asyncJobId) {
      [[[self->_tester.sharing checkJobStatus:asyncJobId] setResponseBlock:^(DBSHARINGJobStatus *result, DBASYNCPollError *routeError,
                                                             DBRequestError *error) {
      if (result) {
        MyLog(@"%@\n", result);
        if ([result isInProgress]) {
          [TestFormat
              printOffset:[NSString
                              stringWithFormat:@"Folder member not yet removed! Job id: %@. Please adjust test order.",
                                               asyncJobId]];
        } else if ([result isComplete]) {
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else if ([result isFailed]) {
          [TestFormat abort:error routeError:result.failed];
        }
      } else {
        [TestFormat abort:error routeError:routeError];
      }
    } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  [[[_tester.sharing removeFolderMember:_sharedFolderId member:memberSelector leaveACopy:[NSNumber numberWithBool:NO]]
      setResponseBlock:^(DBASYNCLaunchResultBase *result, DBSHARINGRemoveFolderMemberError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          if ([result isAsyncJobId]) {
            [TestFormat printOffset:[NSString stringWithFormat:@"Folder member not yet removed! Job id: %@",
                                                               result.asyncJobId]];
            MyLog(@"Sleeping for 3 seconds, then trying again");
            for (int i = 0; i < 3; i++) {
              sleep(1);
              MyLog(@".");
            }
            MyLog(@"\n");
            [TestFormat printOffset:@"Retrying!"];
            checkJobStatus(result.asyncJobId);
          } else {
            [TestFormat printOffset:[NSString stringWithFormat:@"removeFolderMember result not properly handled."]];
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)revokeSharedLink:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing revokeSharedLink:_sharedLink]
      setResponseBlock:^(DBNilObject *result, DBSHARINGRevokeSharedLinkError *routeError, DBRequestError *error) {
        if (!routeError) {
          [TestFormat printOffset:@"Shared link revoked"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)unmountFolder:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing unmountFolder:_sharedFolderId]
      setResponseBlock:^(DBNilObject *result, DBSHARINGUnmountFolderError *routeError, DBRequestError *error) {
        if (!routeError) {
          [TestFormat printOffset:@"Folder unmounted"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)mountFolder:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing mountFolder:_sharedFolderId]
      setResponseBlock:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGMountFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)updateFolderPolicy:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing updateFolderPolicy:_sharedFolderId]
      setResponseBlock:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGUpdateFolderPolicyError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)unshareFolder:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing unshareFolder:_sharedFolderId]
      setResponseBlock:^(DBASYNCLaunchEmptyResult *result, DBSHARINGUnshareFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

@end

@implementation UsersTests

- (instancetype)init:(DropboxTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

- (void)getAccount:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getAccount:_tester.testData.accountId]
      setResponseBlock:^(DBUSERSBasicAccount *result, DBUSERSGetAccountError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getAccountBatch:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSArray<NSString *> *accountIds = @[ _tester.testData.accountId, _tester.testData.accountId2 ];
  [[[_tester.users getAccountBatch:accountIds]
      setResponseBlock:^(NSArray<DBUSERSBasicAccount *> *result, DBUSERSGetAccountBatchError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getCurrentAccount:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getCurrentAccount] setResponseBlock:^(DBUSERSFullAccount *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getSpaceUsage:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getSpaceUsage] setResponseBlock:^(DBUSERSSpaceUsage *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

@end

/**
    Dropbox TEAM API Endpoint Tests
 */

@implementation TeamTests

- (instancetype)init:(DropboxTeamTester *)tester {
  self = [super init];
  if (self) {
    _tester = tester;
  }
  return self;
}

/**
    Permission: TEAM member file access
 */

- (void)initMembersGetInfo:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithEmail:_tester.testData.teamMemberEmail];
  [[[_tester.team membersGetInfo:@[ userSelectArg ]] setResponseBlock:^(NSArray<DBTEAMMembersGetInfoItem *> *result,
                                                                DBTEAMMembersGetInfoError *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      DBTEAMMembersGetInfoItem *getInfo = result[0];
      if ([getInfo isIdNotFound]) {
        [TestFormat abort:error routeError:routeError];
      } else if ([getInfo isMemberInfo]) {
          self->_teamMemberId = getInfo.memberInfo.profile.teamMemberId;
          s_teamAdminUserClient = [[DBClientsManager authorizedTeamClient] userClientWithMemberId:self->_teamMemberId];
      }
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listMemberDevices:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team devicesListMemberDevices:_teamMemberId]
      setResponseBlock:^(DBTEAMListMemberDevicesResult *result, DBTEAMListMemberDevicesError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listMembersDevices:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team devicesListMembersDevices]
      setResponseBlock:^(DBTEAMListMembersDevicesResult *result, DBTEAMListMembersDevicesError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)linkedAppsListMemberLinkedApps:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team linkedAppsListMemberLinkedApps:_teamMemberId]
      setResponseBlock:^(DBTEAMListMemberAppsResult *result, DBTEAMListMemberAppsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)linkedAppsListMembersLinkedApps:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team linkedAppsListMembersLinkedApps]
      setResponseBlock:^(DBTEAMListMembersAppsResult *result, DBTEAMListMembersAppsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getInfo:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team getInfo] setResponseBlock:^(DBTEAMTeamGetInfoResult *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetActivity:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetActivity:twoDaysAgo endDate:[NSDate new]]
      setResponseBlock:^(DBTEAMGetActivityReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetDevices:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetDevices:twoDaysAgo endDate:[NSDate new]]
      setResponseBlock:^(DBTEAMGetDevicesReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetMembership:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetMembership:twoDaysAgo endDate:[NSDate new]]
      setResponseBlock:^(DBTEAMGetMembershipReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetStorage:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetStorage:twoDaysAgo endDate:[NSDate new]]
      setResponseBlock:^(DBTEAMGetStorageReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

/**
    Permission: TEAM member management
 */

- (void)groupsCreate:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team groupsCreate:_tester.testData.groupName
             addCreatorAsOwner:@(TRUE)
               groupExternalId:_tester.testData.groupExternalId
           groupManagementType:nil]
    setResponseBlock:^(DBTEAMGroupFullInfo * _Nullable result, DBTEAMGroupCreateError * _Nullable routeError, DBRequestError * _Nullable networkError) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:networkError routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsGetInfo:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupsSelector *groupsSelector =
      [[DBTEAMGroupsSelector alloc] initWithGroupExternalIds:@[ _tester.testData.groupExternalId ]];
  [[[_tester.team groupsGetInfo:groupsSelector]
      setResponseBlock:^(NSArray<DBTEAMGroupsGetInfoItem *> *result, DBTEAMGroupsGetInfoError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsList:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team groupsList] setResponseBlock:^(DBTEAMGroupsListResult *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsMembersAdd:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  DBTEAMUserSelectorArg *userSelectorArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId];
  DBTEAMGroupAccessType *accessType = [[DBTEAMGroupAccessType alloc] initWithMember];
  DBTEAMMemberAccess *memberAccess = [[DBTEAMMemberAccess alloc] initWithUser:userSelectorArg accessType:accessType];
  [[[_tester.team groupsMembersAdd:groupSelector members:@[ memberAccess ]]
      setResponseBlock:^(DBTEAMGroupMembersChangeResult *result, DBTEAMGroupMembersAddError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsMembersList:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsMembersList:groupSelector]
      setResponseBlock:^(DBTEAMGroupsMembersListResult *result, DBTEAMGroupSelectorError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsUpdate:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsUpdate:groupSelector
                 returnMembers:nil
                 dNewGroupName:@"New Group Name"
           dNewGroupExternalId:nil
       dNewGroupManagementType:nil]
      setResponseBlock:^(DBTEAMGroupFullInfo *result, DBTEAMGroupUpdateError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsDelete:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
      [[[self->_tester.team groupsJobStatusGet:jobId]
        setResponseBlock:^(DBASYNCPollEmptyResult *result, DBTEAMGroupsPollError *routeError, DBRequestError *error) {
          if (result) {
            MyLog(@"%@\n", result);
            if ([result isInProgress]) {
              [TestFormat abort:error routeError:routeError];
            } else {
              [TestFormat printOffset:@"Deleted"];
              [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
              nextTest();
            }
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsDelete:groupSelector]
      setResponseBlock:^(DBASYNCLaunchEmptyResult *result, DBTEAMGroupDeleteError *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat printOffset:@"Waiting for deletion..."];
            sleep(1);
            jobStatus(result.asyncJobId);
          } else if ([result isComplete]) {
            [TestFormat printOffset:@"Deleted"];
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersAdd:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
      [[[self->_tester.team membersAddJobStatusGet:jobId]
        setResponseBlock:^(DBTEAMMembersAddJobStatus *result, DBASYNCPollError *routeError, DBRequestError *error) {
          if (result) {
            MyLog(@"%@\n", result);
            if ([result isInProgress]) {
              [TestFormat abort:error routeError:routeError];
            } else if ([result isComplete]) {
              DBTEAMMemberAddResult *addResult = result.complete[0];
              if ([addResult isSuccess]) {
                  self->_teamMemberId2 = addResult.success.profile.teamMemberId;
              } else {
                [TestFormat abort:error routeError:routeError];
              }
              [TestFormat printOffset:@"Member added"];
              [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
              nextTest();
            }
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMMemberAddArg *memberAddArg = [[DBTEAMMemberAddArg alloc] initWithMemberEmail:_tester.testData.teamMemberNewEmail];
  [[[_tester.team membersAdd:@[ memberAddArg ]]
      setResponseBlock:^(DBTEAMMembersAddLaunch *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat printOffset:@"Result incomplete..."];
            jobStatus(result.asyncJobId);
          } else if ([result isComplete]) {
            DBTEAMMemberAddResult *addResult = result.complete[0];
            if ([addResult isSuccess]) {
                self->_teamMemberId2 = addResult.success.profile.teamMemberId;
            } else if (![addResult isUserAlreadyOnTeam]) {
              [TestFormat abort:error routeError:routeError];
            }
            [TestFormat printOffset:@"Member added"];
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersGetInfo:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithEmail:_tester.testData.teamMemberNewEmail];
  [[[_tester.team membersGetInfo:@[ userSelectArg ]]
      setResponseBlock:^(NSArray<DBTEAMMembersGetInfoItem *> *result, DBTEAMMembersGetInfoError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
            self->_teamMemberId2 = result[0].memberInfo.profile.teamMemberId;
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersList:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team membersList:[NSNumber numberWithInt:2] includeRemoved:nil]
      setResponseBlock:^(DBTEAMMembersListResult *result, DBTEAMMembersListError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSendWelcomeEmail:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId];
  [[[_tester.team membersSendWelcomeEmail:userSelectArg]
      setResponseBlock:^(DBNilObject *result, DBTEAMMembersSendWelcomeError *routeError, DBRequestError *error) {
        if (!error) {
          [TestFormat printOffset:@"Welcome email sent!"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSetAdminPermissions:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  DBTEAMAdminTier *dNewRole = [[DBTEAMAdminTier alloc] initWithTeamAdmin];
  [[[_tester.team membersSetAdminPermissions:userSelectArg dNewRole:dNewRole]
      setResponseBlock:^(DBTEAMMembersSetPermissionsResult *result, DBTEAMMembersSetPermissionsError *routeError,
                 DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSetProfile:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  [[[_tester.team membersSetProfile:userSelectArg
                          dNewEmail:nil
                     dNewExternalId:nil
                      dNewGivenName:@"NewFirstName"
                        dNewSurname:nil
                   dNewPersistentId:nil
          dNewIsDirectoryRestricted:nil]
      setResponseBlock:^(DBTEAMTeamMemberInfo *result, DBTEAMMembersSetProfileError *routeError, DBRequestError *error) {
        if (!error) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersRemove:(void (^)(void))nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
      [[[self->_tester.team membersRemoveJobStatusGet:jobId]
        setResponseBlock:^(DBASYNCPollEmptyResult *result, DBASYNCPollError *routeError, DBRequestError *error) {
          if (result) {
            MyLog(@"%@\n", result);
            if ([result isInProgress]) {
              [TestFormat abort:error routeError:routeError];
            } else if ([result isComplete]) {
              [TestFormat printOffset:@"Member removed"];
              [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
              nextTest();
            }
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  [[[_tester.team membersRemove:userSelectArg]
      setResponseBlock:^(DBASYNCLaunchEmptyResult *result, DBTEAMMembersRemoveError *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat printOffset:@"Result incomplete. Waiting to query status..."];
            sleep(2);
            jobStatus(result.asyncJobId);
          } else if ([result isComplete]) {
            [TestFormat printOffset:@"Member removed"];
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      } queue:[NSOperationQueue new]] setProgressBlock:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

@end

static int smallDividerSize = 150;

@implementation TestFormat

+ (void)abort:(DBRequestError *)error routeError:(id)routeError {
  [self printErrors:error routeError:routeError];
  MyLog(@"Terminating....\n");
  exit(0);
}

+ (void)printErrors:(DBRequestError *)error routeError:(id)routeError {
  MyLog(@"ERROR: %@\n", error);
  MyLog(@"ROUTE_ERROR: %@\n", routeError);
}

+ (void)printSentProgress:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  MyLog(@"PROGRESS: bytesSent:%lld  totalBytesSent:%lld  totalBytesExpectedToSend:%lld\n\n", bytesSent, totalBytesSent,
        totalBytesExpectedToSend);
}

+ (void)printTestBegin:(NSString *)title {
  [self printLargeDivider];
  [self printTitle:title];
  [self printLargeDivider];
  [self printOffset:@"Beginning....."];
}

+ (void)printTestEnd {
  [self printOffset:@"Test Group Completed"];
  [self printLargeDivider];
}

+ (void)printAllTestsEnd {
  [self printLargeDivider];
  [self printOffset:@"ALL TESTS COMPLETED"];
  [self printLargeDivider];
}

+ (void)printSubTestBegin:(NSString *)title {
  [self printSmallDivider];
  [self printTitle:title];
  MyLog(@"\n");
}

+ (void)printSubTestEnd:(NSString *)result {
  MyLog(@"\n");
  [self printTitle:result];
}

+ (void)printTitle:(NSString *)title {
  MyLog(@"     %@\n", title);
}

+ (void)printOffset:(NSString *)str {
  MyLog(@"\n");
  MyLog(@"     *  %@  *\n", str);
  MyLog(@"\n");
}

+ (void)printSmallDivider {
  NSMutableString *result = [@"" mutableCopy];
  for (int i = 0; i < smallDividerSize; i++) {
    [result appendString:@"-"];
  }
  MyLog(@"%@\n", result);
}

+ (void)printLargeDivider {
  NSMutableString *result = [@"" mutableCopy];
  for (int i = 0; i < smallDividerSize; i++) {
    [result appendString:@"-"];
  }
  MyLog(@"%@\n", result);
}

@end
