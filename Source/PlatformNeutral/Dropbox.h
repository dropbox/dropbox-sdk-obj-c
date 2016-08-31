///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DropboxClient.h"
#import "DropboxTeamClient.h"

#if TARGET_OS_IPHONE
#import "DropboxClientsManager+MobileAuth.h"

#elif TARGET_OS_MAC
#import "DropboxClientsManager+DesktopAuth.h"

#endif