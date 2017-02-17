///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBTransportBaseConfig.h"

///
/// Configuration class for `DBTransportDefaultClient`.
///
@interface DBTransportDefaultConfig : DBTransportBaseConfig

/// A serial delegate queue used for executing blocks of code that touch state shared across threads (mainly the request
/// handlers storage).
@property (nonatomic, readonly) NSOperationQueue * _Nonnull delegateQueue;

/// If set to true, all network requests are made on foreground sessions (by default, most upload/download operations
/// are performed with a background session). This is appropriate for use cases where file upload / download operations
/// will be quick, and immediate response is preferable. Otherwise, for background sessions, uploads/downloads will
/// essentially never time out, if network connection is lost after the request has begun.
@property (nonatomic, readonly) BOOL forceForegroundSession;

///
/// Convenience constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey;

///
/// Convenience constructor.
///
/// Appropriate for apps that want to query endpoints with "app auth" authentication type.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey appSecret:(NSString * _Nonnull)appSecret;

///
/// Convenience constructor.
///
/// Appropriate for use cases where file upload / download operations will be quick, and immediate response is
/// preferable. Otherwise, for background sessions, uploads/downloads will essentially never time out, if network
/// connection is lost after the request has begun.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param forceForegroundSession If set to true, all network requests are made on foreground sessions (by default, most
/// upload/download operations are performed with a background session).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey forceForegroundSession:(BOOL)forceForegroundSession;

///
/// Convenience constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
/// @param delegateQueue A serial delegate queue used for executing blocks of code that touch state shared across
/// threads (mainly the request handlers storage).
/// @param forceForegroundSession If set to true, all network requests are made on foreground sessions (by default, most
/// upload/download operations are performed with a background session).
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey
                             appSecret:(NSString * _Nullable)appSecret
                             userAgent:(NSString * _Nullable)userAgent
                         delegateQueue:(NSOperationQueue * _Nullable)delegateQueue
                forceForegroundSession:(BOOL)forceForegroundSession;

///
/// Full constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
/// @param delegateQueue A serial delegate queue used for executing blocks of code that touch state shared across
/// threads (mainly the request handlers storage).
/// @param forceForegroundSession If set to true, all network requests are made on foreground sessions (by default, most
/// upload/download operations are performed with a background session).
/// @param asMemberId An additional authentication header field used when a team app with the appropriate permissions
/// "performs" user API actions on behalf of a team member.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey
                             appSecret:(NSString * _Nullable)appSecret
                             userAgent:(NSString * _Nullable)userAgent
                            asMemberId:(NSString * _Nullable)asMemberId
                         delegateQueue:(NSOperationQueue * _Nullable)delegateQueue
                forceForegroundSession:(BOOL)forceForegroundSession;

@end
