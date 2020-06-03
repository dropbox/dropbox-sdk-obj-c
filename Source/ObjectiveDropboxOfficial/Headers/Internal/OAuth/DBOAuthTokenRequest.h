///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>
#import "DBOAuthResultCompletion.h"

NS_ASSUME_NONNULL_BEGIN

// Class that makes a network request to exchange an access token with auth code.
@interface DBOAuthTokenExchangeRequest : NSObject

- (instancetype)init NS_UNAVAILABLE;

///
/// Designated Initializer.
///
/// @param oauthCode OAuth code to exchange an access token.
/// @param codeVerifier Code verifier generated for the auth flow.
/// @param appKey The app key of the API app.
/// @param locale User's locale.
/// @param redirectUri Redirect uri used in the auth flow.
- (instancetype)initWithOAuthCode:(NSString *)oauthCode
                     codeVerifier:(NSString *)codeVerifier
                           appKey:(NSString *)appKey
                           locale:(NSString *)locale
                      redirectUri:(NSString *)redirectUri NS_DESIGNATED_INITIALIZER;

/// Convenience method for `startWithCompletion:queue` with queue set to the main queue.
- (void)startWithCompletion:(DBOAuthCompletion)completion;

/// Sets completion block and starts the request.
///
/// @param completion Completion block to pass back oauth result.
/// @param queue The queue where the completion block will be called from.
- (void)startWithCompletion:(DBOAuthCompletion)completion queue:(dispatch_queue_t)queue;

/// Cancels started request.
- (void)cancel;

@end

NS_ASSUME_NONNULL_END
