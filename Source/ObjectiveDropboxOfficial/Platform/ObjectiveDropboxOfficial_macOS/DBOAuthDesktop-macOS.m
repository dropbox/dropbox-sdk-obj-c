///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthDesktop-macOS.h"
#import "DBOAuthManager.h"

@implementation DBDesktopSharedApplication {
  NSWorkspace * _Nullable _sharedWorkspace;
  NSViewController * _Nullable _controller;
  void (^_openURL)(NSURL * _Nullable);
}

- (instancetype)initWithSharedApplication:(NSWorkspace *)sharedWorkspace
                               controller:(NSViewController *)controller
                                  openURL:(void (^)(NSURL *))openURL {
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
#pragma unused(title)
  if (_controller) {
    NSError *error = [[NSError alloc] initWithDomain:@"" code:123 userInfo:@{NSLocalizedDescriptionKey : message}];
    [_controller presentError:error];
  }
}

- (void)presentErrorMessageWithHandlers:(NSString * _Nonnull)message
                                  title:(NSString * _Nonnull)title
                         buttonHandlers:(NSDictionary<NSString *, void (^)()> * _Nonnull)buttonHandlers {
#pragma unused(buttonHandlers)
  [self presentErrorMessage:message title:title];
}

- (BOOL)presentPlatformSpecificAuth:(NSURL * _Nonnull)authURL {
#pragma unused(authURL)
  // no platform-specific auth methods for macOS
  return NO;
}

- (void)presentAuthChannel:(NSURL * _Nonnull)authURL cancelHandler:(void (^_Nonnull)(void))cancelHandler {
#pragma unused(cancelHandler)
  if (_controller) {
    [self presentExternalApp:authURL];
  }
}

- (void)presentExternalApp:(NSURL * _Nonnull)url {
  _openURL(url);
}

- (BOOL)canPresentExternalApp:(NSURL * _Nonnull)url {
#pragma unused(url)
  return YES;
}

@end
