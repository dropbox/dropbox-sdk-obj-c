///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <UIKit/UIKit.h>

#import "DBOfficialAppConnector-iOS.h"
#import "DBOpenWithInfo-iOS.h"

static NSString *kDBOpenWithPasteboard = @"dropbox.openWith";
static NSString *kDropboxScheme = @"dbapi-5";
static NSString *kDropboxEMMScheme = @"dbapi-8-emm";
static double kMaxInstallTime = -15 * 60; // 15 minutes ago
static NSString *kDBOpenURLAppDropbox = @"Dropbox";
static NSString *kDBOpenURLAppDropboxEMM = @"DropboxEMM";

///
/// @note This logic is for official Dropbox partners only, and should not need
/// to be used by other third-party apps.
///
@implementation DBOfficialAppConnector {
  NSString *_appKey;
}

- (instancetype)initWithAppKey:(NSString *)appKey {
  if (self = [super init]) {
    _appKey = appKey;
  }
  return self;
}

- (void)returnToDropboxApp:(DBOpenWithInfo *)openWithInfo
            changesPending:(BOOL)changesPending
            openURLWrapper:(void (^_Nonnull)(NSURL * _Nonnull))openURLWrapper {
  [self returnToDropboxApp:openWithInfo
            changesPending:changesPending
                 errorName:nil
                    extras:nil
            openURLWrapper:openURLWrapper];
}

- (void)returnToDropboxApp:(DBOpenWithInfo *)openWithInfo
            changesPending:(BOOL)changesPending
                 errorName:(NSString *)errorName
                    extras:(NSDictionary *)extras
            openURLWrapper:(void (^_Nonnull)(NSURL * _Nonnull))openURLWrapper {
  NSMutableDictionary *query = [self db_dictForOfficialDropboxCallAtPath:openWithInfo.path
                                                            lastRevision:(NSString *)openWithInfo.rev
                                                                  userId:(NSString *)openWithInfo.userId
                                                               sessionId:(NSString *)openWithInfo.sessionId
                                                          changesPending:(BOOL)changesPending
                                                               errorName:(NSString *)errorName
                                                                  extras:(NSDictionary *)extras];
  query[@"origin"] = @"dropboxInitiated";
  [self db_handleUrlOpenWithURL:@"viewPath"
                         params:query
                     dropboxApp:openWithInfo.sourceApp
                 openURLWrapper:openURLWrapper];
}

+ (DBOpenWithInfo *)retriveOfficialDropboxAppOpenWithInfo {
  NSIndexSet *indexSet =
      [[UIPasteboard generalPasteboard] itemSetWithPasteboardTypes:[NSArray arrayWithObject:kDBOpenWithPasteboard]];
  NSArray *valuesArray = nil;
  if ([indexSet count]) {
    valuesArray = [[UIPasteboard generalPasteboard] valuesForPasteboardType:kDBOpenWithPasteboard inItemSet:indexSet];
  }
  NSDictionary *pasteboardDictionary = nil;
  if (valuesArray) {
    pasteboardDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:valuesArray[0]];
  }

  if (pasteboardDictionary && [pasteboardDictionary valueForKey:@"path"] &&
      [pasteboardDictionary valueForKey:@"userId"] && [pasteboardDictionary valueForKey:@"pasteboardCreationTime"]) {
    if ([[[[self class] dateFormatter] dateFromString:[pasteboardDictionary valueForKey:@"pasteboardCreationTime"]]
            timeIntervalSinceNow] < kMaxInstallTime) {
      return nil;
    }

    DBOpenWithInfo *openWithInfo = [[DBOpenWithInfo alloc]
        initWithUserId:[pasteboardDictionary valueForKey:@"userId"]
                   rev:[pasteboardDictionary valueForKey:@"rev"]
                  path:[pasteboardDictionary valueForKey:@"path"]
          modifiedTime:[[[self class] dateFormatter] dateFromString:[pasteboardDictionary valueForKey:@"modifiedTime"]]
              readOnly:[[pasteboardDictionary valueForKey:@"readOnly"] boolValue]
                  verb:[pasteboardDictionary valueForKey:@"verb"]
             sessionId:[pasteboardDictionary valueForKey:@"sessionId"]
                fileId:[pasteboardDictionary valueForKey:@"fileId"]
              fileData:nil
             sourceApp:[pasteboardDictionary valueForKey:@"sourceApp"]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      NSMutableArray *existingItems = [[[UIPasteboard generalPasteboard] items] mutableCopy];
      [existingItems removeObjectsAtIndexes:indexSet];
      [[UIPasteboard generalPasteboard] setItems:existingItems];
    });

    return openWithInfo;
  }
  return nil;
}

+ (NSDateFormatter *)dateFormatter {
  NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
  static NSString *dateFormatterKey = @"DBMetadataDateFormatter";

  NSDateFormatter *dateFormatter = [dictionary objectForKey:dateFormatterKey];
  if (dateFormatter == nil) {
    dateFormatter = [NSDateFormatter new];
    // Must set locale to ensure consistent parsing:
    // http://developer.apple.com/iphone/library/qa/qa2010/qa1480.html
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"enUSPOSIX"];
    dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
    [dictionary setObject:dateFormatter forKey:dateFormatterKey];
  }
  return dateFormatter;
}

+ (BOOL)isRequiredDropboxAppInstalled {
  return [DBOfficialAppConnector db_canOpenScheme:kDropboxScheme] ||
         [DBOfficialAppConnector db_canOpenScheme:kDropboxEMMScheme];
}

- (NSMutableDictionary *)db_dictForOfficialDropboxCallAtPath:(NSString *)path
                                                lastRevision:(NSString *)lastRev
                                                      userId:(NSString *)userId
                                                   sessionId:(NSString *)sessionId
                                              changesPending:(BOOL)changesPending
                                                   errorName:(NSString *)errorName
                                                      extras:(NSDictionary *)extras {
  NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
  [params setValue:path forKey:@"path"];
  [params setValue:lastRev forKey:@"rev"];
  [params setValue:userId forKey:@"userId"];
  [params setValue:sessionId forKey:@"sessionId"];
  [params setValue:changesPending ? @"1" : @"0" forKey:@"changesPending"];
  [params setValue:errorName forKey:@"errorName"];

  NSURLComponents *components = [NSURLComponents new];
  NSMutableArray *queryItems = [NSMutableArray array];
  for (NSString *key in extras) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:extras[key]]];
  }
  components.queryItems = queryItems;
  NSString *extraInfo = [[components.URL absoluteString] stringByReplacingOccurrencesOfString:@"?" withString:@""];
  [params setValue:extraInfo forKey:@"extraInfo"];

  return params;
}

///
/// Returns the custom url scheme to open the Dropbox app with. If the app isn't installed we default to trying the
/// Dropbox app first then the Dropbox EMM app.
///
+ (nullable NSString *)db_schemeToOpenDropboxApp:(nullable NSString *)app {
  if ([app isEqualToString:kDBOpenURLAppDropbox] && [DBOfficialAppConnector db_canOpenScheme:kDropboxScheme]) {
    return kDropboxScheme;
  }

  if ([app isEqualToString:kDBOpenURLAppDropboxEMM] && [DBOfficialAppConnector db_canOpenScheme:kDropboxEMMScheme]) {
    return kDropboxEMMScheme;
  }

  if ([DBOfficialAppConnector db_canOpenScheme:kDropboxScheme]) {
    return kDropboxScheme;
  }

  if ([DBOfficialAppConnector db_canOpenScheme:kDropboxEMMScheme]) {
    return kDropboxEMMScheme;
  }

  return nil;
}

+ (BOOL)db_canOpenScheme:(NSString *)scheme {
  NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@://", scheme]];
  return [[UIApplication sharedApplication] canOpenURL:URL];
}

///
/// Opens the url using the Dropbox app. If app is nil, this defaults to the consumer Dropbox app
///
- (void)db_handleUrlOpenWithURL:(NSString *)subPath
                         params:(NSDictionary *)params
                     dropboxApp:(NSString *)app
                 openURLWrapper:(void (^_Nonnull)(NSURL * _Nonnull))openURLWrapper {
  NSString *scheme = [DBOfficialAppConnector db_schemeToOpenDropboxApp:app];
  if (!scheme) {
    return;
  }

  NSMutableDictionary *mutableParams = [params mutableCopy];

  [mutableParams setValue:_appKey forKeyPath:@"k"];
  assert(![mutableParams[@"k"] isEqualToString:@""]);
  NSURLComponents *components = [NSURLComponents new];
  [components setScheme:scheme];
  [components setPath:[NSString stringWithFormat:@"/1/%@", subPath]];

  NSMutableArray *queryItems = [NSMutableArray array];
  for (NSString *key in mutableParams) {
    [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:mutableParams[key]]];
  }
  components.queryItems = queryItems;

  dispatch_async(dispatch_get_main_queue(), ^{
    NSLog(@"URL open: %@", [components URL]);
    openURLWrapper([components URL]);
  });
}

@end
