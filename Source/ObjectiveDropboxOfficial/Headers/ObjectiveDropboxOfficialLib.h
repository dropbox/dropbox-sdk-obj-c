///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "TargetConditionals.h"

#import "DropboxSDKImportsShared.h"

#if TARGET_OS_IPHONE
#import "DropboxSDKImports-iOS.h"
#elif TARGET_OS_MAC
#import "DropboxSDKImports-macOS.h"
#endif
