///
/// Code with platform-specific (here, iOS) dependencies. Extends logic for the `DropboxClientsManager` class.
///

#import <Foundation/Foundation.h>
#import "DropboxClientsManager.h"
@class DBXTransportClient;
@class UIApplication;
@class UIViewController;

@interface DropboxClientsManager (MobileAuth)

+ (void)authorizeFromController:(UIApplication * _Nonnull)sharedApplication controller:(UIViewController * _Nonnull)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth;

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey;

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey transportClient:(DBXTransportClient * _Nonnull)transportClient;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey transportClient:(DBXTransportClient * _Nonnull)transportClient;

@end