///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>
#import <UIKit/UIKit.h>

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

+ (DBMobileSharedApplication * _Nullable)mobileSharedApplication;

+ (void)setMobileSharedApplication:(DBMobileSharedApplication * _Nonnull)mobileSharedApplication;

- (void)dismissAuthController;

@end

#pragma mark - Web view controller

///
/// Platform-specific (here, iOS) `UIViewController` for rendering OAuth flow.
///
@interface DBMobileSafariViewController : SFSafariViewController <SFSafariViewControllerDelegate>

- (nonnull instancetype)initWithUrl:(NSURL * _Nonnull)url cancelHandler:(DBOAuthCancelBlock _Nonnull)cancelHandler;

@end
