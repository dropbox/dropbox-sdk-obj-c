///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBLoadingStatusDelegate.h"
#import "DBOAuthDesktop-MacOS.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBDesktopSharedApplication (Protected)

@property (nonatomic, readwrite, weak) id<DBLoadingStatusDelegate> loadingStatusDelegate;

@end

NS_ASSUME_NONNULL_END
