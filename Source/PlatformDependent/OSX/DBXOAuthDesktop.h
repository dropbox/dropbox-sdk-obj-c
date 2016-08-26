///
/// Code with platform-specific (here, OSX) dependencies. Renders OAuth flow.
///

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DBXOAuth.h"

@interface DBXDesktopSharedApplication : NSObject <DBXSharedApplication>  {
@protected
    NSWorkspace * _Nullable _sharedWorkspace;
    NSViewController * _Nullable _controller;
    void (^_openURL)(NSURL * _Nullable);
}

- (nonnull instancetype)init:(NSWorkspace * _Nonnull)sharedApplication controller:(NSViewController * _Nonnull)controller openURL:(void(^_Nonnull)(NSURL * _Nonnull))openURL;

@end

@interface DBXWebViewController : NSViewController <NSWindowDelegate, WKNavigationDelegate> {
@protected
    WKWebView * _Nullable _webView;
    BOOL (^_Nullable _tryIntercept)(NSURL * _Nullable);
    void (^_Nullable _cancelHandler)(void);
    NSProgressIndicator * _Nullable _indicator;
    NSURL * _Nullable _startURL;
}

- (nonnull instancetype)init:(NSURL * _Nonnull)url tryIntercept:(BOOL (^ _Nonnull)(NSURL * _Nonnull))tryIntercept cancelHandler:(void (^ _Nonnull)(void))cancel;

@end