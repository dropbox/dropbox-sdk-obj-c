///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthMobile.h"
#import "DBOAuthResult.h"
#import "DropboxClientsManager.h"
#import <Foundation/Foundation.h>
@class DBTransportClient;
@class UIApplication;
@class UIViewController;

///
/// Code with platform-specific (here, iOS) dependencies.
///
/// Extends functionality of the DropboxClientsManager class.
///
@interface DropboxClientsManager (MobileAuth)

///
/// Commences OAuth flow from supplied view controller.
///
/// @param sharedApplication The UIApplication with which to render the
/// OAuth flow.
/// @param controller The UIViewController with which to render the OAuth
/// flow.
/// @param openURL A wrapper around app-extension unsafe openURL call.
/// @param browserAuth Whether to use an external web-browser to perform
/// authorization. If set to false, then an in-app webview will be used
/// to facilitate the auth flow. The advantage of browser auth is it is
/// safer for the end user and it can leverage existing session information,
/// which might mean the end user can avoid re-entering their Dropbox login
/// credentials. The disadvantage of browser auth is it requires navigating
/// outside of the current app.
///
+ (void)authorizeFromController:(UIApplication * _Nonnull)sharedApplication
                     controller:(UIViewController * _Nonnull)controller
                        openURL:(void (^_Nonnull)(NSURL *))openURL
                    browserAuth:(BOOL)browserAuth;

///
/// Initializes a DropboxClient shared instance with the supplied app key.
///
/// If a stored OAuth token exists, it will be retrieved and used to authenticate
/// API calls. Use setupWithAppKey:transportClient, if additional customization
/// of network calls is necessary. Should be called from app delegate.
///
/// @param appKey The appKey of the third-party Dropbox API user app that will be
/// associated with all API calls. To create an app or to locate your app's
/// app key, please visit the App Console here:
/// https://www.dropbox.com/developers/apps.
///
+ (void)setupWithAppKey:(NSString * _Nonnull)appKey;

///
/// Initializes a DropboxClient shared instance with the supplied app key.
///
/// If a stored OAuth token exists, it will be retrieved and used to authenticate
/// API calls. Customize configuration of network calls using the different
/// DBTransportClient constructors. Should be called from app delegate.
///
/// @param appKey The appKey of the third-party Dropbox API user app that will be
/// associated with all API calls. To create an app or to locate your app's
/// app key, please visit the App Console here:
/// https://www.dropbox.com/developers/apps.
/// @param transportClient The transport client used to make all API networking
/// calls. The transport client settings can be manually configured using one
/// of the numerous DBTransportClient constructors.
///
+ (void)setupWithAppKey:(NSString * _Nonnull)appKey transportClient:(DBTransportClient * _Nonnull)transportClient;

///
/// Initializes a DropboxTeamClient shared instance with the supplied app key.
///
/// If a stored OAuth token exists, it will be retrieved and used to authenticate
/// API calls. Use setupWithAppKey:transportClient, if additional customization
/// of network calls is necessary. Should be called from app delegate.
///
/// @param appKey The appKey of the third-party Dropbox API team app that will be
/// associated with all API calls. To create an app or to locate your app's
/// app key, please visit the App Console here:
/// https://www.dropbox.com/developers/apps.
///
+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey;

///
/// Initializes a DropboxTeamClient shared instance with the supplied app key.
///
/// If a stored OAuth token exists, it will be retrieved and used to authenticate
/// API calls. Customize configuration of network calls using the different
/// DBTransportClient constructors. Should be called from app delegate.
///
/// @param appKey The appKey of the third-party Dropbox API team app that will be
/// associated with all API calls. To create an app or to locate your app's
/// app key, please visit the App Console here:
/// https://www.dropbox.com/developers/apps.
/// @param transportClient The transport client used to make all API networking
/// calls. The transport client settings can be manually configured using one
/// of the numerous DBTransportClient constructors.
///
+ (void)setupWithTeamAppKey:(NSString * _Nonnull)appKey transportClient:(DBTransportClient * _Nonnull)transportClient;

@end
