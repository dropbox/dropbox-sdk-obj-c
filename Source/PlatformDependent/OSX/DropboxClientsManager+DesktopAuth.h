///
/// Code with platform-specific (here, iOS) dependencies. Extends logic for the `DropboxClientsManager` class.
///

#import <Foundation/Foundation.h>
#import "DropboxClientsManager.h"
@class DBXTransportClient;
@class NSWorkspace;
@class NSViewController;

@interface DropboxClientsManager (DesktopAuth)

+ (void)authorizeFromController:(NSWorkspace * _Nonnull)sharedApplication controller:(NSViewController * _Nonnull)controller openURL:(void (^_Nonnull)(NSURL *))openURL browserAuth:(BOOL)browserAuth;

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey;

+ (void)setupWithAppKey:(NSString * _Nonnull)appKey transportClient:(DBXTransportClient * _Nonnull)transportClient;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey;

+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey transportClient:(DBXTransportClient * _Nonnull)transportClient;

@end