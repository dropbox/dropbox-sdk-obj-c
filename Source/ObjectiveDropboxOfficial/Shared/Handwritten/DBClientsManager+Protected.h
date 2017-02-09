///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBClientsManager.h"

@class DBOAuthManager;
@class DBTransportDefaultClient;

@interface DBClientsManager (Protected)

+ (void)setupWithOAuthManager:(DBOAuthManager * _Nonnull)oAuthManager
              transportClient:(DBTransportDefaultClient * _Nonnull)transportClient;

+ (void)setupWithOAuthManagerMultiUser:(DBOAuthManager * _Nonnull)oAuthManager
                       transportClient:(DBTransportDefaultClient * _Nonnull)transportClient
                              tokenUid:(NSString * _Nullable)tokenUid;

+ (void)setupWithOAuthManagerTeam:(DBOAuthManager * _Nonnull)oAuthManager
                  transportClient:(DBTransportDefaultClient * _Nonnull)transportClient;

+ (void)setupWithOAuthManagerMultiUserTeam:(DBOAuthManager * _Nonnull)oAuthManager
                           transportClient:(DBTransportDefaultClient * _Nonnull)transportClient
                                  tokenUid:(NSString * _Nullable)tokenUid;

+ (void)setAppKey:(NSString * _Nonnull)currentAppKey;

@end
