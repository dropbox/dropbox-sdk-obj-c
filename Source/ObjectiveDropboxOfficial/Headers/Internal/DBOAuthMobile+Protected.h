///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBLoadingStatusDelegate.h"
#import "DBOAuthMobile-iOS.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBMobileSharedApplication (Protected)

@property (nonatomic, readwrite, weak) id<DBLoadingStatusDelegate> loadingStatusDelegate;

@end

NS_ASSUME_NONNULL_END
