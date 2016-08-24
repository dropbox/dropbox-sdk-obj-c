# This SDK will remain in BETA for the next few days, with a scheduled production release at the end of this week.

# Dropbox for Objective C

An Objective C SDK for integrating with the Dropbox API v2.

## Setup

## Creating an application

You need to create an Dropbox Application to make API requests.

- Go to https://dropbox.com/developers/apps.

## Obtaining an access token

All requests need to be made with an OAuth 2 access token. To get started, once
you've created an app, you can go to the app's console and generate an access
token for your own Dropbox account.

## Examples

## Read more

Read more about the Dropbox Objective C SDK on our [developer site](https://www.dropbox.com/developers/documentation/objective-c).

## Modifications

If you're interested in modifying the SDK codebase, clone the GitHub repository to your local filesystem
and run `git submodule init` and then `git submodule update`, then navigate to ./TestObjCDropbox and run `pod install`.
Once this is complete, open the ./TestObjCDropbox/TestObjCDropbox.xcworkspace file with Xcode and proceed to implement your
changes to the SDK source code.

To ensure your changes have not broken any existing functionality, you may run a series of comprehensive unit tests by
following the instructions listed in the ./TestObjCDropbox/TestObjCDropbox/ViewController.m file.
