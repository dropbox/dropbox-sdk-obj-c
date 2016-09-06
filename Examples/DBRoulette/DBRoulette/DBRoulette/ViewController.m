//
//  ViewController.m
//  DBRoulette
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "ViewController.h"
#import "DropboxSDKImports.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *linkDropboxButton;

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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
