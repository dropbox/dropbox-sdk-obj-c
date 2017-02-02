///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "TargetConditionals.h"

#import "DBSDKImportsShared.h"

#if TARGET_OS_IPHONE
#import "DBSDKImports-iOS.h"
#elif TARGET_OS_MAC
#import "DBSDKImports-macOS.h"
#endif
