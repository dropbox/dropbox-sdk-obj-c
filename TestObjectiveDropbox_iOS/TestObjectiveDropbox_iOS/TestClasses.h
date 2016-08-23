//
//  TestClasses.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DbxAuthRoutes;
@class DbxFilesRoutes;
@class DbxSharingRoutes;
@class DbxUsersRoutes;
@class DbxTeamRoutes;
@class TestData;
@class DbxError;

@interface DropboxTester : NSObject

- (nonnull instancetype)initWithTestData:(TestData * _Nonnull)testData;

@property TestData * _Nonnull testData;
@property DbxAuthRoutes * _Nullable auth;
@property DbxFilesRoutes * _Nullable files;
@property DbxSharingRoutes * _Nullable sharing;
@property DbxUsersRoutes * _Nullable users;

@end


@interface DropboxTeamTester : NSObject

@property DbxTeamRoutes * _Nullable team;

@end


@interface AuthTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)tokenRevoke:(void (^_Nonnull)())nextTest;

@property DropboxTester * _Nonnull tester;

@end


@interface FilesTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)delete_:(void (^_Nonnull)())nextTest;
- (void)createFolder:(void (^_Nonnull)())nextTest;
- (void)listFolderError:(void (^_Nonnull)())nextTest;
- (void)listFolder:(void (^_Nonnull)())nextTest;
- (void)uploadData:(void (^_Nonnull)())nextTest;
- (void)uploadDataSession:(void (^_Nonnull)())nextTest;
- (void)dCopy:(void (^_Nonnull)())nextTest;
- (void)dCopyReferenceGet:(void (^_Nonnull)())nextTest;
- (void)getMetadata:(void (^_Nonnull)())nextTest;
- (void)getMetadataError:(void (^_Nonnull)())nextTest;
- (void)getTemporaryLink:(void (^_Nonnull)())nextTest;
- (void)listRevisions:(void (^_Nonnull)())nextTest;
- (void)move:(void (^_Nonnull)())nextTest;
- (void)saveUrl:(void (^_Nonnull)())nextTest asMember:(BOOL)asMember;
- (void)downloadToFile:(void (^_Nonnull)())nextTest;
- (void)downloadToFileAgain:(void (^_Nonnull)())nextTest;
- (void)downloadToFileError:(void (^_Nonnull)())nextTest;
- (void)downloadToMemory:(void (^_Nonnull)())nextTest;
- (void)uploadFile:(void (^_Nonnull)())nextTest;
- (void)uploadStream:(void (^_Nonnull)())nextTest;
- (void)listFolderLongpollAndTrigger:(void (^_Nonnull)())nextTest asMember:(BOOL)asMember;

@property DropboxTester * _Nonnull tester;

@end


@interface SharingTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)shareFolder:(void (^_Nonnull)())nextTest;
- (void)createSharedLinkWithSettings:(void (^)())nextTest;
- (void)getFolderMetadata:(void (^_Nonnull)())nextTest;
- (void)getSharedLinkMetadata:(void (^_Nonnull)())nextTest;
- (void)addFolderMember:(void (^_Nonnull)())nextTest;
- (void)listFolderMembers:(void (^_Nonnull)())nextTest;
- (void)listFolders:(void (^_Nonnull)())nextTest;
- (void)listSharedLinks:(void (^_Nonnull)())nextTest;
- (void)removeFolderMember:(void (^_Nonnull)())nextTest;
- (void)revokeSharedLink:(void (^_Nonnull)())nextTest;
- (void)unmountFolder:(void (^_Nonnull)())nextTest;
- (void)mountFolder:(void (^_Nonnull)())nextTest;
- (void)updateFolderPolicy:(void (^_Nonnull)())nextTest;
- (void)unshareFolder:(void (^_Nonnull)())nextTest;

@property DropboxTester * _Nonnull tester;
@property NSString * _Nonnull sharedFolderId;
@property NSString * _Nonnull sharedLink;

@end


@interface UsersTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)getAccount:(void (^_Nonnull)())nextTest;
- (void)getAccountBatch:(void (^_Nonnull)())nextTest;
- (void)getCurrentAccount:(void (^_Nonnull)())nextTest;
- (void)getSpaceUsage:(void (^_Nonnull)())nextTest;

@property DropboxTester * _Nonnull tester;

@end


@interface TestFormat : NSObject

+ (void)abort:(DbxError * _Nonnull)error routeError:(id _Nonnull)routeError;
+ (void)printErrors:(DbxError * _Nonnull)error routeError:(id _Nonnull)routeError;
+ (void)printSentProgress:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
+ (void)printTestBegin:(NSString * _Nonnull)title;
+ (void)printTestEnd;
+ (void)printAllTestsEnd;
+ (void)printSubTestBegin:(NSString * _Nonnull)title;
+ (void)printSubTestEnd:(NSString * _Nonnull)result;
+ (void)printTitle:(NSString * _Nonnull)title;
+ (void)printOffset:(NSString * _Nonnull)str;
+ (void)printSmallDivider;
+ (void)printLargeDivider;

@end