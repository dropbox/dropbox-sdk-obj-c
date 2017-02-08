///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

///
/// Information for returning to the official Dropbox app.
///
@interface DBOpenWithInfo : NSObject <NSCoding>

/// the Dropbox user ID of the current user.
@property (nonatomic, copy) NSString * _Nonnull userId;

/// the Dropbox revision for the file
@property (nonatomic, copy) NSString * _Nonnull rev;

/// the Dropbox path for the file
@property (nonatomic, copy) NSString * _Nonnull path;

/// the time the file was modified last
@property (nonatomic, copy) NSDate * _Nullable modifiedTime;

/// whether the file is read only or not
@property (nonatomic) BOOL readOnly;

/// the Dropbox verb associated with the file
@property (nonatomic, copy) NSString * _Nonnull verb;

/// the Dropbox session ID associated with the file
@property (nonatomic, copy) NSString * _Nullable sessionId;

/// the Dropbox file ID associated with the file
@property (nonatomic, copy) NSString * _Nullable fileId;

/// relevant Dropbox file data associated with the file
@property (nonatomic, copy) NSData * _Nullable fileData;

/// the source application from which the file content originated
@property (nonatomic, copy) NSString * _Nullable sourceApp;

///
/// Initializer containing the parameters that we were opened with. Some of these parameters are necessary to return to
/// the originating Dropbox app. There are now two Dropbox apps: the regular Dropbox app and the Dropbox EMM app. Either
/// can open with.
///
/// @param userId the Dropbox user ID of the current user.
/// @param rev the Dropbox revision for the file
/// @param path the Dropbox path for the file
/// @param modifiedTime the time the file was modified last
/// @param readOnly whether the file is read only or not
/// @param verb the action type to be taken on the file (e.g. EDIT) supplied by the official app
/// @param sessionId the Dropbox session ID supplied by the official app
/// @param fileId the Dropbox file ID associated with the file
/// @param fileData relevant Dropbox file data associated with the file
/// @param sourceApp the source application from which the file content originated
///
- (id _Nonnull)initWithUserId:(NSString * _Nonnull)userId
                          rev:(NSString * _Nonnull)rev
                         path:(NSString * _Nonnull)path
                 modifiedTime:(NSDate * _Nullable)modifiedTime
                     readOnly:(BOOL)readOnly
                         verb:(NSString * _Nonnull)verb
                    sessionId:(NSString * _Nullable)sessionId
                       fileId:(NSString * _Nullable)fileId
                     fileData:(NSData * _Nullable)fileData
                    sourceApp:(NSString * _Nullable)sourceApp;

///
/// Saves open with info to disc.
///
/// @param sessionId the Dropbox session ID supplied by the official app to be used as a storage lookup
///
- (void)writeToStorageForSession:(NSString * _Nullable)sessionId;

///
/// Retrieves open with info from disc.
///
/// @param sessionId the Dropbox session ID supplied by the official app to be used as a storage lookup
///
+ (DBOpenWithInfo * _Nullable)popFromStorageForSession:(NSString * _Nonnull)sessionId;

@end
