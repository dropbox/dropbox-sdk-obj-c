///
/// Code with platform-specific (here, iOS) dependencies. Extends logic for the `DropboxClientsManager` class.
///

#import <AppKit/AppKit.h>
#import "DBXOAuth.h"
#import "DBXOAuthDesktop.h"
#import "DBXTransportClient.h"
#import "DropboxClientsManager.h"

@interface DropboxClientsManager ()

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedOAuthManager transportClient:(DBXTransportClient * _Nullable)transportClient;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedOAuthManager transportClient:(DBXTransportClient * _Nullable)transportClient;

@end


@implementation DropboxClientsManager (DesktopAuth)

+ (void)authorizeFromController:(NSWorkspace *)sharedApplication controller:(NSViewController *)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth {
    NSAssert([DBXOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil, @"A Dropbox client is already authorized");
    DBXDesktopSharedApplication *sharedDesktopApplication = [[DBXDesktopSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
    [[DBXOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedDesktopApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:nil];
}

+ (void)setupWithAppKey:(NSString *)appKey transportClient:(DBXTransportClient *)transportClient {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:transportClient];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:nil];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey transportClient:(DBXTransportClient *)transportClient {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] initWithAppKey:appKey] transportClient:transportClient];
}

@end
