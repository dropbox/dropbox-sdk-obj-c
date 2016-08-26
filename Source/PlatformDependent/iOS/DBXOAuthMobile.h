///
/// Code with platform-specific (here, iOS) dependencies. Renders OAuth flow.
///

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DBXOAuth.h"
#import "DBXSharedApplicationProtocol.h"

@interface DBXMobileSharedApplication : NSObject <DBXSharedApplication>  {
@protected
    UIApplication * _Nullable _sharedApplication;
    UIViewController * _Nullable _controller;
    void (^_openURL)(NSURL * _Nullable);
}

- (nonnull instancetype)init:(UIApplication * _Nonnull)sharedApplication controller:(UIViewController * _Nonnull)controller openURL:(void(^_Nonnull)(NSURL * _Nonnull))openURL;

@end


@interface DBXWebViewController : UIViewController <WKNavigationDelegate> {
@protected
    WKWebView * _Nullable _webView;
    void (^_Nullable _onWillDismiss)(BOOL);
    BOOL (^_Nullable _tryInterceptHandler)(NSURL * _Nullable);
    NSURL * _Nullable _startURL;
    
    UIBarButtonItem * _Nullable _cancelButton;
    void (^_Nullable _cancelHandler)(void);
    UIActivityIndicatorView * _Nullable _indicator;
}

- (nonnull instancetype)init:(NSURL * _Nonnull)url tryInterceptHandler:(BOOL (^ _Nonnull)(NSURL * _Nonnull))tryInterceptHandler cancelHandler:(void (^ _Nonnull)(void))cancel;

@end