///
/// Code with platform-specific (here, iOS) dependencies. Renders OAuth flow.
///

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "DbxOAuth.h"
#import "DbxOAuthMobile.h"

@implementation DbxMobileSharedApplication

- (instancetype)init:(UIApplication *)sharedApplication controller:(UIViewController *)controller openURL:(void(^)(NSURL *))openURL {
    self = [super init];
    if (self) {
        // fields saved for app-extension safety
        _sharedApplication = sharedApplication;
        _controller = controller;
        _openURL = openURL;
    }
    return self;
}

- (void)presentErrorMessage:(NSString *)message title:(NSString *)title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    [_controller presentViewController:alertController animated:YES completion:^{[NSException raise:@"FatalError" format:@"%@", message];}];
}

- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message title:(NSString * _Nonnull)title buttonHandlers:(NSDictionary <NSString *, void (^)()> * _Nonnull)buttonHandlers {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:(UIAlertActionStyle)UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Retry" style:(UIAlertActionStyle)UIAlertActionStyleDefault handler:^(UIAlertAction *action) {buttonHandlers[@"Retry"]();}]];

    [_controller presentViewController:alertController animated:YES completion:^{}];
}

- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL {
    [self presentExternalApp:authURL];
    return YES;
}

- (void)presentWebViewAuth:(NSURL * _Nonnull)authURL tryIntercept:(BOOL (^_Nonnull)(NSURL * _Nonnull))tryIntercept cancelHandler:(void (^_Nonnull)(void))cancelHandler {
    DbxWebViewController *webViewController = [[DbxWebViewController alloc] init:authURL tryIntercept:tryIntercept cancelHandler:cancelHandler];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];

    [_controller presentViewController:navigationController animated:YES completion:^{}];
}

- (void)presentBrowserAuth:(NSURL * _Nonnull)authURL {
    [self presentExternalApp:authURL];
}

- (void)presentExternalApp:(NSURL * _Nonnull)url {
    _openURL(url);
}

- (BOOL)canPresentExternalApp:(NSURL * _Nonnull)url {
    return [_sharedApplication canOpenURL:url];
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
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)UIActivityIndicatorViewStyleGray];
        _startURL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Link to Dropbox";
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
    
    _indicator.center = self.view.center;
    [_webView addSubview:_indicator];
    [_indicator startAnimating];
    
    [self.view addSubview:_webView];
    
    _webView.navigationDelegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = _cancelButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![_webView canGoBack]) {
        if (_startURL != nil) {
            [self loadURL:_startURL];
        }
        else {
            [_webView loadHTMLString:@"There is no `startURL`" baseURL:nil];
        }
    }
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
    [_indicator stopAnimating];
    [_indicator removeFromSuperview];
}

- (void)loadURL:(NSURL *)url {
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)showHideBackButton:(BOOL)show {
    if (show) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItem)UIBarButtonSystemItemRewind target:self action:@selector(goBack:)];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
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
    
    if (_onWillDismiss != nil) {
        _onWillDismiss(asCancel);
    }
    if (self.presentingViewController != nil) {
        [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
    }
}

@end
