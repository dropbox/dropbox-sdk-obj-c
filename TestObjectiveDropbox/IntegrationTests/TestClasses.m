//
//  TestClasses.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "TestClasses.h"
#import "TestData.h"

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
    _testData = testData;
    _auth = [DropboxClientsManager authorizedClient].authRoutes;
    _files = [DropboxClientsManager authorizedClient].filesRoutes;
    _sharing = [DropboxClientsManager authorizedClient].sharingRoutes;
    _users = [DropboxClientsManager authorizedClient].usersRoutes;
  }
  return self;
}

// Test user app with 'Full Dropbox' permission
- (void)testAllUserAPIEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest asMember:(BOOL)asMember {
  void (^end)() = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testAuthEndpoints)() = ^{
    [self testAuthEndpoints:tester nextTest:end];
  };
  void (^testUsersEndpoints)() = ^{
    [self testUsersEndpoints:tester nextTest:testAuthEndpoints];
  };
  void (^testSharingEndpoints)() = ^{
    [self testSharingEndpoints:tester nextTest:testUsersEndpoints];
  };
  void (^testFilesEndpoints)() = ^{
    [self testFilesEndpoints:tester nextTest:testSharingEndpoints asMember:asMember];
  };
  void (^start)() = ^{
    testFilesEndpoints();
  };
  
  start();
}

- (void)testAuthEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest {
  AuthTests *authTests = [[AuthTests alloc] init:tester];
  
  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^tokenFromOauth1)() = ^{
    [authTests tokenFromOauth1:end];
  };
  void (^tokenRevoke)() = ^{
    [authTests tokenRevoke:tokenFromOauth1];
  };
  void (^start)() = ^{
    tokenRevoke();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testFilesEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest asMember:(BOOL)asMember {
  FilesTests *filesTests = [[FilesTests alloc] init:tester];
  
  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^listFolderLongpollAndTrigger)() = ^{
    [filesTests listFolderLongpollAndTrigger:end];
  };
  void (^uploadStream)() = ^{
    [filesTests uploadStream:listFolderLongpollAndTrigger];
  };
  void (^uploadFile)() = ^{
    [filesTests uploadFile:uploadStream];
  };
  void (^downloadToMemory)() = ^{
    [filesTests downloadToMemory:uploadFile];
  };
  void (^downloadToFileAgain)() = ^{
    [filesTests downloadToFileAgain:downloadToMemory];
  };
  void (^downloadToFile)() = ^{
    [filesTests downloadToFile:downloadToFileAgain];
  };
  void (^saveUrl)() = ^{
    [filesTests saveUrl:downloadToFile asMember:asMember];
  };
  void (^move)() = ^{
    [filesTests move:saveUrl];
  };
  void (^listRevisions)() = ^{
    [filesTests listRevisions:move];
  };
  void (^getTemporaryLink)() = ^{
    [filesTests getTemporaryLink:listRevisions];
  };
  void (^getMetadataError)() = ^{
    [filesTests getMetadataError:getTemporaryLink];
  };
  void (^getMetadata)() = ^{
    [filesTests getMetadata:getMetadataError];
  };
  void (^dCopyReferenceGet)() = ^{
    [filesTests dCopyReferenceGet:getMetadata];
  };
  void (^dCopy)() = ^{
    [filesTests dCopy:dCopyReferenceGet];
  };
  void (^uploadDataSession)() = ^{
    [filesTests uploadDataSession:dCopy];
  };
  void (^uploadData)() = ^{
    [filesTests uploadData:uploadDataSession];
  };
  void (^listFolder)() = ^{
    [filesTests listFolder:uploadData];
  };
  void (^listFolderError)() = ^{
    [filesTests listFolderError:listFolder];
  };
  void (^createFolder)() = ^{
    [filesTests createFolder:listFolderError];
  };
  void (^delete_)() = ^{
    [filesTests delete_:createFolder];
  };
  void (^start)() = ^{
    delete_();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testSharingEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest {
  SharingTests *sharingTests = [[SharingTests alloc] init:tester];
  
  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^unshareFolder)() = ^{
    [sharingTests updateFolderPolicy:end];
  };
  void (^updateFolderPolicy)() = ^{
    [sharingTests updateFolderPolicy:unshareFolder];
  };
  void (^mountFolder)() = ^{
    [sharingTests mountFolder:updateFolderPolicy];
  };
  void (^unmountFolder)() = ^{
    [sharingTests unmountFolder:mountFolder];
  };
  void (^revokeSharedLink)() = ^{
    [sharingTests revokeSharedLink:unmountFolder];
  };
  void (^removeFolderMember)() = ^{
    [sharingTests removeFolderMember:revokeSharedLink];
  };
  void (^listSharedLinks)() = ^{
    [sharingTests listSharedLinks:removeFolderMember];
  };
  void (^listFolders)() = ^{
    [sharingTests listFolders:listSharedLinks];
  };
  void (^listFolderMembers)() = ^{
    [sharingTests listFolderMembers:listFolders];
  };
  void (^addFolderMember)() = ^{
    [sharingTests addFolderMember:listFolderMembers];
  };
  void (^getSharedLinkMetadata)() = ^{
    [sharingTests getSharedLinkMetadata:addFolderMember];
  };
  void (^getFolderMetadata)() = ^{
    [sharingTests getFolderMetadata:getSharedLinkMetadata];
  };
  void (^createSharedLinkWithSettings)() = ^{
    [sharingTests createSharedLinkWithSettings:getFolderMetadata];
  };
  void (^shareFolder)() = ^{
    [sharingTests shareFolder:createSharedLinkWithSettings];
  };
  void (^start)() = ^{
    shareFolder();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testUsersEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest {
  UsersTests *usersTests = [[UsersTests alloc] init:tester];
  
  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^getSpaceUsage)() = ^{
    [usersTests getSpaceUsage:end];
  };
  void (^getCurrentAccount)() = ^{
    [usersTests getCurrentAccount:getSpaceUsage];
  };
  void (^getAccountBatch)() = ^{
    [usersTests getAccountBatch:getCurrentAccount];
  };
  void (^getAccount)() = ^{
    [usersTests getAccount:getAccountBatch];
  };
  void (^start)() = ^{
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
    _testData = testData;
    _team = [DropboxClientsManager authorizedTeamClient].teamRoutes;
  }
  return self;
}

// Test business app with 'Team member file access' permission
- (void)testAllTeamMemberFileAcessActions:(void (^)())nextTest {
  DropboxTester *tester = [[DropboxTester alloc] initWithTestData:_testData];
  
  void (^end)() = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testPerformActionAsMember)() = ^{
    [tester testAllUserAPIEndpoints:tester nextTest:end asMember:YES];
  };
  void (^testTeamMemberFileAcessActions)() = ^{
    [self testTeamMemberFileAcessActions:testPerformActionAsMember];
  };
  void (^start)() = ^{
    testTeamMemberFileAcessActions();
  };
  
  start();
}

// Test business app with 'Team member management' permission
- (void)testAllTeamMemberManagementActions:(void (^)())nextTest {
  void (^end)() = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testTeamMemberManagementActions)() = ^{
    [self testTeamMemberManagementActions:end];
  };
  void (^start)() = ^{
    testTeamMemberManagementActions();
  };
  
  start();
}

- (void)testTeamMemberFileAcessActions:(void (^)())nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:self];

  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^reportsGetStorage)() = ^{
    [teamTests reportsGetStorage:end];
  };
  void (^reportsGetMembership)() = ^{
    [teamTests reportsGetMembership:reportsGetStorage];
  };
  void (^reportsGetDevices)() = ^{
    [teamTests reportsGetDevices:reportsGetMembership];
  };
  void (^reportsGetActivity)() = ^{
    [teamTests reportsGetActivity:reportsGetDevices];
  };
  void (^getInfo)() = ^{
    [teamTests getInfo:reportsGetActivity];
  };
  void (^linkedAppsListMembersLinkedApps)() = ^{
    [teamTests linkedAppsListMembersLinkedApps:getInfo];
  };
  void (^linkedAppsListMemberLinkedApps)() = ^{
    [teamTests linkedAppsListMemberLinkedApps:linkedAppsListMembersLinkedApps];
  };
  void (^listMembersDevices)() = ^{
    [teamTests listMembersDevices:linkedAppsListMemberLinkedApps];
  };
  void (^listMemberDevices)() = ^{
    [teamTests listMemberDevices:listMembersDevices];
  };
  void (^initMembersGetInfo)() = ^{
    [teamTests initMembersGetInfo:listMemberDevices];
  };
  void (^start)() = ^{
    initMembersGetInfo();
  };
  
  [TestFormat printTestBegin:NSStringFromSelector(_cmd)];
  start();
}

- (void)testTeamMemberManagementActions:(void (^)())nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:self];
  
  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^membersRemove)() = ^{
    [teamTests membersRemove:end];
  };
  void (^membersSetProfile)() = ^{
    [teamTests membersSetProfile:membersRemove];
  };
  void (^membersSetAdminPermissions)() = ^{
    [teamTests membersSetAdminPermissions:membersSetProfile];
  };
  void (^membersSendWelcomeEmail)() = ^{
    [teamTests membersSendWelcomeEmail:membersSetAdminPermissions];
  };
  void (^membersList)() = ^{
    [teamTests membersList:membersSendWelcomeEmail];
  };
  void (^membersGetInfo)() = ^{
    [teamTests membersGetInfo:membersList];
  };
  void (^membersAdd)() = ^{
    [teamTests membersAdd:membersGetInfo];
  };
  void (^groupsDelete)() = ^{
    [teamTests groupsDelete:membersAdd];
  };
  void (^groupsUpdate)() = ^{
    [teamTests groupsUpdate:groupsDelete];
  };
  void (^groupsMembersList)() = ^{
    [teamTests groupsMembersList:groupsUpdate];
  };
  void (^groupsMembersAdd)() = ^{
    [teamTests groupsMembersAdd:groupsMembersList];
  };
  void (^groupsList)() = ^{
    [teamTests groupsList:groupsMembersAdd];
  };
  void (^groupsGetInfo)() = ^{
    [teamTests groupsGetInfo:groupsList];
  };
  void (^groupsCreate)() = ^{
    [teamTests groupsCreate:groupsGetInfo];
  };
  void (^initMembersGetInfo)() = ^{
    [teamTests initMembersGetInfo:groupsCreate];
  };
  void (^start)() = ^{
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
  
  NSLog(@"Creating files in: %@", [workingDirectory path]);
  // create a bunch of fake files
  for (int i = 0; i < 10; i++) {
    NSString *fileName = [NSString stringWithFormat:@"test_file_%d", i];
    NSString *fileContent = [NSString stringWithFormat:@"%@'s content. Test content here.", fileName];
    NSURL *fileUrl = [workingDirectory URLByAppendingPathComponent:fileName];
    
    // don't create a file for the name test_file_5 so we use a custom large file
    // there instead
    if (i != 5) {
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
    }
    
    DBFILESCommitInfo *commitInfo =
      [[DBFILESCommitInfo alloc] initWithPath:[NSString stringWithFormat:@"%@/%@", _tester.testData.testFolderPath, fileName]];
    
    [uploadFilesUrlsToCommitInfo setObject:commitInfo forKey:fileUrl];
  }
  
  [_tester.files batchUploadFiles:uploadFilesUrlsToCommitInfo queue:nil progressBlock:^(int64_t uploaded, int64_t uploadedTotal, int64_t expectedToUploadTotal) {
    NSLog(@"Uploaded: %lld  UploadedTotal: %lld  ExpectedToUploadTotal: %lld", uploaded, uploadedTotal, expectedToUploadTotal);
  } responseBlock:^(DBFILESUploadSessionFinishBatchJobStatus *result, DBASYNCPollError *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }];
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

- (void)tokenRevoke:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.auth tokenRevoke] response:[NSOperationQueue new] response:^(DBNilObject *result, DBNilObject *routeError, DBRequestError *error) {
    MyLog(@"%@\n", result);
    [TestFormat printOffset:@"Token successfully revoked"];
    [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
    nextTest();
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)tokenFromOauth1:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.auth tokenFromOauth1:_tester.testData.oauth1Token oauth1TokenSecret:_tester.testData.oauth1TokenSecret]
    response:[NSOperationQueue new] response:^(DBAUTHTokenFromOAuth1Result *result, DBAUTHTokenFromOAuth1Error *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat printErrors:error routeError:routeError];
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
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

- (void)delete_:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files delete_:_tester.testData.baseFolder]
      response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESDeleteError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat printErrors:error routeError:routeError];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)createFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files createFolder:_tester.testData.testFolderPath]
      response:[NSOperationQueue new] response:^(DBFILESFolderMetadata *result, DBFILESCreateFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderError:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listFolder:@"/"]
      response:[NSOperationQueue new] response:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"Something went wrong...\n");
        } else {
          [TestFormat printOffset:@"Intentionally errored.\n"];
          [TestFormat printErrors:error routeError:routeError];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listFolder:_tester.testData.testFolderPath]
      response:[NSOperationQueue new] response:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadData:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = _tester.testData.testFilePath;
  [[[_tester.files uploadData:outputPath inputData:_tester.testData.fileData]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadDataSession:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^uploadSessionAppendV2)(NSString *, DBFILESUploadSessionCursor *) = ^(NSString *sessionId,
                                                                              DBFILESUploadSessionCursor *cursor) {
    [[[_tester.files uploadSessionAppendV2Data:cursor inputData:_tester.testData.fileData]
        response:[NSOperationQueue new] response:^(DBNilObject *result, DBFILESUploadSessionLookupError *routeError, DBRequestError *error) {
          // response type for this route is nil
          if (!error) {
            DBFILESUploadSessionCursor *cursor = [[DBFILESUploadSessionCursor alloc]
                initWithSessionId:sessionId
                           offset:[NSNumber numberWithUnsignedLong:(_tester.testData.fileData.length * 2)]];
            DBFILESCommitInfo *commitInfo = [[DBFILESCommitInfo alloc]
                initWithPath:[NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_session"]];

            [[[_tester.files uploadSessionFinishData:cursor commit:commitInfo inputData:_tester.testData.fileData]
                response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESUploadSessionFinishError *routeError, DBRequestError *error) {
                  if (result) {
                    MyLog(@"%@\n", result);
                    [TestFormat printOffset:@"Upload session complete"];
                    [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
                    nextTest();
                  } else {
                    [TestFormat abort:error routeError:routeError];
                  }
                }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
              [TestFormat printSentProgress:bytesSent
                             totalBytesSent:totalBytesSent
                   totalBytesExpectedToSend:totalBytesExpectedToSend];
            }];
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  [[[_tester.files uploadSessionStartData:_tester.testData.fileData]
      response:[NSOperationQueue new] response:^(DBFILESUploadSessionStartResult *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printOffset:@"Acquiring sessionId"];
          uploadSessionAppendV2(
              result.sessionId,
              [[DBFILESUploadSessionCursor alloc]
                  initWithSessionId:result.sessionId
                             offset:[NSNumber numberWithUnsignedLong:(_tester.testData.fileData.length)]]);
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)dCopy:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *copyOutputPath = [NSString
      stringWithFormat:@"%@%@%@%@", _tester.testData.testFilePath, @"_duplicate", @"_", _tester.testData.testId];
  [[[_tester.files dCopy:_tester.testData.testFilePath toPath:copyOutputPath]
      response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESRelocationError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)dCopyReferenceGet:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files dCopyReferenceGet:_tester.testData.testFilePath]
      response:[NSOperationQueue new] response:^(DBFILESGetCopyReferenceResult *result, DBFILESGetCopyReferenceError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getMetadata:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getMetadata:_tester.testData.testFilePath]
      response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESGetMetadataError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getMetadataError:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getMetadata:@"/"]
      response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESGetMetadataError *routeError, DBRequestError *error) {
        if (result) {
          NSAssert(NO, @"This call should have errored.");
        } else {
          NSAssert(error, @"This call should have errored.");
          [TestFormat printOffset:@"Error properly detected"];
          MyLog(@"%@\n", error);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getTemporaryLink:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files getTemporaryLink:_tester.testData.testFilePath]
      response:[NSOperationQueue new] response:^(DBFILESGetTemporaryLinkResult *result, DBFILESGetTemporaryLinkError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listRevisions:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files listRevisions:_tester.testData.testFilePath]
      response:[NSOperationQueue new] response:^(DBFILESListRevisionsResult *result, DBFILESListRevisionsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)move:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *folderPath = [NSString stringWithFormat:@"%@%@%@", _tester.testData.testFolderPath, @"/", @"movedLocation"];
  [[[_tester.files createFolder:folderPath]
      response:[NSOperationQueue new] response:^(DBFILESFolderMetadata *result, DBFILESCreateFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printOffset:@"Created destination folder"];

          NSString *fileToMove = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_session"];
          NSString *destPath =
              [NSString stringWithFormat:@"%@%@%@%@", folderPath, @"/", _tester.testData.testFileName, @"_session"];

          [[[_tester.files move:fileToMove toPath:destPath]
              response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESRelocationError *routeError, DBRequestError *error) {
                if (result) {
                  MyLog(@"%@\n", result);
                  [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
                  nextTest();
                } else {
                  [TestFormat abort:error routeError:routeError];
                }
              }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            [TestFormat printSentProgress:bytesSent
                           totalBytesSent:totalBytesSent
                 totalBytesExpectedToSend:totalBytesExpectedToSend];
          }];
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)saveUrl:(void (^)())nextTest asMember:(BOOL)asMember {
  if (asMember) {
    nextTest();
    return;
  }
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *folderPath = [NSString stringWithFormat:@"%@%@%@", _tester.testData.testFolderPath, @"/", @"dbx-test.html"];
  [[[_tester.files saveUrl:folderPath url:@"https://www.dropbox.com/help/5"]
      response:[NSOperationQueue new] response:^(DBFILESSaveUrlResult *result, DBFILESSaveUrlError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFile:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadUrl:_tester.testData.testFilePath overwrite:YES destination:_tester.testData.destURL]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFileAgain:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadUrl:_tester.testData.testFilePath overwrite:YES destination:_tester.testData.destURL]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToFileError:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *filePath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_does_not_exist"];
  [[[_tester.files downloadUrl:filePath overwrite:YES destination:_tester.testData.destURL]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSURL *destination) {
        if (result) {
          NSAssert(NO, @"This call should have errored!");
        } else {
          NSAssert(![[NSFileManager defaultManager] fileExistsAtPath:[_tester.testData.destURLException path]],
                   @"File should not exist here.");
          [TestFormat printOffset:@"Error properly detected"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)downloadToMemory:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.files downloadData:_tester.testData.testFilePath]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileContents) {
        if (result) {
          MyLog(@"%@\n", result);
          NSString *dataStr = [[NSString alloc] initWithData:fileContents encoding:NSUTF8StringEncoding];
          [TestFormat printOffset:@"File contents:"];
          MyLog(@"%@\n", dataStr);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadFile:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_from_file"];
  [[[_tester.files uploadUrl:outputPath inputUrl:_tester.testData.destURL]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)uploadStream:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSString *outputPath = [NSString stringWithFormat:@"%@%@", _tester.testData.testFilePath, @"_from_stream"];
  [[[_tester.files uploadStream:outputPath inputStream:[[NSInputStream alloc] initWithURL:_tester.testData.destURL]]
      response:[NSOperationQueue new] response:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderLongpollAndTrigger:(void (^)())nextTest {
  void (^copy)() = ^{
    [TestFormat printOffset:@"Making change that longpoll will detect (copy file)"];
    NSString *copyOutputPath =
        [NSString stringWithFormat:@"%@%@%@", _tester.testData.testFilePath, @"_duplicate2_", _tester.testData.testId];

    [[[_tester.files dCopy:_tester.testData.testFilePath toPath:copyOutputPath]
        response:[NSOperationQueue new] response:^(DBFILESMetadata *result, DBFILESRelocationError *routeError, DBRequestError *error) {
          if (result) {
            MyLog(@"%@\n", result);
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  void (^listFolderContinue)(NSString *) = ^(NSString *cursor) {
    [[[_tester.files listFolderContinue:cursor]
        response:[NSOperationQueue new] response:^(DBFILESListFolderResult *result, DBFILESListFolderContinueError *routeError, DBRequestError *error) {
          if (result) {
            [TestFormat printOffset:@"Here are the changes:"];
            MyLog(@"%@\n", result);
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          } else {
            [TestFormat abort:error routeError:routeError];
          }
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  void (^listFolderLongpoll)(NSString *) = ^(NSString *cursor) {
    [TestFormat printOffset:@"Establishing longpoll"];
    [[[_tester.files listFolderLongpoll:cursor] response:[NSOperationQueue new] response:^(DBFILESListFolderLongpollResult *result,
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
    }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];

    copy();
  };

  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  [TestFormat printOffset:@"Acquring cursor"];
  [[[_tester.files listFolderGetLatestCursor:_tester.testData.testFolderPath]
      response:[NSOperationQueue new] response:^(DBFILESListFolderGetLatestCursorResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
        if (result) {
          [TestFormat printOffset:@"Cursor acquired"];
          MyLog(@"%@\n", result);
          listFolderLongpoll(result.cursor);
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
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

- (void)shareFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing shareFolder:_tester.testData.testShareFolderPath]
      response:[NSOperationQueue new] response:^(DBSHARINGShareFolderLaunch *result, DBSHARINGShareFolderError *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat
                printOffset:[NSString stringWithFormat:@"Folder not yet shared! Job id: %@. Please adjust test order.",
                                                       result.asyncJobId]];
          } else if ([result isComplete]) {
            MyLog(@"%@\n", result.complete);
            _sharedFolderId = result.complete.sharedFolderId;
            [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
            nextTest();
          } else {
            [TestFormat printOffset:@"Improperly handled share folder result"];
            [TestFormat abort:error routeError:routeError];
          }
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)createSharedLinkWithSettings:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing createSharedLinkWithSettings:_tester.testData.testShareFolderPath]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedLinkMetadata *result, DBSHARINGCreateSharedLinkWithSettingsError *routeError,
                 DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          _sharedLink = result.url;
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getFolderMetadata:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing getFolderMetadata:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGSharedFolderAccessError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getSharedLinkMetadata:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing getSharedLinkMetadata:_sharedLink]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedLinkMetadata *result, DBSHARINGSharedLinkError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)addFolderMember:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBSHARINGMemberSelector *memberSelector =
      [[DBSHARINGMemberSelector alloc] initWithEmail:_tester.testData.accountId3Email];
  DBSHARINGAddMember *addFolderMemberArg = [[DBSHARINGAddMember alloc] initWithMember:memberSelector];
  [[[_tester.sharing addFolderMember:_sharedFolderId
                             members:@[ addFolderMemberArg ]
                               quiet:[NSNumber numberWithBool:YES]
                       customMessage:nil]
      response:[NSOperationQueue new] response:^(DBNilObject *result, DBSHARINGAddFolderMemberError *routeError, DBRequestError *error) {
        if (!error) {
          [TestFormat printOffset:@"Folder member added"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolderMembers:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listFolderMembers:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedFolderMembers *result, DBSHARINGSharedFolderAccessError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listFolders:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listFolders:[NSNumber numberWithInteger:2] actions:nil]
      response:[NSOperationQueue new] response:^(DBSHARINGListFoldersResult *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listSharedLinks:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing listSharedLinks]
      response:[NSOperationQueue new] response:^(DBSHARINGListSharedLinksResult *result, DBSHARINGListSharedLinksError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)removeFolderMember:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBSHARINGMemberSelector *memberSelector =
      [[DBSHARINGMemberSelector alloc] initWithDropboxId:_tester.testData.accountId3];

  void (^checkJobStatus)(NSString *) = ^(NSString *asyncJobId) {
    [[[_tester.sharing checkJobStatus:asyncJobId] response:[NSOperationQueue new] response:^(DBSHARINGJobStatus *result, DBASYNCPollError *routeError,
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
    }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  [[[_tester.sharing removeFolderMember:_sharedFolderId member:memberSelector leaveACopy:[NSNumber numberWithBool:NO]]
      response:[NSOperationQueue new] response:^(DBASYNCLaunchResultBase *result, DBSHARINGRemoveFolderMemberError *routeError, DBRequestError *error) {
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)revokeSharedLink:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing revokeSharedLink:_sharedLink]
      response:[NSOperationQueue new] response:^(DBNilObject *result, DBSHARINGRevokeSharedLinkError *routeError, DBRequestError *error) {
        if (!routeError) {
          [TestFormat printOffset:@"Shared link revoked"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)unmountFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing unmountFolder:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBNilObject *result, DBSHARINGUnmountFolderError *routeError, DBRequestError *error) {
        if (!routeError) {
          [TestFormat printOffset:@"Folder unmounted"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)mountFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing mountFolder:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGMountFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)updateFolderPolicy:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing updateFolderPolicy:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBSHARINGSharedFolderMetadata *result, DBSHARINGUpdateFolderPolicyError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)unshareFolder:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.sharing unshareFolder:_sharedFolderId]
      response:[NSOperationQueue new] response:^(DBASYNCLaunchEmptyResult *result, DBSHARINGUnshareFolderError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
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

- (void)getAccount:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getAccount:_tester.testData.accountId]
      response:[NSOperationQueue new] response:^(DBUSERSBasicAccount *result, DBUSERSGetAccountError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getAccountBatch:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSArray<NSString *> *accountIds = @[ _tester.testData.accountId, _tester.testData.accountId2 ];
  [[[_tester.users getAccountBatch:accountIds]
      response:[NSOperationQueue new] response:^(NSArray<DBUSERSBasicAccount *> *result, DBUSERSGetAccountBatchError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getCurrentAccount:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getCurrentAccount] response:[NSOperationQueue new] response:^(DBUSERSFullAccount *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getSpaceUsage:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.users getSpaceUsage] response:[NSOperationQueue new] response:^(DBUSERSSpaceUsage *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
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

- (void)initMembersGetInfo:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithEmail:_tester.testData.teamMemberEmail];
  [[[_tester.team membersGetInfo:@[ userSelectArg ]] response:[NSOperationQueue new] response:^(NSArray<DBTEAMMembersGetInfoItem *> *result,
                                                                DBTEAMMembersGetInfoError *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      DBTEAMMembersGetInfoItem *getInfo = result[0];
      if ([getInfo isIdNotFound]) {
        [TestFormat abort:error routeError:routeError];
      } else if ([getInfo isMemberInfo]) {
        _teamMemberId = getInfo.memberInfo.profile.teamMemberId;
        [DropboxClientsManager authorizedClient:[[DropboxClientsManager authorizedTeamClient] asMember:_teamMemberId]];
      }
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listMemberDevices:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team devicesListMemberDevices:_teamMemberId]
      response:[NSOperationQueue new] response:^(DBTEAMListMemberDevicesResult *result, DBTEAMListMemberDevicesError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)listMembersDevices:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team devicesListMembersDevices]
      response:[NSOperationQueue new] response:^(DBTEAMListMembersDevicesResult *result, DBTEAMListMembersDevicesError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)linkedAppsListMemberLinkedApps:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team linkedAppsListMemberLinkedApps:_teamMemberId]
      response:[NSOperationQueue new] response:^(DBTEAMListMemberAppsResult *result, DBTEAMListMemberAppsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)linkedAppsListMembersLinkedApps:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team linkedAppsListMembersLinkedApps]
      response:[NSOperationQueue new] response:^(DBTEAMListMembersAppsResult *result, DBTEAMListMembersAppsError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)getInfo:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team getInfo] response:[NSOperationQueue new] response:^(DBTEAMTeamGetInfoResult *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetActivity:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetActivity:twoDaysAgo endDate:[NSDate new]]
      response:[NSOperationQueue new] response:^(DBTEAMGetActivityReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetDevices:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetDevices:twoDaysAgo endDate:[NSDate new]]
      response:[NSOperationQueue new] response:^(DBTEAMGetDevicesReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetMembership:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetMembership:twoDaysAgo endDate:[NSDate new]]
      response:[NSOperationQueue new] response:^(DBTEAMGetMembershipReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)reportsGetStorage:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *twoDaysAgo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-2 toDate:[NSDate new] options:0];
  [[[_tester.team reportsGetStorage:twoDaysAgo endDate:[NSDate new]]
      response:[NSOperationQueue new] response:^(DBTEAMGetStorageReport *result, DBTEAMDateRangeError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

/**
    Permission: TEAM member management
 */

- (void)groupsCreate:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team groupsCreate:_tester.testData.groupName
               groupExternalId:_tester.testData.groupExternalId
           groupManagementType:nil]
      response:[NSOperationQueue new] response:^(DBTEAMGroupFullInfo *result, DBTEAMGroupCreateError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsGetInfo:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupsSelector *groupsSelector =
      [[DBTEAMGroupsSelector alloc] initWithGroupExternalIds:@[ _tester.testData.groupExternalId ]];
  [[[_tester.team groupsGetInfo:groupsSelector]
      response:[NSOperationQueue new] response:^(NSArray<DBTEAMGroupsGetInfoItem *> *result, DBTEAMGroupsGetInfoError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsList:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team groupsList] response:[NSOperationQueue new] response:^(DBTEAMGroupsListResult *result, DBNilObject *routeError, DBRequestError *error) {
    if (result) {
      MyLog(@"%@\n", result);
      [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
      nextTest();
    } else {
      [TestFormat abort:error routeError:routeError];
    }
  }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsMembersAdd:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  DBTEAMUserSelectorArg *userSelectorArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId];
  DBTEAMGroupAccessType *accessType = [[DBTEAMGroupAccessType alloc] initWithMember];
  DBTEAMMemberAccess *memberAccess = [[DBTEAMMemberAccess alloc] initWithUser:userSelectorArg accessType:accessType];
  [[[_tester.team groupsMembersAdd:groupSelector members:@[ memberAccess ]]
      response:[NSOperationQueue new] response:^(DBTEAMGroupMembersChangeResult *result, DBTEAMGroupMembersAddError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsMembersList:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsMembersList:groupSelector]
      response:[NSOperationQueue new] response:^(DBTEAMGroupsMembersListResult *result, DBTEAMGroupSelectorError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsUpdate:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsUpdate:groupSelector
                 returnMembers:nil
                 dNewGroupName:@"New Group Name"
           dNewGroupExternalId:nil
       dNewGroupManagementType:nil]
      response:[NSOperationQueue new] response:^(DBTEAMGroupFullInfo *result, DBTEAMGroupUpdateError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)groupsDelete:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
    [[[_tester.team groupsJobStatusGet:jobId]
        response:[NSOperationQueue new] response:^(DBASYNCPollEmptyResult *result, DBTEAMGroupsPollError *routeError, DBRequestError *error) {
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
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMGroupSelector *groupSelector =
      [[DBTEAMGroupSelector alloc] initWithGroupExternalId:_tester.testData.groupExternalId];
  [[[_tester.team groupsDelete:groupSelector]
      response:[NSOperationQueue new] response:^(DBASYNCLaunchEmptyResult *result, DBTEAMGroupDeleteError *routeError, DBRequestError *error) {
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersAdd:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
    [[[_tester.team membersAddJobStatusGet:jobId]
        response:[NSOperationQueue new] response:^(DBTEAMMembersAddJobStatus *result, DBASYNCPollError *routeError, DBRequestError *error) {
          if (result) {
            MyLog(@"%@\n", result);
            if ([result isInProgress]) {
              [TestFormat abort:error routeError:routeError];
            } else if ([result isComplete]) {
              DBTEAMMemberAddResult *addResult = result.complete[0];
              if ([addResult isSuccess]) {
                _teamMemberId2 = addResult.success.profile.teamMemberId;
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
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMMemberAddArg *memberAddArg = [[DBTEAMMemberAddArg alloc] initWithMemberEmail:_tester.testData.teamMemberNewEmail
                                                                     memberGivenName:@"FirstName"
                                                                       memberSurname:@"LastName"];
  [[[_tester.team membersAdd:@[ memberAddArg ]]
      response:[NSOperationQueue new] response:^(DBTEAMMembersAddLaunch *result, DBNilObject *routeError, DBRequestError *error) {
        if (result) {
          if ([result isAsyncJobId]) {
            [TestFormat printOffset:@"Result incomplete..."];
            jobStatus(result.asyncJobId);
          } else if ([result isComplete]) {
            DBTEAMMemberAddResult *addResult = result.complete[0];
            if ([addResult isSuccess]) {
              _teamMemberId2 = addResult.success.profile.teamMemberId;
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersGetInfo:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId];
  [[[_tester.team membersGetInfo:@[ userSelectArg ]]
      response:[NSOperationQueue new] response:^(NSArray<DBTEAMMembersGetInfoItem *> *result, DBTEAMMembersGetInfoError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersList:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  [[[_tester.team membersList:[NSNumber numberWithInt:2] includeRemoved:nil]
      response:[NSOperationQueue new] response:^(DBTEAMMembersListResult *result, DBTEAMMembersListError *routeError, DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSendWelcomeEmail:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId];
  [[[_tester.team membersSendWelcomeEmail:userSelectArg]
      response:[NSOperationQueue new] response:^(DBNilObject *result, DBTEAMMembersSendWelcomeError *routeError, DBRequestError *error) {
        if (!error) {
          [TestFormat printOffset:@"Welcome email sent!"];
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSetAdminPermissions:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  DBTEAMAdminTier *dNewRole = [[DBTEAMAdminTier alloc] initWithTeamAdmin];
  [[[_tester.team membersSetAdminPermissions:userSelectArg dNewRole:dNewRole]
      response:[NSOperationQueue new] response:^(DBTEAMMembersSetPermissionsResult *result, DBTEAMMembersSetPermissionsError *routeError,
                 DBRequestError *error) {
        if (result) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersSetProfile:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];
  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  [[[_tester.team membersSetProfile:userSelectArg
                          dNewEmail:nil
                     dNewExternalId:nil
                      dNewGivenName:@"NewFirstName"
                        dNewSurname:nil]
      response:[NSOperationQueue new] response:^(DBTEAMTeamMemberInfo *result, DBTEAMMembersSetProfileError *routeError, DBRequestError *error) {
        if (!error) {
          MyLog(@"%@\n", result);
          [TestFormat printSubTestEnd:NSStringFromSelector(_cmd)];
          nextTest();
        } else {
          [TestFormat abort:error routeError:routeError];
        }
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    [TestFormat printSentProgress:bytesSent
                   totalBytesSent:totalBytesSent
         totalBytesExpectedToSend:totalBytesExpectedToSend];
  }];
}

- (void)membersRemove:(void (^)())nextTest {
  [TestFormat printSubTestBegin:NSStringFromSelector(_cmd)];

  void (^jobStatus)(NSString *) = ^(NSString *jobId) {
    [[[_tester.team membersRemoveJobStatusGet:jobId]
        response:[NSOperationQueue new] response:^(DBASYNCPollEmptyResult *result, DBASYNCPollError *routeError, DBRequestError *error) {
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
        }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
      [TestFormat printSentProgress:bytesSent
                     totalBytesSent:totalBytesSent
           totalBytesExpectedToSend:totalBytesExpectedToSend];
    }];
  };

  DBTEAMUserSelectorArg *userSelectArg = [[DBTEAMUserSelectorArg alloc] initWithTeamMemberId:_teamMemberId2];
  [[[_tester.team membersRemove:userSelectArg]
      response:[NSOperationQueue new] response:^(DBASYNCLaunchEmptyResult *result, DBTEAMMembersRemoveError *routeError, DBRequestError *error) {
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
      }] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
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
