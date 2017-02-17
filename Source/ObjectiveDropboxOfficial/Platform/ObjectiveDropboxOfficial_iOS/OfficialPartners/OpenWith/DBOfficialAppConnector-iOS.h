///
///  Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

@class DBOpenWithInfo;

///
/// Manages returning to the official Dropbox app.
///
/// @note This logic is for official Dropbox partners only, and should not need
/// to be used by other third-party apps.
///
@interface DBOfficialAppConnector : NSObject

- (nonnull instancetype)initWithAppKey:(NSString * _Nonnull)appKey;

///
/// Returns to the Dropbox app specified by app
///
/// @note This logic is for official Dropbox partners only, and should not need to be used by other third-party apps.
///
/// @param openWithInfo Information retrieved from a shared `UIPasteboard` that is used to return to the official
/// Dropbox app.
/// @param changesPending Whether there are changes pending in Dropbox for the file.
/// @param openURLWrapper A wrapper around the [UIApplication openURL] method call to ensure the SDK is app-extension
/// safe.
///
- (void)returnToDropboxApp:(DBOpenWithInfo * _Nonnull)openWithInfo
            changesPending:(BOOL)changesPending
            openURLWrapper:(void (^_Nonnull)(NSURL * _Nonnull))openURLWrapper;

///
/// Returns to the Dropbox app specified by app passing along the error and a dictionary of extra information.
///
/// @note This logic is for official Dropbox partners only, and should not need to be used by other third-party apps.
///
/// @param openWithInfo Information retrieved from a shared `UIPasteboard` that is used to return to the official
/// Dropbox app.
/// @param changesPending Whether there are changes pending in Dropbox for the file.
/// @param errorName The error encoutered to pass back to the official Dropbox app.
/// @param extras Extra information to pass back to the official Dropbox app.
///
- (void)returnToDropboxApp:(DBOpenWithInfo * _Nonnull)openWithInfo
            changesPending:(BOOL)changesPending
                 errorName:(NSString * _Nullable)errorName
                    extras:(NSDictionary * _Nullable)extras
            openURLWrapper:(void (^_Nonnull)(NSURL * _Nonnull))openURLWrapper;

///
/// Retrieves from a shared `UIPasteboard` information used to return to the official Dropbox app.
///
/// @note This logic is for official Dropbox partners only, and should not need to be used by other third-party apps.
///
/// Returns @c DBOpenWithInfo object that wraps the relevant information for returning to the official Dropbox app.
///
+ (DBOpenWithInfo * _Nullable)retriveOfficialDropboxAppOpenWithInfo;

@end
