//
//  TestClasses.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBAUTHRoutes;
@class DBFILESRoutes;
@class DBSHARINGRoutes;
@class DBUSERSRoutes;
@class DBTEAMRoutes;
@class TestData;
@class DBRequestError;

@interface DropboxTester : NSObject

- (nonnull instancetype)initWithTestData:(TestData * _Nonnull)testData;

- (void)testAllUserAPIEndpoints:(DropboxTester * _Nonnull)tester nextTest:(void (^ _Nonnull)())nextTest asMember:(BOOL)asMember;

@property TestData * _Nonnull testData;
@property DBAUTHRoutes * _Nullable auth;
@property DBFILESRoutes * _Nullable files;
@property DBSHARINGRoutes * _Nullable sharing;
@property DBUSERSRoutes * _Nullable users;

@end

@interface DropboxTeamTester : NSObject

- (nonnull instancetype)initWithTestData:(TestData * _Nonnull)testData;

- (void)testAllTeamMemberFileAcessActions:(void (^ _Nonnull)())nextTest;
- (void)testAllTeamMemberManagementActions:(void (^ _Nonnull)())nextTest;

@property DBTEAMRoutes * _Nullable team;
@property TestData * _Nonnull testData;

@end

@interface BatchUploadTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)batchUploadFiles;

@property DropboxTester * _Nonnull tester;

@end

@interface AuthTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)tokenRevoke:(void (^_Nonnull)())nextTest;
- (void)tokenFromOauth1:(void (^_Nonnull)())nextTest;

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
- (void)listFolderLongpollAndTrigger:(void (^_Nonnull)())nextTest;

@property DropboxTester * _Nonnull tester;

@end

@interface SharingTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)shareFolder:(void (^_Nonnull)())nextTest;
- (void)createSharedLinkWithSettings:(void (^_Nonnull)())nextTest;
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

@interface TeamTests : NSObject

- (nonnull instancetype)init:(DropboxTeamTester * _Nonnull)tester;

// TeamMemberFileAccess

- (void)initMembersGetInfo:(void (^_Nonnull)())nextTest;
- (void)listMemberDevices:(void (^_Nonnull)())nextTest;
- (void)listMembersDevices:(void (^_Nonnull)())nextTest;
- (void)linkedAppsListMemberLinkedApps:(void (^_Nonnull)())nextTest;
- (void)linkedAppsListMembersLinkedApps:(void (^_Nonnull)())nextTest;
- (void)getInfo:(void (^_Nonnull)())nextTest;
- (void)reportsGetActivity:(void (^_Nonnull)())nextTest;
- (void)reportsGetDevices:(void (^_Nonnull)())nextTest;
- (void)reportsGetMembership:(void (^_Nonnull)())nextTest;
- (void)reportsGetStorage:(void (^_Nonnull)())nextTest;

// TeamMemberManagement

- (void)groupsCreate:(void (^_Nonnull)())nextTest;
- (void)groupsGetInfo:(void (^_Nonnull)())nextTest;
- (void)groupsList:(void (^_Nonnull)())nextTest;
- (void)groupsMembersAdd:(void (^_Nonnull)())nextTest;
- (void)groupsMembersList:(void (^_Nonnull)())nextTest;
- (void)groupsUpdate:(void (^_Nonnull)())nextTest;
- (void)groupsDelete:(void (^_Nonnull)())nextTest;
- (void)membersAdd:(void (^_Nonnull)())nextTest;
- (void)membersGetInfo:(void (^_Nonnull)())nextTest;
- (void)membersList:(void (^_Nonnull)())nextTest;
- (void)membersSendWelcomeEmail:(void (^_Nonnull)())nextTest;
- (void)membersSetAdminPermissions:(void (^_Nonnull)())nextTest;
- (void)membersSetProfile:(void (^_Nonnull)())nextTest;
- (void)membersRemove:(void (^_Nonnull)())nextTest;

@property DropboxTeamTester * _Nonnull tester;
@property NSString * _Nonnull teamMemberId;
@property NSString * _Nonnull teamMemberId2;

@end

@interface TestFormat : NSObject

+ (void)abort:(DBRequestError * _Nonnull)error routeError:(id _Nonnull)routeError;
+ (void)printErrors:(DBRequestError * _Nonnull)error routeError:(id _Nonnull)routeError;
+ (void)printSentProgress:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend;
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
