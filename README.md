# Dropbox for Objective-C

The Official Dropbox Objective-C SDK for integrating with Dropbox API v2 on iOS or OS X.

## Requirements

- iOS 8.0+
- OS X 10.10+
- Xcode 7.3+

## Get Started

### Register your application

Before using this SDK, register your application in the [Dropbox App Console](https://dropbox.com/developers/apps).

### Obtain an OAuth2 token

All requests need to be made with an OAuth2 access token. An OAuth token represents an authenticated link between a Dropbox app and
a Dropbox user account or team.

Once you've created an app, you can go to the App Console and manually generate an access token for your own Dropbox account.
Otherwise, you can obtain an OAuth token programmatically using the SDK's pre-defined auth flow. For more information, see below.

## Integrate with your project

### CocoaPods

You can integrate the Dropbox Objective-C SDK into your project using one of several ways, including [CocoaPods](http://cocoapods.org),
a dependency manager for Cocoa projects. You can install it for your iOS or OS X project using the following command:

```bash
$ gem install cocoapods
```

Then navigate to the directory that contains your project and create a new **Podfile** with `pod init`, or open an existing one, and then add `pod 'ObjectiveDropboxOfficial'` to the main loop. Your Podfile should look something like this:

```ruby
target '<YOUR_PROJECT_NAME>' do
    pod 'ObjectiveDropboxOfficial'
end
```

Then, run the following command to install the dependency:

```bash
$ pod install
```

### Carthage

You can also integrate the Dropbox Objective-C SDK into your project using [Carthage](https://github.com/Carthage/Carthage), a decentralized dependency manager for Cocoa. You can install Carthage (with XCode 7+) via Homebrew:

```
brew update
brew install carthage
```
 To install the Dropbox Objective-C SDK via Carthage, you need to create a `Cartfile` in your project with the following contents:

```
# ObjectiveDropboxOfficial 
github "https://github.com/dropbox/dropbox-sdk-obj-c" ~> 1.0
```

Then, run the following command to install the dependency to checkout and build the Dropbox Objective-C SDK repository:

```
carthage update --platform iOS
```
In the Project Navigator in XCode, select your project, and then navigate to **General** > **Linked Frameworks and Libraries** and drag and drop each framework (in `Carthage/Build/iOS`).

Then, navigate to **Build Phases** > `+` > **New Run Script Phase**, and add the following code:

```
/usr/local/bin/carthage copy-frameworks
```

Then, navigate to the **Input Files** section and add the following path:

```
$(SRCROOT)/Carthage/Build/iOS/ObjectiveDropboxOfficial.framework
```

### Manually add

Finally, you can also integrate the Dropbox Objective-C SDK into your project manually without using a dependency manager.

Drag the `ObjectiveDropboxOfficial.xcodeproj` project into your project as a subproject.

In the Project Navigator in XCode, select your project, and then navigate to your project's build target > **General** > **Embedded Binaries** > `+` > `ObjectiveDropboxOfficial.framework`.

## Configure your project

Once you have checkedout and integrated the Dropbox Objective-C SDK into your project, there are a few changes that you should make to your project.

### Application `plist` file

If you are compiling on iOS SDK 9.0, you will need to modify your application's `plist` to handle Apple's [new security changes](https://developer.apple.com/videos/wwdc/2015/?id=703) to the `canOpenURL` function. You should
add the following code to your application's `plist` file:

```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>dbapi-8-emm</string>
        <string>dbapi-2</string>
    </array>
```
This allows the Objective-C SDK to determine if the official Dropbox iOS app is installed on the current device. If it is installed, then the official Dropbox iOS app can be used to programmatically obtain an OAuth2 access token.

Additionally, your application needs to register to handle a unique Dropbox URL scheme for redirect following completion of the OAuth2 authorization flow. This URL scheme should have the format `db-<APP_KEY>`, where `<APP_KEY>` is your
Dropbox app's app key, which can be found in the [Dropbox App Console](https://dropbox.com/developers/apps). You should add the following code to your `plist` file (but be sure to replace `<APP_KEY>` with your app's app key):

```
<key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleURLSchemes</key>
            <array>
                <string>db-<APP_KEY></string>
            </array>
            <key>CFBundleURLName</key>
            <string></string>
        </dict>
    </array>
```

After these changes, your application's `plist` file should look something like this:

<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/InfoPlistExample.png?raw=true" alt="Info Plist Example"/>
</p>

### Handling authorization flow

To facilitate the authorization flow to programmatically retrieve an OAuth2 access token, you should take the following steps:

Initialize a `DropboxClient` instance in your application's delegate:

(for iOS)

```objective-c
#import "DropboxClientsManager+MobileAuth.h"
....
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DropboxClientsManager setupWithAppKey:@"<APP_KEY>"];
    return YES;
}

```

(for OS X)

```objective-c
#import "DropboxClientsManager+DesktopAuth.h"
....
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [DropboxClientsManager setupWithAppKey:@"<APP_KEY>"];
}
```

To begin the authorization flow, from your application's view controller, call the `authorizeFromController:controller:openURL:browserAuth` method:

(for iOS)

```objective-c
#import "DropboxClientsManager+MobileAuth.h"
....
- (void)viewDidLoad {
    [DropboxClientsManager authorizeFromController:[UIApplication sharedApplication]
                                        controller:self
                                           openURL:^(NSURL *url){ [[UIApplication sharedApplication] openURL:url]; }
                                       browserAuth:NO];
}

```

(for OS X)

```objective-c
#import "DropboxClientsManager+DesktopAuth.h"
....
- (void)viewDidLoad {
    [DropboxClientsManager authorizeFromController:[NSWorkspace sharedWorkspace]
                                        controller:self
                                           openURL:^(NSURL *url){ [[NSWorkspace sharedWorkspace] openURL:url]; }
                                       browserAuth:YES];
}
```

Then, to handle the redirection back into the Objective-C SDK, setup the following handler in your application's delegate:

(for iOS)

```objective-c
#import "DropboxClientsManager+MobileAuth.h"
....
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
    return NO;
}

```

(for OS X)

```objective-c
#import "DropboxClientsManager+DesktopAuth.h"
....
- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    DBOAuthResult *authResult = [DropboxClientsManager handleRedirectURL:url];
    if (authResult != nil) {
        if ([authResult isSuccess]) {
            NSLog(@"Success! User is logged into Dropbox.");
        } else if ([authResult isCancel]) {
            NSLog(@"Authorization flow was manually canceled by user!");
        } else if ([authResult isError]) {
            NSLog(@"Error: %@", authResult);
        }
    }
}
```

## Try some API requests

Once you have obtained an OAuth2 token, you can try some API v2 calls using the Objective-C SDK:

```objective-c
// Access DropboxClient after programmatic auth flow 
DropboxClient *client = [DropboxClientsManager authorizedClient];
```

or

```objective-c
// Access DropboxClient with manually retrieved auth token
DropboxClient *client = [DropboxClient initWithAccessToken:@"<MY_ACCESS_TOKEN>"];
```

The Dropbox [User API](https://www.dropbox.com/developers/documentation/http/documentation) and [Business API](https://www.dropbox.com/developers/documentation/http/teams) have three types of requests: RPC, Upload and Download.

The response handler for each of the request types are similar to one another. The first argument is the result type from the route (`DBNilObject` is the route does not have a return type), the second argument is the route-specific error, and the third
argument is the generic HTTP error.

The RPC and Upload style response handlers are the same – the Download-style response handler has an additional arguments, depending on the output type.

### RPC-style request
```objective-c
[[[client.filesRoutes createFolder:@"/test/path"] response:^(DBFILESFolderMetadata *result, DBFILESCreateFolderError *routeError, DBError *error) {
    if (result) {
        NSLog(@"%@\n", result);
    } else {
        NSLog(@"%@\n%@\n", routeError, error);
    }
}] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
    NSLog(@"%lld\n%lld\n%lld\n", bytesSent, totalBytesSent, totalBytesExpectedToSend);
}];
```

### Upload-style request
```objective-c
NSData *fileData = [@"file data example" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
[[[client.filesRoutes uploadData:@"/test/path" inputData:fileData] response:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBError *error) {
    if (result) {
        NSLog(@"%@\n", result);
    } else {
        NSLog(@"%@\n%@\n", routeError, error);
    }
}] progress:^(int64_t bytesUploaded, int64_t totalBytesUploaded, int64_t totalBytesExpectedToUploaded) {
    NSLog(@"%lld\n%lld\n%lld\n", bytesUploaded, totalBytesUploaded, totalBytesExpectedToUploaded);
}];
```

### Download-style request
```objective-c
// Download to NSURL
NSFileManager *fileManager = [NSFileManager defaultManager];
NSURL *outputDirectory = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
NSURL *outputUrl = [outputDirectory URLByAppendingPathComponent:@"test_file_output.txt"];
[[[client.filesRoutes downloadData:@"/test/path" overwrite:YES destination:outputUrl] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBError *error, NSURL *destination) {
    if (result) {
        NSLog(@"%@\n", result);
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:[destination path]];
        NSString *dataStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n", dataStr);
    } else {
        NSLog(@"%@\n%@\n", routeError, error);
    }
}] progress:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
    NSLog(@"%lld\n%lld\n%lld\n", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
}];


// Download to NSData
NSData *fileData = [@"file data example" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
[[[client.filesRoutes downloadData:@"/test/path"] response:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBError *error, NSData *fileContents) {
    if (result) {
        NSLog(@"%@\n", result);
        NSString *dataStr = [[NSString alloc]initWithData:fileContents encoding:NSUTF8StringEncoding];
        NSLog(@"%@\n", dataStr);
    } else {
        NSLog(@"%@\n%@\n", routeError, error);
    }
}] progress:^(int64_t bytesDownloaded, int64_t totalBytesDownloaded, int64_t totalBytesExpectedToDownload) {
    NSLog(@"%lld\n%lld\n%lld\n", bytesDownloaded, totalBytesDownloaded, totalBytesExpectedToDownload);
}];
```


## Examples

* [DBRoulette]() - Play roulette.

## Documentation

Find complete documention on our [GitHub Pages site]().

## Modifications

If you're interested in modifying the SDK codebase, clone the GitHub repository to your local filesystem
and run `git submodule init` and then `git submodule update`, then navigate to ./TestObjectiveDropbox_[iOS,OSX] and run `pod install`.
Once this is complete, open the ./TestObjectiveDropbox_[iOS,OSX]/TestObjectiveDropbox_[iOS,OSX].xcworkspace file with XCode and proceed to implement your
changes to the SDK source code.

To ensure your changes have not broken any existing functionality, you can run a series of integration tests by
following the instructions listed in the ./TestObjectiveDropbox_[iOS,OSX]/TestObjectiveDropbox_[iOS,OSX]/ViewController.m file.

## Bugs

Please post any bugs to the [issue tracker](https://github.com/dropbox/dropbox-sdk-obj-c/issues) found on the project's GitHub page.
  
Please include the following with your issue:
 - a description of what is not working right
 - sample code to help replicate the issue

Thank you!

