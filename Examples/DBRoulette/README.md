## DBRoulette Example App

### Register your application

Before using this sample app, you should register your application in the [Dropbox App Console](https://dropbox.com/developers/apps). This creates a record of your app with Dropbox that will be associated with the API calls you make.

### Obtain an OAuth2 token

All requests need to be made with an OAuth2 access token. An OAuth token represents an authenticated link between a Dropbox app and
a Dropbox user account or team.

Once you've created an app, you can go to the App Console and manually generate an access token to authorize your app to access your own Dropbox account.
Otherwise, you can obtain an OAuth token programmatically using the SDK's pre-defined auth flow. For more information, [see below](https://github.com/dropbox/dropbox-sdk-obj-c#handling-authorization-flow).

### Overview

DBRoulette is a simple sample app that uses the Dropbox API v2 Objective-C SDK (integrated via **CocoaPods** in one project, **Carthage** in the other, and finally as a **Xcode subproject**) to query the Dropbox API.

The app requires the user to login to their Dropbox user account:

<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/DBRouletteAuthView.png?raw=true" alt="DBRoulette Auth View"/>
</p>

And then redirects them to a view where they can pull random photos from their Dropbox account:

<p align="center">
  <img src="https://github.com/dropbox/dropbox-sdk-obj-c/blob/master/Images/DBRouletteView.png?raw=true" alt="DBRoulette Main View"/>
</p>

If the Dropbox app has **Full Dropbox** permissions, this looks for all `.jpg`/`.png` files in the `/` folder of a user's Dropbox. If the Dropbox
app has **App Folder** permissions, this looks for all `.jpg`/`.png` files in the `/Apps/DBRoulette` folder of the user's Dropbox.

#### Sample app setup

To begin using the DBRoulette sample app, you should do the following:

* add your app key's value to the `appKey` variable in `AppDelegate.m`
* add your app key's value to the URL Schemes array (`db-<APP_KEY>`) in `Info.plist`

#### API calls

DBRoulette showcases how to call two Dropbox User API endpoints, along with all the necessary error handling.

First, DBRoulette queries the [list_folder](https://www.dropbox.com/developers/documentation/http/documentation#files-list_folder) endpoint to list all the contents in either the `/` folder of the user's Dropbox account (if app has **Full Dropbox** 
permission) or in `/Apps/DBRoulette` folder of the user's Dropbox (if app has **App Folder** permission).

Then, DBRoulette filters the metadata result for all files with `.jpg` and `.png` extensions, and chooses one at random. Then, DBRoulette queries the [download](https://www.dropbox.com/developers/documentation/http/documentation#files-download) endpoint to
download the file contents and render it.
