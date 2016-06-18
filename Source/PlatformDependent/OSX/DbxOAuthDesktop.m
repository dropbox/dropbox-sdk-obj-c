///
/// Code with platform-specific (here, OSX) dependencies. Renders OAuth flow.
///

#import <AppKit/AppKit.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DbxOAuth.h"
#import "DbxOAuthDesktop.h"

@implementation DbxDesktopSharedApplication

- (instancetype)init:(NSWorkspace *)sharedWorkspace controller:(NSViewController *)controller openURL:(void(^)(NSURL *))openURL {
    self = [super init];
    if (self) {
        // fields saved for app-extension safety
        _sharedWorkspace = sharedWorkspace;
        _controller = controller;
        _openURL = openURL;
    }
    return self;
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title {
    NSError *error = [[NSError alloc] initWithDomain:@"" code:123 userInfo:@{NSLocalizedDescriptionKey: message}];
    [_controller presentError:error];
}

- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message title:(NSString * _Nonnull)title buttonHandlers:(NSDictionary <NSString *, void (^)()> * _Nonnull)buttonHandlers {
    [self presentErrorMessage:message title:title];
}

- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL {
    // no platform-specific auth methods for OS X
    return NO;
}

- (void)presentWebViewAuth:(NSURL * _Nonnull)authURL tryIntercept:(BOOL (^_Nonnull)(NSURL * _Nonnull))tryIntercept cancelHandler:(void (^_Nonnull)(void))cancelHandler {
    DbxWebViewController *webViewController = [[DbxWebViewController alloc] init:authURL tryIntercept:tryIntercept cancelHandler:cancelHandler];
    [_controller presentViewControllerAsModalWindow:webViewController];
}

- (void)presentBrowserAuth:(NSURL * _Nonnull)authURL {
    [self presentExternalApp:authURL];
}

- (void)presentExternalApp:(NSURL * _Nonnull)url {
    _openURL(url);
}

- (BOOL)canPresentExternalApp:(NSURL * _Nonnull)url {
    return YES;
}

@end


@implementation DbxWebViewController

- (instancetype)init {
    return [super initWithNibName: nil bundle:nil];
}

- (instancetype)init:(NSCoder *)coder {
    return [super initWithCoder:coder];
}

- (instancetype)init:(NSURL *)URL tryIntercept:(BOOL (^)(NSURL *))tryIntercept cancelHandler:(void (^)(void))cancelHandler {
    self = [super initWithNibName: nil bundle:nil];
    if (self) {
        _tryIntercept = tryIntercept;
        _cancelHandler = cancelHandler;
        _indicator = [[NSProgressIndicator alloc] init];
        [_indicator setFrame:NSMakeRect(20, 20, 30, 30)];
        [_indicator setStyle:NSProgressIndicatorSpinningStyle];
        _startURL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Link to Dropbox";
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    [_indicator setFrameOrigin:NSMakePoint((NSWidth(_webView.bounds) - NSWidth(_indicator.frame)) / 2,
                                           (NSHeight(_webView.bounds) - NSHeight(_indicator.frame)) / 2)];
    
    [_webView addSubview:_indicator];
    [_indicator startAnimation:self];
    
    [self.view addSubview:_webView];
    
    [_webView addSubview:_indicator];
    [_indicator startAnimation:self];
    
    [self.view addSubview:_webView];
    _webView.navigationDelegate = self;
    _webView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    if (self.view.window != nil) {
        self.view.window.delegate = self;
    }
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    if (![_webView canGoBack]) {
        if (_startURL != nil) {
            [self loadURL:_startURL];
        }
        else {
            [_webView loadHTMLString:@"There is no `startURL`" baseURL:nil];
        }
    }
}

- (BOOL)windowShouldClose:(id)sender {
    _cancelHandler();
    return YES;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.request.URL != nil && _tryIntercept != nil) {
        if (_tryIntercept(navigationAction.request.URL)) {
            [self dismiss:YES];
            return decisionHandler((WKNavigationActionPolicy)WKNavigationActionPolicyCancel);
        }
    }
    return decisionHandler((WKNavigationActionPolicy)WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [_indicator stopAnimation:self];
    [_indicator removeFromSuperview];
}

- (void)loadView {
    self.view = [[NSView alloc] init];
    self.view.frame = NSMakeRect(0, 0, 800, 600);
}

- (void)loadURL:(NSURL *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)goBack:(id)sender {
    [_webView goBack];
}

- (void)cancel:(id)sender {
    [self dismiss:YES animated:(sender != nil)];
    _cancelHandler();
}

- (void)dismiss:(BOOL)animated {
    [self dismiss:NO animated:animated];
}

- (void)dismiss:(BOOL)asCancel animated:(BOOL)animated {
    [_webView stopLoading];
    [self dismissController:nil];
}

@end
