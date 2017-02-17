//
//  ViewController.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBOpenWithInfo;

@interface ViewController : UIViewController

- (void)checkButtons;

- (void)setOpenWithInfoNSURL:(DBOpenWithInfo * _Nonnull)openWithInfoNSURL;

@end
