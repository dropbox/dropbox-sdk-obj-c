//
//  ViewController.m
//  DBRoulette
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "PhotoViewController.h"
#import "ViewController.h"

@interface ViewController ()

@property(weak, nonatomic) IBOutlet UIButton *linkDropboxButton;
@property(weak, nonatomic) IBOutlet UIButton *unlinkDropboxButton;
@property(nonatomic) UIBarButtonItem *oldButton;

@end

@implementation ViewController

- (IBAction)linkDropboxButtonPressed:(id)sender {
  [DropboxClientsManager authorizeFromController:[UIApplication sharedApplication]
                                      controller:self
                                         openURL:^(NSURL *url) {
                                           [[UIApplication sharedApplication] openURL:url];
                                         }
                                     browserAuth:NO];
}

- (IBAction)unlinkDropboxButtonPressed:(id)sender {
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
  
  if (_authSuccessful) {
    _authSuccessful = NO;
    
    [self presentPhotoViewController];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)checkButtons {
  if ([DropboxClientsManager authorizedClient] != nil || [DropboxClientsManager authorizedTeamClient] != nil) {
    if (_oldButton) {
      self.navigationItem.rightBarButtonItem = _oldButton;
    }
    _linkDropboxButton.hidden = YES;
    _unlinkDropboxButton.hidden = NO;
  } else {
    _oldButton = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = nil;
    _linkDropboxButton.hidden = NO;
    _unlinkDropboxButton.hidden = YES;
  }
}

- (void)presentPhotoViewController {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  PhotoViewController *photoViewController =
  (PhotoViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
  [self.navigationController pushViewController:photoViewController animated:NO];
}

@end
