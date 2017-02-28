//
//  PhotoViewController.m
//  DBRoulette
//
//  Created by Stephen Cobbe on 2/27/17.
//  Copyright © 2017 Dropbox. All rights reserved.
//

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "PhotoViewController.h"

@interface PhotoViewController ()

@property (weak) IBOutlet NSButton *randomPhotoButton;
@property (nonatomic) NSImageView *currentImageView;
@property (weak) IBOutlet NSProgressIndicator *indicator;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  _indicator.hidden = YES;
}


- (void)setRepresentedObject:(id)representedObject {
  [super setRepresentedObject:representedObject];
  
  // Update the view, if already loaded.
}

- (IBAction)randomPhotoButtonPressed:(id)sender {
  [self setStarted];
  
  if (_currentImageView) {
    [_currentImageView removeFromSuperview];
  }
  
  DBUserClient *client = [DBClientsManager authorizedClient];
  
  NSString *searchPath = @"";
  
  // list folder metadata contents (folder will be root "/" Dropbox folder if app has permission
  // "Full Dropbox" or "/Apps/<APP_NAME>/" if app has permission "App Folder").
  [[client.filesRoutes listFolder:searchPath]
   setResponseBlock:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBRequestError *error) {
     if (result) {
       [self displayPhotos:result.entries];
     } else {
       NSString *title = @"";
       NSString *message = @"";
       if (routeError) {
         // Route-specific request error
         title = @"Route-specific error";
         if ([routeError isPath]) {
           message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
         }
       } else {
         // Generic request error
         title = @"Generic request error";
         if ([error isInternalServerError]) {
           DBRequestInternalServerError *internalServerError = [error asInternalServerError];
           message = [NSString stringWithFormat:@"%@", internalServerError];
         } else if ([error isBadInputError]) {
           DBRequestBadInputError *badInputError = [error asBadInputError];
           message = [NSString stringWithFormat:@"%@", badInputError];
         } else if ([error isAuthError]) {
           DBRequestAuthError *authError = [error asAuthError];
           message = [NSString stringWithFormat:@"%@", authError];
         } else if ([error isRateLimitError]) {
           DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
           message = [NSString stringWithFormat:@"%@", rateLimitError];
         } else if ([error isHttpError]) {
           DBRequestHttpError *genericHttpError = [error asHttpError];
           message = [NSString stringWithFormat:@"%@", genericHttpError];
         } else if ([error isClientError]) {
           DBRequestClientError *genericLocalError = [error asClientError];
           message = [NSString stringWithFormat:@"%@", genericLocalError];
         }
       }
       [self presentErrorWithTitle:title message:message];
       [self setFinished];
     }
   }];
}

- (void)displayPhotos:(NSArray<DBFILESMetadata *> *)folderEntries {
  NSMutableArray<NSString *> *imagePaths = [NSMutableArray new];
  for (DBFILESMetadata *entry in folderEntries) {
    NSString *itemName = entry.name;
    if ([self isImageType:itemName]) {
      [imagePaths addObject:entry.pathDisplay];
    }
  }
  
  if ([imagePaths count] > 0) {
    NSString *imagePathToDownload = imagePaths[arc4random_uniform((int)[imagePaths count] - 1)];
    [self downloadImage:imagePathToDownload];
  } else {
    NSString *title = @"No images found";
    NSString *message = @"There are currently no valid image files in the specified search path in your Dropbox. Please add some images and try again.";
    [self presentErrorWithTitle:title message:message];
    [self setFinished];
  }
}

- (BOOL)isImageType:(NSString *)itemName {
  NSRange range = [itemName rangeOfString:@"\\.jpeg|\\.jpg|\\.JPEG|\\.JPG|\\.png" options:NSRegularExpressionSearch];
  return range.location != NSNotFound;
}

- (void)downloadImage:(NSString *)imagePath {
  DBUserClient *client = [DBClientsManager authorizedClient];
  [[client.filesRoutes downloadData:imagePath]
   setResponseBlock:^(DBFILESFileMetadata *result, DBFILESDownloadError *routeError, DBRequestError *error, NSData *fileData) {
     if (result) {
       NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(300, 300, 300, 300)];
       [imageView setImage:[[NSImage alloc] initWithData:fileData]];
       [imageView setFrameOrigin:NSMakePoint(self.view.bounds.size.width/2, self.view.bounds.size.height/2)];
       [imageView setFrameOrigin:NSMakePoint(
                                           (NSWidth([self.view bounds]) - NSWidth([imageView frame])) / 2,
                                           (NSHeight([self.view  bounds]) - NSHeight([imageView frame])) / 2
                                           )];
       [imageView setAutoresizingMask:NSViewMinXMargin | NSViewMaxXMargin | NSViewMinYMargin | NSViewMaxYMargin];
       [self.view addSubview:imageView];
       _currentImageView = imageView;
       [self setFinished];
     } else {
       NSString *title = @"";
       NSString *message = @"";
       if (routeError) {
         // Route-specific request error
         title = @"Route-specific error";
         if ([routeError isPath]) {
           message = [NSString stringWithFormat:@"Invalid path: %@", routeError.path];
         } else if ([routeError isOther]) {
           message = [NSString stringWithFormat:@"Unknown error: %@", routeError];
         }
       } else {
         // Generic request error
         title = @"Generic request error";
         if ([error isInternalServerError]) {
           DBRequestInternalServerError *internalServerError = [error asInternalServerError];
           message = [NSString stringWithFormat:@"%@", internalServerError];
         } else if ([error isBadInputError]) {
           DBRequestBadInputError *badInputError = [error asBadInputError];
           message = [NSString stringWithFormat:@"%@", badInputError];
         } else if ([error isAuthError]) {
           DBRequestAuthError *authError = [error asAuthError];
           message = [NSString stringWithFormat:@"%@", authError];
         } else if ([error isRateLimitError]) {
           DBRequestRateLimitError *rateLimitError = [error asRateLimitError];
           message = [NSString stringWithFormat:@"%@", rateLimitError];
         } else if ([error isHttpError]) {
           DBRequestHttpError *genericHttpError = [error asHttpError];
           message = [NSString stringWithFormat:@"%@", genericHttpError];
         } else if ([error isClientError]) {
           DBRequestClientError *genericLocalError = [error asClientError];
           message = [NSString stringWithFormat:@"%@", genericLocalError];
         }
       }

       [self presentErrorWithTitle:title message:message];
       [self setFinished];
     }
   }];
}

- (void)presentErrorWithTitle:(NSString *)title message:(NSString *)message {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert setMessageText:title];
  [alert setInformativeText:message];
  [alert addButtonWithTitle:@"Cancel"];
  [alert addButtonWithTitle:@"Ok"];
  [alert runModal];
}

- (void)setStarted {
  _indicator.hidden = NO;
  [_indicator startAnimation:nil];
}

- (void)setFinished {
  _indicator.hidden = YES;
  [_indicator stopAnimation:nil];
}

- (void)checkButtons {
  if ([DBClientsManager authorizedClient] || [DBClientsManager authorizedTeamClient]) {
    [_randomPhotoButton setEnabled:YES];
  } else {
    [_randomPhotoButton setEnabled:NO];
  }
}

@end
