///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///
/// Umbrella import for importing as a library
///

#import <TargetConditionals.h>

#import <ObjectiveDropboxOfficial/DBSDKImportsShared.h>

#if TARGET_OS_IPHONE
#import <ObjectiveDropboxOfficial/DBSDKImports-iOS.h>
#elif TARGET_OS_MAC
#import <ObjectiveDropboxOfficial/DBSDKImports-macOS.h>
#endif
