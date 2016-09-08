//
//  PhotoViewController.m
//  DBRoulette
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import "DropboxSDKImports.h"
#import "PhotoViewController.h"

@interface PhotoViewController ()

@property(weak, nonatomic) IBOutlet UIButton *randomPhotoButton;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation PhotoViewController

- (IBAction)randomPhotoButtonPressed:(id)sender {
  [self setStarted];

  DropboxClient *client = [DropboxClientsManager authorizedClient];

  NSString *searchPath = @"/Apps/Test App 50000";

  // list folder metadata contents (folder will be root "/" Dropbox folder if app has permission
  // "Full Dropbox" or "/Apps/<APP_NAME>/" if app has permission "App Folder").
  [[client.filesRoutes listFolder:searchPath]
      response:^(DBFILESListFolderResult *result, DBFILESListFolderError *routeError, DBError *error) {
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

          UIAlertController *alertController =
              [UIAlertController alertControllerWithTitle:title
                                                  message:message
                                           preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
          [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                              style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                            handler:nil]];
          [self presentViewController:alertController animated:YES completion:nil];

          [self setFinished];
        }
      }];
}

- (void)displayPhotos:(NSArray<DBFILESMetadata *> *)folderEntries {
  NSMutableArray<NSString *> *imagePaths = [NSMutableArray new];
  NSLog(@"ENTRIES: %@", folderEntries);
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
    NSString *message = @"There are currently no valid image files in the specified search path in your Dropbox. "
                        @"Please add some images and try again.";
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:message
                                     preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
    [alertController
        addAction:[UIAlertAction actionWithTitle:@"OK" style:(UIAlertActionStyle)UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    [self setFinished];
  }
}

- (BOOL)isImageType:(NSString *)itemName {
  __block BOOL result = NO;

  NSError *error;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\.jpeg|\\.jpg|\\.JPEG|\\.png]"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  [regex enumerateMatchesInString:itemName
                          options:0
                            range:NSMakeRange(0, [itemName length])
                       usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) {
                         result = YES;
                       }];
  if (error) {
    NSLog(@"ERROR: %@", error);
  }
  return result;
}

- (void)downloadImage:(NSString *)imagePath {
  DropboxClient *client = [DropboxClientsManager authorizedClient];

  NSLog(@"IMAGE PATH: %@", imagePath);

  [[client.filesRoutes getThumbnailData:imagePath]
      response:^(DBFILESFileMetadata *result, DBFILESThumbnailError *routeError, DBError *error, NSData *fileData) {
        if (result) {
          NSLog(@"yo");
        } else {
          NSString *title = @"";
          NSString *message = @"";
          if (routeError) {
            // Route-specific request error
            title = @"Route-specific error";
            if ([routeError isPath]) {
              message = [NSString stringWithFormat:@"Invalid path: %@", routeError];
            } else if ([routeError isUnsupportedExtension]) {
              message = [NSString stringWithFormat:@"Unsupported extension: %@", routeError];
            } else if ([routeError isUnsupportedImage]) {
              message = [NSString stringWithFormat:@"Unsupported image: %@", routeError];
            } else if ([routeError isConversionError]) {
              message = [NSString stringWithFormat:@"Conversion error: %@", routeError];
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

          UIAlertController *alertController =
              [UIAlertController alertControllerWithTitle:title
                                                  message:message
                                           preferredStyle:(UIAlertControllerStyle)UIAlertControllerStyleAlert];
          [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                              style:(UIAlertActionStyle)UIAlertActionStyleCancel
                                                            handler:nil]];
          [self presentViewController:alertController animated:YES completion:nil];

          [self setFinished];
        }
      }];
}

- (void)setStarted {
  [_indicatorView startAnimating];
  _indicatorView.hidden = NO;
}

- (void)setFinished {
  [_indicatorView stopAnimating];
  _indicatorView.hidden = YES;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _indicatorView.hidden = YES;
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
