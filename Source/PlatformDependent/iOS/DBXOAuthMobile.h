///
/// Code with platform-specific (here, iOS) dependencies. Renders OAuth flow.
///

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "DBXOAuth.h"
#import "DBXSharedApplicationProtocol.h"

@interface DBXMobileSharedApplication : NSObject <DBXSharedApplication>

- (nonnull instancetype)init:(UIApplication * _Nonnull)sharedApplication controller:(UIViewController * _Nonnull)controller openURL:(void(^_Nonnull)(NSURL * _Nonnull))openURL;

@end


@interface DBXWebViewController : UIViewController <WKNavigationDelegate>

- (nonnull instancetype)init:(NSURL * _Nonnull)url tryInterceptHandler:(BOOL (^ _Nonnull)(NSURL * _Nonnull))tryInterceptHandler cancelHandler:(void (^ _Nonnull)(void))cancel;

@end