///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import <ObjectiveDropboxOfficial/DBOAuthManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface DBOAuthManager (Protected)

- (DBOAuthResult *)extractFromRedirectURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
