///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "TargetConditionals.h"

#if TARGET_OS_IPHONE

#import <Foundation/Foundation.h>

#import "DBOAuthManager.h"

@protocol DBSharedApplication;

#pragma mark - OAuth manager base (iOS)

///
/// Platform-specific (iOS) manager for performing OAuth linking.
///
@interface DBOAuthMobileManager : DBOAuthManager

@end

#endif // TARGET_OS_IPHONE
