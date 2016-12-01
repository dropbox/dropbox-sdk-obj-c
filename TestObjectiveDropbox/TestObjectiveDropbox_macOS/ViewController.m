//
//  ViewController.m
//  TestObjectiveDropbox_macOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "TestClasses.h"
#import "TestData.h"
#import "ViewController.h"

@interface ViewController ()

@property(weak) IBOutlet NSButtonCell *linkButton;
@property(weak) IBOutlet NSButtonCell *linkBrowserButton;
@property(weak) IBOutlet NSButtonCell *runTestsButton;
@property(weak) IBOutlet NSButtonCell *unlinkButton;

@end

@implementation ViewController

- (IBAction)linkButtonPressed:(id)sender {
  [DropboxClientsManager authorizeFromControllerDesktop:[NSWorkspace sharedWorkspace]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[NSWorkspace sharedWorkspace] openURL:url];
                                         }
                                     browserAuth:NO];
}

- (IBAction)linkBrowserButtonPressed:(id)sender {
  [DropboxClientsManager authorizeFromControllerDesktop:[NSWorkspace sharedWorkspace]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[NSWorkspace sharedWorkspace] openURL:url];
                                         }
                                     browserAuth:YES];
}

- (IBAction)runTestsButtonPressed:(id)sender {
  TestData *data = [TestData new];
  DropboxTester *tester = [[DropboxTester alloc] initWithTestData:data];
  DropboxTeamTester *teamTester = [[DropboxTeamTester alloc] initWithTestData:data];
  
  void (^unlink)() = ^{
    [TestFormat printAllTestsEnd];
    [DropboxClientsManager unlinkClients];
    [self checkButtons];
  };
  
  switch (appPermission) {
    case FullDropbox:
      [tester testAllUserAPIEndpoints:tester nextTest:unlink asMember:NO];
      break;
    case TeamMemberFileAccess:
      [teamTester testAllTeamMemberFileAcessActions:unlink];
      break;
    case TeamMemberManagement:
      [teamTester testAllTeamMemberManagementActions:unlink];
      break;
  }
}

- (IBAction)unlinkButtonPressed:(id)sender {
  [DropboxClientsManager unlinkClients];
  [self checkButtons];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)viewWillAppear {
  [self checkButtons];
}

- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];

  // Update the view, if already loaded.
}

- (void)checkButtons {
  if ([DropboxClientsManager authorizedClient] != nil || [DropboxClientsManager authorizedTeamClient] != nil) {
    if ([DropboxClientsManager authorizedClient].transportClient.accessToken != nil ||
        [DropboxClientsManager authorizedTeamClient].transportClient.accessToken != nil) {
      [_linkButton setEnabled:NO];
      [_linkBrowserButton setEnabled:NO];
      [_unlinkButton setEnabled:YES];
      [_runTestsButton setEnabled:YES];

      return;
    }
  }

  [_linkButton setEnabled:YES];
  [_linkBrowserButton setEnabled:YES];
  [_unlinkButton setEnabled:NO];
  [_runTestsButton setEnabled:NO];
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
 will need to call `[DropboxClientsManager setupWithAppKeyDesktop]` (or `[DropboxClientsManager setupWithTeamAppKeyDesktop]`) and
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
