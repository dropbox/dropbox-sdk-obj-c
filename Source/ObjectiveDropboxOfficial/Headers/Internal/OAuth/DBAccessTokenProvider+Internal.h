///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import <ObjectiveDropboxOfficial/DBAccessTokenProvider.h>
#import <ObjectiveDropboxOfficial/DBOAuthManager.h>

NS_ASSUME_NONNULL_BEGIN

/// Wrapper for legacy long-lived access token.
@interface DBLongLivedAccessTokenProvider : NSObject <DBAccessTokenProvider>

- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer.
///
/// @param tokenString An access token string.
- (instancetype)initWithTokenString:(NSString *)tokenString NS_DESIGNATED_INITIALIZER;

@end

/// Wrapper for short-lived token.
@interface DBShortLivedAccessTokenProvider : NSObject <DBAccessTokenProvider>

- (instancetype)init NS_UNAVAILABLE;

/// Designated initializer.
///
/// @param token A `DBAccessToken` represents a short-lived token.
/// @param tokenRefresher Helper object that refreshes a token over network.
- (instancetype)initWithToken:(DBAccessToken *)token
               tokenRefresher:(id<DBAccessTokenRefreshing>)tokenRefresher NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
