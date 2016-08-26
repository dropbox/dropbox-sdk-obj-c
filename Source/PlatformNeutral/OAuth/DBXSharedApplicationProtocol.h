#import <Foundation/Foundation.h>

///
/// Protocol implemented by platform-specific builds of the Obj-C SDK
/// for properly rendering the OAuth linking flow.
///
@protocol DBXSharedApplication <NSObject>

///
/// Presents a platform-specific error message, and halts the auth flow.
///
/// - parameter message: String to display which describes the error.
/// - parameter title: String to display which titles the error view.
///
- (void)presentErrorMessage:(NSString * _Nonnull)message title:(NSString * _Nonnull)title;

///
/// Presents a platform-specific error message, and halts the auth flow. Optional handlers may be
/// provided for view display buttons (mainly useful in the mobile case).
///
/// - parameter message: String to display which describes the error.
/// - parameter title: String to display which titles the error view.
/// - parameter buttonHandlers: Map from button name to button handler.
///
- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message title:(NSString * _Nonnull)title buttonHandlers:(NSDictionary <NSString *, void (^)()> * _Nonnull)buttonHandlers;

///
/// Presents platform-specific authorization paths. This method is called before more generic,
/// platform-neutral auth methods (like in-app web view auth or external browser auth). For example,
/// in the mobile case, the Obj-C SDK will use a direct authorization route with the Dropbox mobile
/// app, if it is installed on the current device.
///
/// - parameter authURL: Gateway URL to commence auth flow.
///
- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL;

///
/// Presents platform-neutral "webview auth" flow, where an in-app web browser loads the auth page.
/// The advantage with this flow is that the user never leaves the app during the auth process. The
/// disadvantage is that session data is not retrieved, so the user must enter their login credentials
/// manually, which can be cumbersome.
///
/// - parameter authURL: Gateway URL to commence auth flow.
/// - parameter tryInterceptHandler: Navigation handler for redirect from webview back to normal app view.
/// - parameter cancelHandler: Handler for cancelling auth flow. Opens "cancel" url to signal cancellation.
///
- (void)presentWebViewAuth:(NSURL * _Nonnull)authURL tryInterceptHandler:(BOOL (^_Nonnull)(NSURL * _Nonnull))tryInterceptHandler cancelHandler:(void (^_Nonnull)(void))cancelHandler;

///
/// Presents platform-neutral "external webbrowser auth" flow, where the default external webbrowser is
/// opened to load the auth page. The advantage with this flow is that the user can leverage preexisting
/// session data. This is also a safer option for app users, as it is not required that they trust the
/// third-party app that they're using. The disadvantage is that the user is redirected outside of the app,
/// which can require multiple confirmations and is generally not the smoothest experience.
///
/// - parameter authURL: Gateway URL to commence auth flow.
///
- (void)presentBrowserAuth:(NSURL * _Nonnull)authURL;

///
/// Opens the external app that is registered to handle the supplied url type, and then passes the supplied
/// url to the newly-opened app.
///
/// - parameter url: URL to open with external app.
///
- (void)presentExternalApp:(NSURL * _Nonnull)url;

///
/// Checks whether there is an external app registered to open the url type.
///
/// - parameter url: URL to check.
///
/// - returns: Whether there is an external app registered to open the url type.
///
- (BOOL)canPresentExternalApp:(NSURL * _Nonnull)url;

@end
