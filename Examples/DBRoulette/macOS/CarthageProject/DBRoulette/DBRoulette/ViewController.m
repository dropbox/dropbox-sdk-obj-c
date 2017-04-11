//
//  ViewController.m
//  DBRoulette
//
//  Created by Stephen Cobbe on 2/27/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "PhotoViewController.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet NSButton *linkButton;
@property (weak) IBOutlet NSButton *unlinkButton;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}


- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
  // Update the view, if already loaded.
}

- (IBAction)linkButtonPressed:(id)sender {
  [DBClientsManager authorizeFromControllerDesktop:[NSWorkspace sharedWorkspace]
                                        controller:self
                                           openURL:^(NSURL *url){ [[NSWorkspace sharedWorkspace] openURL:url]; }];
}

- (IBAction)unlinkButtonPressed:(id)sender {
  [DBClientsManager unlinkAndResetClients];
  [self checkAllButtons];
}

- (void)checkButtons {
  if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
    [_linkButton setEnabled:NO];
    [_unlinkButton setEnabled:YES];
  } else {
    [_linkButton setEnabled:YES];
    [_unlinkButton setEnabled:NO];
  }
}

- (void)checkAllButtons {
  NSTabViewController *  tabViewController =
      (NSTabViewController *)[[[NSApplication sharedApplication] windows] objectAtIndex:0].contentViewController;
  [tabViewController.childViewControllers[0] checkButtons];
  [tabViewController.childViewControllers[1] checkButtons];
}

@end
