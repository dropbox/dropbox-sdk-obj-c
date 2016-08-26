#import <UIKit/UIKit.h>
#import "DBXOAuth.h"
#import "DBXOAuthMobile.h"
#import "DropboxClientsManager.h"

@interface DropboxClientsManager ()

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedOAuthManager;
    
+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey sharedOAuthManager:(DBXOAuthManager * _Nonnull)sharedOAuthManager;

@end


@implementation DropboxClientsManager (PlatformAuth)

+ (void)authorizeFromController:(UIApplication *)sharedApplication controller:(UIViewController *)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth {
    NSAssert([DBXOAuthManager sharedOAuthManager] != nil, @"Call `Dropbox.setupWithAppKey` or `Dropbox.setupWithTeamAppKey` before calling this method");
    NSAssert([DropboxClientsManager authorizedClient] == nil && [DropboxClientsManager authorizedTeamClient] == nil, @"A Dropbox client is already authorized");
    DBXMobileSharedApplication *sharedMobileApplication = [[DBXMobileSharedApplication alloc] init:sharedApplication controller:controller openURL:openURL];
    [[DBXOAuthManager sharedOAuthManager] authorizeFromSharedApplication:sharedMobileApplication browserAuth:browserAuth];
}

+ (void)setupWithAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] init:appKey]];
}

+ (void)setupWithTeamAppKey:(NSString *)appKey {
    [DropboxClientsManager setupWithTeamAppKey:appKey sharedOAuthManager:[[DBXMobileOAuthManager alloc] init:appKey]];
}

@end
