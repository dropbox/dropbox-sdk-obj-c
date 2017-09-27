///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///
/// Configuration class for `DBTransportBaseClient`.
///
@interface DBTransportBaseConfig : NSObject

/// The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key is used for
/// querying endpoints the have "app auth" authentication type.
@property (nonatomic, readonly, copy, nullable) NSString *appKey;

/// The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app key is used for
/// querying endpoints the have "app auth" authentication type.
@property (nonatomic, readonly, copy, nullable) NSString *appSecret;

/// The hostname used for oauth networking requests. Leave as nil to use the default, otherwise can be set to a custom
///  value for debugging purposes.
@property (nonatomic, readonly, copy, nullable) NSString *hostname;

/// The user agent associated with all networking requests. Used for server logging.
@property (nonatomic, readonly, copy, nullable) NSString *userAgent;

/// An additional authentication header field used when a team app with the appropriate permissions "performs" user API
/// actions on behalf of a team member.
@property (nonatomic, readonly, copy, nullable) NSString *asMemberId;

/// Additional HTTP headers to be injected into each client request.
@property (nonatomic, readonly, copy, nullable) NSDictionary<NSString *, NSString *> *additionalHeaders;

///
/// Convenience constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppKey:(nullable NSString *)appKey userAgent:(nullable NSString *)userAgent;

///
/// Convenience constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppKey:(nullable NSString *)appKey
                     appSecret:(nullable NSString *)appSecret
                     userAgent:(nullable NSString *)userAgent;

///
/// Convenience constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
/// @param asMemberId An additional authentication header field used when a team app with the appropriate permissions
/// "performs" user API actions on behalf of a team member.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppKey:(nullable NSString *)appKey
                     appSecret:(nullable NSString *)appSecret
                     userAgent:(nullable NSString *)userAgent
                    asMemberId:(nullable NSString *)asMemberId;

///
/// Full constructor.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
/// @param asMemberId An additional authentication header field used when a team app with the appropriate permissions
/// "performs" user API actions on behalf of a team member.
/// @param additionalHeaders Additional HTTP headers to be injected into each client request.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppKey:(nullable NSString *)appKey
                     appSecret:(nullable NSString *)appSecret
                     userAgent:(nullable NSString *)userAgent
                    asMemberId:(nullable NSString *)asMemberId
             additionalHeaders:(nullable NSDictionary<NSString *, NSString *> *)additionalHeaders;

///
/// Full constructor, with debug hostname override.
///
/// @param appKey The consumer app key associated with the app that is integrating with the Dropbox API. Here, app key
/// is used for querying endpoints the have "app auth" authentication type.
/// @param appSecret The consumer app secret associated with the app that is integrating with the Dropbox API. Here, app
/// key is used for querying endpoints the have "app auth" authentication type.
/// @param hostname A custom hostname to use for networking requests. Only useful for debugging purposes and only
/// affects the oauth flows at this time.
/// @param userAgent The user agent associated with all networking requests. Used for server logging.
/// @param asMemberId An additional authentication header field used when a team app with the appropriate permissions
/// "performs" user API actions on behalf of a team member.
/// @param additionalHeaders Additional HTTP headers to be injected into each client request.
///
/// @return An initialized instance.
///
- (instancetype)initWithAppKey:(nullable NSString *)appKey
                     appSecret:(nullable NSString *)appSecret
                      hostname:(nullable NSString *)hostname
                     userAgent:(nullable NSString *)userAgent
                    asMemberId:(nullable NSString *)asMemberId
             additionalHeaders:(nullable NSDictionary<NSString *, NSString *> *)additionalHeaders;

@end

NS_ASSUME_NONNULL_END
