///
/// Code with platform-specific (here, OSX) dependencies. Renders OAuth flow.
///

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DBXOAuth.h"
#import "DBXSharedApplicationProtocol.h"

@interface DBXDesktopSharedApplication : NSObject <DBXSharedApplication>

- (nonnull instancetype)init:(NSWorkspace * _Nonnull)sharedApplication controller:(NSViewController * _Nonnull)controller openURL:(void(^_Nonnull)(NSURL * _Nonnull))openURL;

@end

@interface DBXWebViewController : NSViewController <NSWindowDelegate, WKNavigationDelegate>

- (nonnull instancetype)init:(NSURL * _Nonnull)url tryInterceptHandler:(BOOL (^ _Nonnull)(NSURL * _Nonnull))tryInterceptHandler cancelHandler:(void (^ _Nonnull)(void))cancel;

@end