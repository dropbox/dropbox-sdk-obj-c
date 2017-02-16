//
//  TestAppType.h
//  TestObjectiveDropbox
//
//  Created by Stephen Cobbe on 2/16/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ApiAppPermissionType) {
  FullDropbox,
  TeamMemberFileAccess,
  TeamMemberManagement,
};

/// Toggle this variable depending on which set of tests you are running.
static ApiAppPermissionType appPermission = (ApiAppPermissionType)FullDropbox;
