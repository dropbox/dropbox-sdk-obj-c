//
//  ViewController.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ApiAppPermissionType) {
  FullDropbox,
  TeamMemberFileAccess,
  TeamMemberManagement,
};

/// Toggle this variable depending on which set of tests you are running.
static ApiAppPermissionType appPermission = (ApiAppPermissionType)TeamMemberFileAccess;

@interface ViewController : UIViewController

- (void)checkButtons;

@end
