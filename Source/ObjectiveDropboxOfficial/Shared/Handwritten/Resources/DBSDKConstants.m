///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

/// Constants for the SDK should go here.

#import <Foundation/Foundation.h>

#import "DBSDKConstants.h"

NSString *const kDBXSDKVersion = @"3.10.0";
NSString *const kDBXSDKDefaultUserAgentPrefix = @"OfficialDropboxObjCSDKv2";
NSString *const kDBXSDKForegroundSessionId = @"com.dropbox.dropbox_sdk_obj_c_foreground";
NSString *const kDBXSDKBackgroundSessionId = @"com.dropbox.dropbox_sdk_obj_c_background";

// BEGIN DEBUG CONSTANTS
BOOL const kDBXSDKDebug = NO;           // Should never be `YES` in production
NSString *const kDBXSDKDebugHost = nil; // `"dbdev"`, if using EC, or "{user_name}-dbx"`, if dev box.
                                     // Should never be non-`nil` in production.
// END DEBUG CONSTANTS

NSString *const kDBXSDKCSERFKey = @"kDBXSDKCSERFKeyObjCSDK";
