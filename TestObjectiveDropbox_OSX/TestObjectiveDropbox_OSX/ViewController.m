//
//  ViewController.m
//  TestObjectiveDropbox_OSX
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "ViewController.h"

#import "DropboxClientsManager+DesktopAuth.h"

@interface ViewController ()

@property (weak) IBOutlet NSButtonCell *linkButton;
@property (weak) IBOutlet NSButtonCell *linkBrowserButton;
@property (weak) IBOutlet NSButtonCell *runTestsButton;
@property (weak) IBOutlet NSButtonCell *unlinkButton;

@end


@implementation ViewController

- (IBAction)linkButtonPressed:(id)sender {
    [DropboxClientsManager authorizeFromController:[NSWorkspace sharedWorkspace] controller:self openURL:^(NSURL *url){ [[NSWorkspace sharedWorkspace] openURL:url]; } browserAuth:NO];
}

- (IBAction)linkBrowserButtonPressed:(id)sender {
    [DropboxClientsManager authorizeFromController:[NSWorkspace sharedWorkspace] controller:self openURL:^(NSURL *url){ [[NSWorkspace sharedWorkspace] openURL:url]; } browserAuth:YES];
}

- (IBAction)runTestsButtonPressed:(id)sender {
}

- (IBAction)unlinkButtonPressed:(id)sender {
    [DropboxClientsManager unlinkClients];
    [self checkButtons];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear {
    [self checkButtons];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)checkButtons {
    if ([DropboxClientsManager authorizedClient] != nil || [DropboxClientsManager authorizedTeamClient] != nil) {
        [_linkButton setEnabled:NO];
        [_linkBrowserButton setEnabled:NO];
        [_unlinkButton setEnabled:YES];
        [_runTestsButton setEnabled:YES];
    } else {
        [_linkButton setEnabled:YES];
        [_linkBrowserButton setEnabled:YES];
        [_unlinkButton setEnabled:NO];
        [_runTestsButton setEnabled:NO];
    }
}

@end
