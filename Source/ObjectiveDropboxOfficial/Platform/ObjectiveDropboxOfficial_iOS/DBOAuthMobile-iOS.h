///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "DBSharedApplicationProtocol.h"

#pragma mark - Shared application

///
/// Platform-specific (here, iOS) shared application.
///
/// Renders OAuth flow and implements `DBSharedApplication` protocol.
///
@interface DBMobileSharedApplication : NSObject <DBSharedApplication>

///
/// Full constructor.
///
/// @param sharedApplication The `UIApplication` with which to render the OAuth flow.
/// @param controller The `UIViewController` with which to render the OAuth flow.
/// @param openURL A wrapper around app-extension unsafe `openURL` call.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithSharedApplication:(UIApplication * _Nonnull)sharedApplication
                                       controller:(UIViewController * _Nonnull)controller
                                          openURL:(void (^_Nonnull)(NSURL * _Nonnull))openURL;

@end

#pragma mark - Web view controller

///
/// Platform-specific (here, iOS) `UIViewController` for rendering OAuth flow.
///
@interface DBMobileWebViewController : UIViewController <WKNavigationDelegate, WKUIDelegate>

///
/// Full constructor.
///
/// @param authUrl The auth url with which to begin the authorization flow.
/// @param tryInterceptHandler The navigation handler for the view controller. Will check if exit URL (for redirect back
/// to main app) can be successfully navigated to. Boolean parameter sets whether an external browser should be used for
/// opening urls.
/// @param cancelHandler Handler for auth cancellation. Will redirect back to main app with special cancel url, so that
/// cancellation can be detected.

///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithAuthUrl:(NSURL * _Nonnull)authUrl
                    tryInterceptHandler:(BOOL (^_Nonnull)(NSURL * _Nonnull, BOOL))tryInterceptHandler
                          cancelHandler:(void (^_Nonnull)(void))cancelHandler;

@end
