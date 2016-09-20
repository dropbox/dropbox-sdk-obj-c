//
//  ViewController.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "TestClasses.h"
#import "TestData.h"
#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIButton *linkButton;
@property(weak, nonatomic) IBOutlet UIButton *linkBrowserButton;
@property(weak, nonatomic) IBOutlet UIButton *runTestsButton;
@property(weak, nonatomic) IBOutlet UIButton *unlinkButton;

@end

@implementation ViewController
- (IBAction)linkButtonPressed:(id)sender {
  [DropboxClientsManager authorizeFromController:[UIApplication sharedApplication]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[UIApplication sharedApplication] openURL:url];
                                         }
                                     browserAuth:NO];
}

- (IBAction)linkBrowserButtonPressed:(id)sender {
  [DropboxClientsManager authorizeFromController:[UIApplication sharedApplication]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[UIApplication sharedApplication] openURL:url];
                                         }
                                     browserAuth:YES];
}

- (IBAction)runTestsButtonPressed:(id)sender {
  DropboxTester *tester = [[DropboxTester alloc] initWithTestData:[TestData new]];

  void (^unlink)() = ^{
    [TestFormat printAllTestsEnd];
    [DropboxClientsManager unlinkClients];
    [self checkButtons];
    [self.view setNeedsDisplay];
  };

  switch (appPermission) {
  case FullDropbox:
    [self testAllUserEndpoints:tester nextTest:unlink asMember:NO];
    break;
  case TeamMemberFileAccess:
    [self testTeamMemberFileAcessActions:unlink];
    break;
  case TeamMemberManagement:
    [self testTeamMemberManagementActions:unlink];
    break;
  }
}
- (IBAction)unlinkButtonPressed:(id)sender {
  [DropboxClientsManager unlinkClients];
  [self checkButtons];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self checkButtons];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidLoad];
  [self checkButtons];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)checkButtons {
  if ([DropboxClientsManager authorizedClient] != nil || [DropboxClientsManager authorizedTeamClient] != nil) {
    _linkButton.hidden = YES;
    _linkBrowserButton.hidden = YES;
    _unlinkButton.hidden = NO;
    _runTestsButton.hidden = NO;
  } else {
    _linkButton.hidden = NO;
    _linkBrowserButton.hidden = NO;
    _unlinkButton.hidden = YES;
    _runTestsButton.hidden = YES;
  }
}

/**
 To run these unit tests, you will need to do the following:

 Navigate to TestObjectiveDropbox_<platform>/ and run `pod install` to generate workspace file.

 There are three types of unit tests here:

 1.) Regular Dropbox User API tests (requires app with 'Full Dropbox' permissions)
 2.) Dropbox Business API tests (requires app with 'Team member file access' permissions)
 3.) Dropbox Business API tests (requires app with 'Team member management' permissions)

 To run all of these tests, you will need three apps, one for each of the above permission types.

 You must test these apps one at a time.

 Once you have these apps, you will need to do the following:

 1.) Fill in personal data in `TestData`in TestData.m.
 2.) For each of the above apps, you will need to add a user-specific app key. For each test run, you
 will need to call `[DropboxClientsManager setupWithAppKey]` (or `[DropboxClientsManager setupWithTeamAppKey]`) and
 supply the
 appropriate app key value, in AppDelegate.m.
 3.) Depending on which app you are currently testing, you will need to toggle the `appPermission` variable
 in AppDelegate.h to the appropriate value.
 4.) For each of the above apps, you will need to add a user-specific URL scheme in Info.plist >
 URL types > Item 0 (Editor) > URL Schemes > click '+'. URL scheme value should be 'db-<APP KEY>'
 where '<APP KEY>' is value of your particular app's key

 To create an app or to locate your app's app key, please visit the App Console here:

 https://www.dropbox.com/developers/apps
*/

// Test user app with 'Full Dropbox' permission
- (void)testAllUserEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest asMember:(BOOL)asMember {

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

// Test business app with 'Team member file access' permission
- (void)testTeamMemberFileAcessActions:(void (^)())nextTest {
  DropboxTeamTester *teamTester = [[DropboxTeamTester alloc] initWithTestData:[TestData new]];

  void (^end)() = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testPerformActionAsMember)() = ^{
    DropboxTester *tester = [[DropboxTester alloc] initWithTestData:[TestData new]];
    [self testAllUserEndpoints:tester nextTest:end asMember:YES];
  };
  void (^testTeamMemberFileAcessActions)() = ^{
    [self testTeamMemberFileAcessActions:teamTester nextTest:testPerformActionAsMember];
  };
  void (^start)() = ^{
    testTeamMemberFileAcessActions();
  };

  start();
}

// Test business app with 'Team member management' permission
- (void)testTeamMemberManagementActions:(void (^)())nextTest {
  DropboxTeamTester *teamTester = [[DropboxTeamTester alloc] initWithTestData:[TestData new]];

  void (^end)() = ^{
    if (nextTest) {
      nextTest();
    } else {
      [TestFormat printAllTestsEnd];
    }
  };
  void (^testTeamMemberManagementActions)() = ^{
    [self testTeamMemberManagementActions:teamTester nextTest:end];
  };
  void (^start)() = ^{
    testTeamMemberManagementActions();
  };

  start();
}

- (void)testAuthEndpoints:(DropboxTester *)tester nextTest:(void (^)())nextTest {
  AuthTests *authTests = [[AuthTests alloc] init:tester];

  void (^end)() = ^{
    [TestFormat printTestEnd];
    nextTest();
  };
  void (^tokenRevoke)() = ^{
    [authTests tokenRevoke:end];
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

- (void)testTeamMemberFileAcessActions:(DropboxTeamTester *)tester nextTest:(void (^)())nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:tester];

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

- (void)testTeamMemberManagementActions:(DropboxTeamTester *)tester nextTest:(void (^)())nextTest {
  TeamTests *teamTests = [[TeamTests alloc] init:tester];

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
