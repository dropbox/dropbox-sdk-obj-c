///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <UIKit/UIKit.h>
#import "DBOAuth.h"
#import "DBOAuthMobile.h"
#import "DBTransportClient.h"
#import "DropboxClientsManager.h"

@interface DropboxClientsManager ()

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBOAuthManager * _Nonnull)sharedOAuthManager transportClient:(DBTransportClient * _Nullable)transportClient;
    
+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBOAuthManager * _Nonnull)sharedOAuthManager transportClient:(DBTransportClient * _Nullable)transportClient;

@end

@implementation DropboxClientsManager (MobileAuth)

+ (void)authorizeFromController:(UIApplication *)sharedApplication controller:(UIViewController *)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth {
    NSAssert([DBOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil, @"A Dropbox client is already authorized");
    DBMobileSharedApplication *sharedMobileApplication = [[DBMobileSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
    [[DBOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedMobileApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:nil];
}

+ (void)setupWithAppKey:(NSString *)appKey transportClient:(DBTransportClient *)transportClient {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:transportClient];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:nil];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey transportClient:(DBTransportClient *)transportClient {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DBMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:transportClient];
}

@end
