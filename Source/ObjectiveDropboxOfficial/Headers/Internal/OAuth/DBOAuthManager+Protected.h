///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBOAuthManager.h"

@interface DBOAuthManager (Protected)

- (DBOAuthResult * _Nonnull)extractFromRedirectURL:(NSURL * _Nonnull)url;

@end
