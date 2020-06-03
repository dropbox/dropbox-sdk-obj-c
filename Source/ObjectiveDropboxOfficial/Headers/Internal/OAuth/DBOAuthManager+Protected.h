///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBOAuthManager.h"
#import "DBOAuthResultCompletion.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBOAuthManager (Protected)

/// Extracts auth result from the url.
/// @param url The redirect url which may contain auth result data.
/// @param completion The completion block to pass back auth result.
- (void)extractAuthResultFromRedirectURL:(NSURL *)url completion:(DBOAuthCompletion)completion;

/// Completes the last step of OAuth code flow to exchange an access token with auth code.
/// @param authCode OAuth code from auth response.
/// @param codeVerifier Code verifier generated for the auth flow.
- (void)finishPkceOAuthWithAuthCode:(NSString *)authCode
                       codeVerifier:(NSString *)codeVerifier
                         completion:(DBOAuthCompletion)completion;

@end

NS_ASSUME_NONNULL_END
