///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

@interface DBTransportClientBase : NSObject

- (nonnull instancetype)init:(NSString * _Nullable)selectUser
                   userAgent:(NSString * _Nonnull)userAgent
                      appKey:(NSString * _Nullable)appKey
                   appSecret:(NSString * _Nullable)appSecret;

@property (nonatomic, readonly, copy) NSString * _Nonnull userAgent;
@property (nonatomic, readonly, copy) NSString * _Nullable appKey;
@property (nonatomic, readonly, copy) NSString * _Nullable appSecret;

/// An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of
/// a team member.
@property (nonatomic, readonly, copy) NSString * _Nullable selectUser;

@end
