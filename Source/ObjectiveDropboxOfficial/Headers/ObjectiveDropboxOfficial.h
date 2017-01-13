//
//  ObjectiveDropboxOfficial.h
//  ObjectiveDropboxOfficial
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <Cocoa/Cocoa.h>
#endif

//! Project version number for ObjectiveDropboxOfficial.
FOUNDATION_EXPORT double ObjectiveDropboxOfficialVersionNumber;

//! Project version string for ObjectiveDropboxOfficial.
FOUNDATION_EXPORT const unsigned char ObjectiveDropboxOfficialVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import
// <ObjectiveDropboxOfficial/PublicHeader.h>

#import <ObjectiveDropboxOfficial/DropboxSDKImportsShared.h>

#if TARGET_OS_IPHONE
#import <ObjectiveDropboxOfficial/DropboxSDKImports-iOS.h>
#elif TARGET_OS_MAC
#import <ObjectiveDropboxOfficial/DropboxSDKImports-macOS.h>
#endif
