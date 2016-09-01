# Dropbox for Objective-C

The Official Dropbox Objective-C SDK for integrating with Dropbox [API v2](https://www.dropbox.com/developers/documentation/http/documentation) on iOS or OS X.

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

Once you've created an app, you can go to the App Console and manually generate an access token to authorize your app to access your own Dropbox account.
Otherwise, you can obtain an OAuth token programmatically using the SDK's pre-defined auth flow. For more information, [see below](https://github.com/dropbox/dropbox-sdk-obj-c#handling-authorization-flow).

## SDK Distribution

You can integrate the Dropbox Objective-C SDK into your project using one of several methods.

### CocoaPods

To use [CocoaPods](http://cocoapods.org), a dependency manager for Cocoa projects, you can install it for your iOS or OS X project using the following command:

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

### Manually add framework

Finally, you can also integrate the Dropbox Objective-C SDK into your project manually without using a dependency manager.

Drag the `ObjectiveDropboxOfficial.xcodeproj` project into your project as a subproject.

In the Project Navigator in XCode, select your project, and then navigate to your project's build target > **General** > **Embedded Binaries** > `+` > `ObjectiveDropboxOfficial.framework`.

## Configure your project

Once you have integrated the Dropbox Objective-C SDK into your project, there are a few additional steps to take before you can begin making API calls.

### Application .plist file

If you are compiling on iOS SDK 9.0, you will need to modify your application's .plist to handle Apple's [new security changes](https://developer.apple.com/videos/wwdc/2015/?id=703) to the `canOpenURL` function. You should
add the following code to your application's .plist file:

```
<key>LSApplicationQueriesSchemes</key>
    <array>
        <string>dbapi-8-emm</string>
        <string>dbapi-2</string>
    </array>
```
This allows the Objective-C SDK to determine if the official Dropbox iOS app is installed on the current device. If it is installed, then the official Dropbox iOS app can be used to programmatically obtain an OAuth2 access token.

Additionally, your application needs to register to handle a unique Dropbox URL scheme for redirect following completion of the OAuth2 authorization flow. This URL scheme should have the format `db-<APP_KEY>`, where `<APP_KEY>` is your
Dropbox app's app key, which can be found in the [App Console](https://dropbox.com/developers/apps).

You should add the following code to your .plist file (but be sure to replace `<APP_KEY>` with your app's app key):

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

After you've made the above changes, your application's .plist file should look something like this:

<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/InfoPlistExample.png?raw=true" alt="Info .plist Example"/>
</p>

### Handling the authorization flow

There are three methods to programmatically retrieve an OAuth2 access token:

* **Direct auth** (iOS only): This launches the official Dropbox iOS app (if installed), authenticates via the official app, then redirects back into the SDK
* **In-app webview auth** (iOS, OS X): This opens a pre-built in-app webview for authenticating via the Dropbox authorization page. This is convenient because the user is never redirected outside of your app.
* **External browser auth** (iOS, OS X): This launches the platform's default browser for authenticating via the Dropbox authorization page. This is desirable because it is safer for the end-user, and pre-existing session data can be used to avoid requiring the user to re-enter their Dropbox credentials.

To facilitate the above authorization flows, you should take the following steps:

#### Initialize a `DropboxClient` instance from application delegate

(for iOS)

```objective-c
#import "DropboxSDKImports.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [DropboxClientsManager setupWithAppKey:@"<APP_KEY>"];
    return YES;
}

```

(for OS X)

```objective-c
#import "DropboxSDKImports.h"

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [DropboxClientsManager setupWithAppKey:@"<APP_KEY>"];
}
```

#### Begin the authorization flow from view controller

You can commence the auth flow by calling `authorizeFromController:controller:openURL:browserAuth` method in your application's
view controller. If you wish to authenticate via the in-app webview, then set `browserAuth` to `NO`. Otherwise, authentication will be done via an external web browser.

(for iOS)

```objective-c
#import "DropboxSDKImports.h"

- (void)viewDidLoad {
    [DropboxClientsManager authorizeFromController:[UIApplication sharedApplication]
                                        controller:self
                                           openURL:^(NSURL *url){ [[UIApplication sharedApplication] openURL:url]; }
                                       browserAuth:YES];
}

```

(for OS X)

```objective-c
#import "DropboxSDKImports.h"

- (void)viewDidLoad {
    [DropboxClientsManager authorizeFromController:[NSWorkspace sharedWorkspace]
                                        controller:self
                                           openURL:^(NSURL *url){ [[NSWorkspace sharedWorkspace] openURL:url]; }
                                       browserAuth:YES];
}
```

Beginning the authentication flow via in-app webview will launch a window like this:


<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/OAuthFlowInit.png?raw=true" alt="Auth Flow Init Example"/>
</p>

#### Handle redirect back into SDK

To handle the redirection back into the Objective-C SDK once the authentication flow is complete, you should add the following code in your application's delegate:

(for iOS)

```objective-c
#import "DropboxSDKImports.h"

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
#import "DropboxSDKImports.h"

- (void)handleAppleEvent:(NSAppleEventDescriptor *)event withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    NSURL *url = [NSURL URLWithString:[[event paramDescriptorForKeyword:keyDirectObject] stringValue]];
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

After the end user signs in with their Dropbox login credentials via the in-app webview, they will see a window like this:


<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/OAuthFlowApproval.png?raw=true" alt="Auth Flow Approval Example"/>
</p>

If they press "Allow" or "Cancel", the `db-<APP_KEY>` redirect URL will be launched from the webview, and will be handled in your application
delegate's `application:handleOpenURL` method, from which the result of the authorization can be parsed.

Now you're ready to begin making API requests!

## Try some API requests

Once you have obtained an OAuth2 token, you can try some API v2 calls using the Objective-C SDK.

### Retrieve your Dropbox client instance

Start by creating a reference to the `DropboxClient` or `DropboxTeamClient` instance that you will use to make your API calls.

```objective-c
#import "DropboxSDKImports.h"

// Reference after programmatic auth flow 
DropboxClient *client = [DropboxClientsManager authorizedClient];
```

or

```objective-c
#import "DropboxSDKImports.h"

// Initialize with manually retrieved auth token
DropboxClient *client = [[DropboxClient alloc] initWithAccessToken:@"<MY_ACCESS_TOKEN>"];
```

### Handle the API response

The Dropbox [User API](https://www.dropbox.com/developers/documentation/http/documentation) and [Business API](https://www.dropbox.com/developers/documentation/http/teams) have three types of requests: RPC, Upload and Download.

The response handlers for each request type are similar to one another. The arguments for the handler blocks are as follows:
* **route result type** (`DBNilObject` if the route does not have a return type)
* **route-specific error** (usually a union type)
* **network request error** (generic to all requests – contains information like request ID, HTTP status code, etc.)
* **output content** (`NSURL` / `NSData` reference to downloaded ouput for Download-style endpoints only)

Response handlers and progress handlers are optional for all endpoints.

### Request types

#### RPC-style request
```objective-c
[[client.filesRoutes createFolder:@"/test/path"] response:^(DBFILESFolderMetadata *result, DBFILESCreateFolderError *routeError, DBError *error) {
    if (result) {
        NSLog(@"%@\n", result);
    } else {
        NSLog(@"%@\n%@\n", routeError, error);
    }
}];
```

#### Upload-style request
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

#### Download-style request
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

### Handling responses and errors

Dropbox API v2 deals largely with two data types: **structs** and **unions**. Broadly speaking, most route **arguments** are struct types and most route **errors** are union types.

**Struct types** are "traditional" object types, that is, composite types made up of a collection of one or more instance fields. All public instance fields are accessible at runtime, regardless of state.

**Union types**, on the other hand, represent a single value that can take on multiple value types, depending on state. Each union state, or "tag", may have an associated value type (or it may not, in which case, the union type is said to be "void").
Associated value types can either be primitives, structs or unions. Although the Objective-C SDK represents union types as objects with multiple instance fields, at most one instance field is accessible at run time, depending on the tag state of the union.

For example, the [/delete](https://www.dropbox.com/developers/documentation/http/documentation#files-delete) endpoint returns an error, `DeleteError`, which is a union type. The `DeleteError` union can take on two different tag states: `path_lookup`
(if there is a problem looking up the path) or `path_write` (if there is a problem writing – or in this case deleting – to the path). Here, both tag states have non-void associated values (of types `DBFILESLookupError` and `DBFILESWriteError`, respectively).

In this way, one union object is able to capture a multitude of scenarios, each of which has their own value type.

To properly handle union types, you should call each of the `is<TAG_STATE>` methods associated with the union. Once you have determined the tag state of the union, you can then safely access the value associated with that tag state (provided there exists an associated value type, i.e., it's not "void").
If at run time you attempt to access a union instance field that is not associated with the current tag state, **an exception will be thrown**. See below:

#### Route-specific errors
```objective-c
[[client.filesRoutes delete_:@"/test/path"] response:^(DBFILESMetadata *result, DBFILESDeleteError *routeError, DBError *error) {
    if (result) {
        NSLog(@"%@\n", result);
    } else {
        // Error is with the route specifically (status code 409)
        if (routeError) {
            if ([routeError isPathLookup]) {
                // Can safely access this field
                DBFILESLookupError *pathLookup = routeError.pathLookup;
                NSLog(@"%@\n", pathLookup);
            } else if ([routeError isPathWrite]) {
                DBFILESWriteError *pathWrite = routeError.pathWrite;
                NSLog(@"%@\n", pathWrite);
                
                // This would cause a runtime error
                // DBFILESLookupError *pathLookup = routeError.pathLookup;
            }
        }
        NSLog(@"%@\n%@\n", routeError, error);
    }
}];
```

#### Generic network request errors

In the case of a network error, regardless of whether the error is specific to the route, a generic `DBError` type will always be returned, which includes information like Dropbox request ID and HTTP status code.

The `DBError` type is a special union type which is similar to the standard API v2 union type, but also includes a collection of `as<TAG_STATE>` methods, each of which returns a new instance of a particular error subtype.
As with accessing associated values in regular unions, the `as<TAG_STATE>` should only be called after the corresponding `is<TAG_STATE>` method returns true. See below:

```objective-c
[[client.filesRoutes delete_:@"/test/path"] response:^(DBFILESMetadata *result, DBFILESDeleteError *routeError, DBError *error) {
    if (result) {
        NSLog(@"%@\n", result);
    } else {
        if (routeError) {
            // see handling above
        } 
        // Error not specific to the route (status code > 500, 400, 401, 429)
        else {
            if ([error isInternalServerError]) {
                DBRequestInternalServerError *internalServerError = [error asInternalServerError];
                NSLog(@"%@\n", internalServerError);
            } else if ([error isBadInputError]) {
                DBRequestBadInputError *badInputError = [error asBadInputError];
                NSLog(@"%@\n", badInputError);
            } else if ([error isAuthError]) {
                DBRequestAuthError *authError = [error asAuthError];
                NSLog(@"%@\n", authError);
            } else if ([error isRateLimitError]) {
                DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
                NSLog(@"%@\n", rateLimitError);
            } else if ([error isHttpError]) {
                DBRequestHttpError *genericHttpError = [error asHttpError];
                NSLog(@"%@\n", genericHttpError);
            } else if ([error isOsError]) {
                DBRequestOsError *genericLocalError = [error asOsError];
                NSLog(@"%@\n", genericLocalError);
            }
        }
    }
}];
```

#### Response handling edge cases

Some routes return union types as result types, so you should be prepared to handle these results in the same way that you handle union route errors. Please consult the [documentation](https://www.dropbox.com/developers/documentation/http/documentation)
for each endpoint that you use to ensure you are properly handling the route's response type.

A few routes return result types that are "datatypes with subtypes", that is, structs that can take on multiple state types like unions.

For example, the [/delete](https://www.dropbox.com/developers/documentation/http/documentation#files-delete) endpoint returns a generic `Metadata` type, which can exist either as a `FileMetadata` struct, a `FolderMetadata` struct, or a `DeletedMetadata` struct.
To determine at runtime which subtype the `Metadata` type exists as, perform an `isKindOfClass` check for each possible class, and then cast the result accordingly. See below:

```objective-c
[[client.filesRoutes delete_:@"/test/path"] response:^(DBFILESMetadata *result, DBFILESDeleteError *routeError, DBError *error) {
    if (result) {
        if ([result isKindOfClass:[DBFILESFileMetadata class]]) {
            DBFILESFileMetadata *fileMetadata = (DBFILESFileMetadata *)result;
            NSLog(@"%@\n", fileMetadata);
        } else if ([result isKindOfClass:[DBFILESFolderMetadata class]]) {
            DBFILESFolderMetadata *folderMetadata = (DBFILESFolderMetadata *)result;
            NSLog(@"%@\n", folderMetadata);
        } else if ([result isKindOfClass:[DBFILESDeletedMetadata class]]) {
            DBFILESDeletedMetadata *deletedMetadata = (DBFILESDeletedMetadata *)result;
            NSLog(@"%@\n", deletedMetadata);
        }
    } else {
        if (routeError) {
            // see handling above
        } else {
            // see handling above
        }
    }
}];
```

This `Metadata` object is known as a "datatype with subtypes" in our API v2 documentation. The difference between these "datatypes with subtypes" and union types is that union types can exist as only one instance value at a time, whereas these "datatypes with subtypes" can exist
as multiple instance values at a time.

Only a few routes return result types like this.

### Customizing network calls

By default, all response handler code is executed via the main queue (which makes UI updating convenient). However, if additional customization is necessary
(like handling responses on a custom queue), you can initialize your `DropboxClient` with a customized `DBTransportClient` in your application delegate. See below:

```objective-c
DBTransportClient *transportClient = [[DBTransportClient alloc] initWithAccessToken:nil
                                                                         selectUser:nil
                                                                          baseHosts:nil
                                                                          userAgent:@"CustomUserAgent"
                                                                backgroundSessionId:@"com.custom.background.session.id"
                                                                      delegateQueue:[NSOperationQueue new]];
[DropboxClientsManager setupWithAppKey:@"<APP_KEY>" transportClient:transportClient];
```

## Examples

* [DBRoulette]() - Play roulette.

## Documentation

* [Dropbox API v2 Objective-C SDK]()
* [Dropbox API v2](https://www.dropbox.com/developers/documentation/http/documentation)

## Stone

All of our routes and data types are auto-generated using a framework called [Stone](https://github.com/dropbox/stone).

The `stone` repo contains all of the Objective-C specific generation logic, and the `spec` repo contains the language-neutral API endpoint specifications which serve
as input to the language-specific generators.

## Modifications

If you're interested in modifying the SDK codebase, you should take the following steps:

* clone this GitHub repository to your local filesystem
* run `git submodule init` and then `git submodule update`
* navigate to ./TestObjectiveDropbox_[iOS|OSX] and run `pod install`
* open ./TestObjectiveDropbox_[iOS|OSX]/TestObjectiveDropbox_[iOS|OSX].xcworkspace in XCode
* implement your changes to the SDK source code.

To ensure your changes have not broken any existing functionality, you can run a series of integration tests by
following the instructions listed in the ViewController.m file.

## Bugs

Please post any bugs to the [issue tracker](https://github.com/dropbox/dropbox-sdk-obj-c/issues) found on the project's GitHub page.
  
Please include the following with your issue:
 - a description of what is not working right
 - sample code to help replicate the issue

Thank you!

