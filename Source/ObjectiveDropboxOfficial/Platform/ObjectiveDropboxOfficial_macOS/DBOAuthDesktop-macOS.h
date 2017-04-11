///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <AppKit/AppKit.h>
#import <Foundation/Foundation.h>

#import "DBSharedApplicationProtocol.h"

///
/// Platform-specific (here, macOS) shared application.
///
/// Renders OAuth flow and implements `DBSharedApplication` protocol.
///
@interface DBDesktopSharedApplication : NSObject <DBSharedApplication>

///
/// Full constructor.
///
/// @param sharedApplication The `NSWorkspace` with which to render the OAuth flow.
/// @param controller The `NSViewController` with which to render the OAuth flow.
/// @param openURL A wrapper around app-extension unsafe `openURL` call.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithSharedApplication:(NSWorkspace * _Nonnull)sharedApplication
                                       controller:(NSViewController * _Nonnull)controller
                                          openURL:(void (^_Nonnull)(NSURL * _Nonnull))openURL;

@end
