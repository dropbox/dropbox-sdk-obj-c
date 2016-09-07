//
//  ViewController.m
//  DBRoulette_Carthage
//
//  Created by Stephen Cobbe on 9/6/16.
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ViewController.h"

#import <ObjectiveDropboxOfficial/DropboxSDKImports.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  DropboxClient *client = [[DropboxClient alloc] initWithAccessToken:@"test"];
  NSLog(@"%@", client);
  
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
