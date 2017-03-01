//
//  ViewController.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "TestAppType.h"
#import "TestClasses.h"
#import "TestData.h"
#import "ViewController.h"

/// OpenWith data
static DBOpenWithInfo *s_openWithInfoNSURL = nil;

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *linkBrowserButton;
@property (weak, nonatomic) IBOutlet UIButton *runTestsButton;
@property (weak, nonatomic) IBOutlet UIButton *unlinkButton;
@property (weak, nonatomic) IBOutlet UIButton *openWithButton;
@property (weak, nonatomic) IBOutlet UIButton *runBatchUploadTestsButton;

@end

@implementation ViewController
- (IBAction)linkButtonPressed:(id)sender {
  [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[UIApplication sharedApplication] openURL:url];
                                         }
                                     browserAuth:NO];
}

- (IBAction)linkBrowserButtonPressed:(id)sender {
  [DBClientsManager authorizeFromController:[UIApplication sharedApplication]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[UIApplication sharedApplication] openURL:url];
                                         }
                                     browserAuth:YES];
}
- (IBAction)runBatchUploadTestsButtonPressed:(id)sender {
  TestData *data = [TestData new];
  BatchUploadTests *batchUploadTests = [[BatchUploadTests alloc] init:[[DropboxTester alloc] initWithTestData:data]];
  [batchUploadTests batchUploadFiles];
}

- (IBAction)runTestsButtonPressed:(id)sender {
  TestData *data = [TestData new];

  void (^unlink)() = ^{
    [TestFormat printAllTestsEnd];
    [DBClientsManager unlinkAndResetClients];
    exit(0);
  };

  switch (appPermission) {
  case FullDropbox:
    [[[DropboxTester alloc] initWithTestData:data] testAllUserAPIEndpoints:unlink asMember:NO];
    break;
  case TeamMemberFileAccess:
    [[[DropboxTeamTester alloc] initWithTestData:data] testAllTeamMemberFileAcessActions:unlink];
    break;
  case TeamMemberManagement:
    [[[DropboxTeamTester alloc] initWithTestData:data] testAllTeamMemberManagementActions:unlink];
    break;
  }
}

- (IBAction)openWithButtonPressedRunTests:(id)sender {
  TestData *data = [TestData new];

  DBOfficialAppConnector *connector = [[DBOfficialAppConnector alloc] initWithAppKey:data.fullDropboxAppKey];
  DBOpenWithInfo *openWithInfo = [DBOfficialAppConnector retriveOfficialDropboxAppOpenWithInfo];

  if (openWithInfo) {
    // Data retrieved from UIPasteboard
    NSLog(@"Returning to Dropbox app via Pasteboard data...");
    [connector returnToDropboxApp:openWithInfo changesPending:NO openURLWrapper:^(NSURL *url) { [[UIApplication sharedApplication] openURL:url]; }];
  } else if (s_openWithInfoNSURL) {
    // Data retrieved from openURL call
    NSLog(@"Returning to Dropbox app via NSURL data...");
    DBOfficialAppConnector *appConnector = [[DBOfficialAppConnector alloc] initWithAppKey:[DBClientsManager appKey]];
    [appConnector returnToDropboxApp:s_openWithInfoNSURL changesPending:NO openURLWrapper:^(NSURL *url) {
      [[UIApplication sharedApplication] openURL:url];
    }];
  } else {
    // No OpenWith Data
    NSLog(@"No info retrieved. Please ensure you have opened this test app with the correct OpenWith info.");
  }
}

- (IBAction)unlinkButtonPressed:(id)sender {
  [DBClientsManager unlinkAndResetClients];
  [self checkButtons];
}

- (void)setOpenWithInfoNSURL:(DBOpenWithInfo *)openWithInfoNSURL {
  s_openWithInfoNSURL = openWithInfoNSURL;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self checkButtons];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self checkButtons];
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)checkButtons {
  if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
    _linkButton.hidden = YES;
    _linkBrowserButton.hidden = YES;
    _unlinkButton.hidden = NO;
    _runTestsButton.hidden = NO;
    _runBatchUploadTestsButton.hidden = NO;
  } else {
    _linkButton.hidden = NO;
    _linkBrowserButton.hidden = NO;
    _unlinkButton.hidden = YES;
    _runTestsButton.hidden = YES;
    _runBatchUploadTestsButton.hidden = YES;
  }
}

/**
 To run these unit tests, you will need to do the following:

 Navigate to TestObjectiveDropbox/ and run `pod install` to generate workspace file.

 There are three types of unit tests here:

 1.) Regular Dropbox User API tests (requires app with 'Full Dropbox' permissions)
 2.) Dropbox Business API tests (requires app with 'Team member file access' permissions)
 3.) Dropbox Business API tests (requires app with 'Team member management' permissions)

 To run all of these tests, you will need three apps, one for each of the above permission types.

 You must test these apps one at a time.

 Once you have these apps, you will need to do the following:

 1.) Fill in personal data in `TestData`in TestData.m.
 2.) For each of the above apps, you will need to add a user-specific app key. For each test run, you
 will need to call `[DBClientsManager setupWithAppKey]` (or `[DBClientsManager setupWithTeamAppKey]`) and
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

@end
