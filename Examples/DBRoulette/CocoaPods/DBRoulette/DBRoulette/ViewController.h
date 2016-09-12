//
//  ViewController.h
//  DBRoulette
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL showPhotoView = NO;

@interface ViewController : UIViewController

@property (nonatomic) BOOL authSuccessful;

- (void)checkButtons;

@end
