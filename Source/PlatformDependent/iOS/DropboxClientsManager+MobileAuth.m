#import <UIKit/UIKit.h>
#import "DbxOAuth.h"
#import "DbxOAuthMobile.h"
#import "DropboxClientsManager.h"

@interface DropboxClientsManager ()

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DbxOAuthManager * _Nonnull)sharedOAuthManager;
    
+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DbxOAuthManager * _Nonnull)sharedOAuthManager;

@end


@implementation DropboxClientsManager (PlatformAuth)

+ (void)authorizeFromController:(UIApplication *)sharedApplication controller:(UIViewController *)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth {
    NSAssert([DbxOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil, @"A Dropbox client is already authorized");
    DbxMobileSharedApplication *sharedMobileApplication = [[DbxMobileSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
    [[DbxOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedMobileApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DbxMobileOAuthManager alloc] init:appKey]];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DbxMobileOAuthManager alloc] init:appKey]];
}

@end
