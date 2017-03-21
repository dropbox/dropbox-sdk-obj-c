///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuth.h"
#import "DBOAuthMobile-iOS.h"

#pragma mark - Shared application

@implementation DBMobileSharedApplication {
  UIApplication * _Nullable _sharedApplication;
  UIViewController * _Nullable _controller;
  void (^_openURL)(NSURL * _Nullable);
}

- (instancetype)initWithSharedApplication:(UIApplication *)sharedApplication
                               controller:(UIViewController *)controller
                                  openURL:(void (^)(NSURL *))openURL {
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
  if (_controller) {
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    [_controller presentViewController:alertController
                              animated:YES
                            completion:^{
                              [NSException raise:@"FatalError" format:@"%@", message];
                            }];
  }
}

- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message
                                  title:(NSString * _Nonnull)title
                         buttonHandlers:(NSDictionary<NSString *, void (^)()> * _Nonnull)buttonHandlers {
  UIAlertController *alertController =
      [UIAlertController alertControllerWithTitle:title
                                          message:message
                                   preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];

  [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                                      style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction *action) {
#pragma unused(action)
                                                      void (^handler)(void) = buttonHandlers[@"Cancel"];

                                                      if (handler != nil) {
                                                        handler();
                                                      }
                                                    }]];
  [alertController addAction:[UIAlertAction actionWithTitle:@"Retry"
                                                      style:(UIAlertActionStyle)UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction *action) {
#pragma unused(action)
                                                      void (^handler)(void) = buttonHandlers[@"Retry"];

                                                      if (handler != nil) {
                                                        handler();
                                                      }
                                                    }]];

  if (_controller) {
    [_controller presentViewController:alertController
                              animated:YES
                            completion:^{
                            }];
  }
}

- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL {
  [self presentExternalApp:authURL];
  return YES;
}

- (void)presentWebViewAuth:(NSURL * _Nonnull)authURL
       tryInterceptHandler:(BOOL (^_Nonnull)(NSURL * _Nonnull, BOOL))tryInterceptHandler
             cancelHandler:(void (^_Nonnull)(void))cancelHandler {
  if (_controller) {
    DBMobileWebViewController *webViewController =
        [[DBMobileWebViewController alloc] initWithAuthUrl:authURL
                                       tryInterceptHandler:tryInterceptHandler
                                             cancelHandler:cancelHandler];
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:webViewController];

    [_controller presentViewController:navigationController animated:YES completion:nil];
  }
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

#pragma mark - Web view controller

@interface DBMobileWebViewController ()

@property (nonatomic, readonly) WKWebView * _Nullable webView;
@property (nonatomic, readonly, nullable) void (^onWillDismiss)(BOOL);
@property (nonatomic, readonly, nullable) BOOL (^tryInterceptHandler)(NSURL * _Nullable, BOOL);
@property (nonatomic, readonly) UIBarButtonItem * _Nullable cancelButton;
@property (nonatomic, readonly, nullable) void (^cancelHandler)(void);
@property (nonatomic, readonly) UIActivityIndicatorView * _Nullable indicator;
@property (nonatomic, readonly, copy) NSURL * _Nullable startUrl;

@end

@implementation DBMobileWebViewController

- (instancetype)init {
  return [super initWithNibName:nil bundle:nil];
}

- (instancetype)init:(NSCoder *)coder {
  return [super initWithCoder:coder];
}

- (instancetype)initWithAuthUrl:(NSURL *)authUrl
            tryInterceptHandler:(BOOL (^)(NSURL *, BOOL))tryInterceptHandler
                  cancelHandler:(void (^)(void))cancelHandler {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _tryInterceptHandler = tryInterceptHandler;
    _cancelHandler = cancelHandler;
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _startUrl = authUrl;

    // clear any persistent cookies
    NSString *libraryPath =
        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    NSError *errors;
    [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
  _webView.UIDelegate = self;

  _indicator.center = self.view.center;
  [_webView addSubview:_indicator];
  [_indicator startAnimating];

  [self.view addSubview:_webView];

  _webView.navigationDelegate = self;

  self.view.backgroundColor = [UIColor whiteColor];

  _cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                target:self
                                                                action:@selector(cancel:)];
  self.navigationItem.rightBarButtonItem = _cancelButton;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  if (![_webView canGoBack]) {
    if (_startUrl != nil) {
      [self loadURL:_startUrl];
    } else {
      [_webView loadHTMLString:@"There is no `startUrl`" baseURL:nil];
    }
  }
}

- (void)webView:(WKWebView *)webView
    decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
                    decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
#pragma unused(webView)
  NSURL *navigationUrl = navigationAction.request.URL;
  if (navigationUrl && _tryInterceptHandler) {
    if (_tryInterceptHandler(navigationUrl, NO)) {
      // don't dismiss controller if we're going to App Store
      if (![navigationUrl.scheme isEqualToString:@"itms-apps"]) {
        [self dismiss:YES];
      }

      return decisionHandler(WKNavigationActionPolicyCancel);
    }
  }

  return decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView:(WKWebView *)webView
    createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration
               forNavigationAction:(WKNavigationAction *)navigationAction
                    windowFeatures:(WKWindowFeatures *)windowFeatures {
#pragma unused(webView)
#pragma unused(configuration)
#pragma unused(windowFeatures)
  // For target="_bank" urls, we want to suppress the call, then reopen in new browser
  if (!navigationAction.targetFrame.isMainFrame) {
    _tryInterceptHandler(navigationAction.request.URL, YES);
  }
  return nil;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
#pragma unused(webView)
#pragma unused(navigation)
  [_indicator stopAnimating];
  [_indicator removeFromSuperview];
}

- (void)loadURL:(NSURL *)url {
  [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)showHideBackButton:(BOOL)show {
  if (show) {
    self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind
                                                      target:self
                                                      action:@selector(goBack:)];
  } else {
    self.navigationItem.leftBarButtonItem = nil;
  }
}

- (void)goBack:(id)sender {
#pragma unused(sender)
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

  if (_onWillDismiss) {
    _onWillDismiss(asCancel);
  }
  if (self.presentingViewController) {
    [self.presentingViewController dismissViewControllerAnimated:animated completion:nil];
  }
}

@end
