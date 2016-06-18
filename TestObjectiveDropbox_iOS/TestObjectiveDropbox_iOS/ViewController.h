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

static ApiAppPermissionType appPermission = (ApiAppPermissionType)FullDropbox;

@interface ViewController : UIViewController

- (void)checkButtons;

@end

