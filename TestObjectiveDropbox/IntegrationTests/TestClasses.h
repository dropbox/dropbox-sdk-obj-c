//
//  TestClasses.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

#import "TestClasses.h"
#import "TestData.h"
@class TeamTests;

@interface DropboxTester : NSObject
+ (NSArray<NSString *>*_Nonnull)scopesForTests;
- (nonnull instancetype)initWithUserClient:(DBUserClient *_Nonnull)userClient testData:(TestData *_Nonnull)testData;
- (nonnull instancetype)initWithTestData:(TestData * _Nonnull)testData;

- (void)testAllUserAPIEndpoints:(void (^ _Nonnull)(void))nextTest asMember:(BOOL)asMember;
- (void)testFilesEndpoints:(void (^ _Nonnull)(void))nextTest asMember:(BOOL)asMember;

@property TestData * _Nonnull testData;
@property DBAUTHUserAuthRoutes * _Nullable auth;
@property DBFILESUserAuthRoutes * _Nullable files;
@property DBSHARINGUserAuthRoutes * _Nullable sharing;
@property DBUSERSUserAuthRoutes * _Nullable users;

@end

@interface DropboxTeamTester : NSObject
+ (NSArray<NSString *>*_Nonnull)scopesForTests;
- (nonnull instancetype)initWithTeamClient:(DBTeamClient *_Nonnull)teamClient testData:(TestData * _Nonnull)testData;
- (nonnull instancetype)initWithTestData:(TestData * _Nonnull)testData;

- (void)testAllTeamMemberFileAcessActions:(void (^ _Nonnull)(void))nextTest;
- (void)testAllTeamMemberManagementActions:(void (^ _Nonnull)(void))nextTest;

- (void)testTeamMemberFileAcessActions:(void (^ _Nonnull)(TeamTests *_Nonnull))nextTest;
- (void)testTeamMemberManagementActions:(void (^ _Nonnull)(void))nextTest;

@property DBTeamClient * _Nonnull teamClient;
@property TestData * _Nonnull testData;
@property DBTEAMTeamAuthRoutes * _Nonnull team;

@end

@interface BatchUploadTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)batchUploadFiles;

@property DropboxTester * _Nonnull tester;

@end

@interface GlobalResponseTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)runGlobalResponseTests;

@property DropboxTester * _Nonnull tester;

@end

@interface AuthTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)tokenRevoke:(void (^_Nonnull)(void))nextTest;

@property DropboxTester * _Nonnull tester;

@end

@interface FilesTests : NSObject

- (instancetype _Nonnull )init:(DBFILESUserAuthRoutes *_Nonnull)filesRoute
            testData:(TestData *_Nonnull)testData;
- (void)deleteV2:(void (^_Nonnull)(void))nextTest;
- (void)createFolderV2:(void (^_Nonnull)(void))nextTest;
- (void)listFolderError:(void (^_Nonnull)(void))nextTest;
- (void)listFolder:(void (^_Nonnull)(void))nextTest;
- (void)uploadData:(void (^_Nonnull)(void))nextTest;
- (void)uploadDataSession:(void (^_Nonnull)(void))nextTest;
- (void)dCopyV2:(void (^_Nonnull)(void))nextTest;
- (void)dCopyReferenceGet:(void (^_Nonnull)(void))nextTest;
- (void)getMetadata:(void (^_Nonnull)(void))nextTest;
- (void)getMetadataError:(void (^_Nonnull)(void))nextTest;
- (void)getTemporaryLink:(void (^_Nonnull)(void))nextTest;
- (void)listRevisions:(void (^_Nonnull)(void))nextTest;
- (void)moveV2:(void (^_Nonnull)(void))nextTest;
- (void)saveUrl:(void (^_Nonnull)(void))nextTest asMember:(BOOL)asMember;
- (void)downloadToFile:(void (^_Nonnull)(void))nextTest;
- (void)downloadToFileAgain:(void (^_Nonnull)(void))nextTest;
- (void)downloadToFileError:(void (^_Nonnull)(void))nextTest;
- (void)downloadToMemory:(void (^_Nonnull)(void))nextTest;
- (void)downloadToMemoryWithRange:(void (^_Nonnull)(void))nextTest;
- (void)uploadFile:(void (^_Nonnull)(void))nextTest;
- (void)uploadStream:(void (^_Nonnull)(void))nextTest;
- (void)listFolderLongpollAndTrigger:(void (^_Nonnull)(void))nextTest;

@end

@interface SharingTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)shareFolder:(void (^_Nonnull)(void))nextTest;
- (void)createSharedLinkWithSettings:(void (^_Nonnull)(void))nextTest;
- (void)getFolderMetadata:(void (^_Nonnull)(void))nextTest;
- (void)addFolderMember:(void (^_Nonnull)(void))nextTest;
- (void)listFolderMembers:(void (^_Nonnull)(void))nextTest;
- (void)listFolders:(void (^_Nonnull)(void))nextTest;
- (void)listSharedLinks:(void (^_Nonnull)(void))nextTest;
- (void)removeFolderMember:(void (^_Nonnull)(void))nextTest;
- (void)revokeSharedLink:(void (^_Nonnull)(void))nextTest;
- (void)unmountFolder:(void (^_Nonnull)(void))nextTest;
- (void)mountFolder:(void (^_Nonnull)(void))nextTest;
- (void)updateFolderPolicy:(void (^_Nonnull)(void))nextTest;
- (void)unshareFolder:(void (^_Nonnull)(void))nextTest;

@property DropboxTester * _Nonnull tester;
@property NSString * _Nonnull sharedFolderId;
@property NSString * _Nullable sharedLink;

@end

@interface UsersTests : NSObject

- (nonnull instancetype)init:(DropboxTester * _Nonnull)tester;

- (void)getAccount:(void (^_Nonnull)(void))nextTest;
- (void)getAccountBatch:(void (^_Nonnull)(void))nextTest;
- (void)getCurrentAccount:(void (^_Nonnull)(void))nextTest;
- (void)getSpaceUsage:(void (^_Nonnull)(void))nextTest;

@property DropboxTester * _Nonnull tester;

@end

@interface TeamTests : NSObject

- (nonnull instancetype)init:(DropboxTeamTester * _Nonnull)tester;

// TeamMemberFileAccess
- (void)initMembersGetInfoAndMemberId:(void (^_Nonnull)(NSString * _Nullable))nextTest;
- (void)initMembersGetInfo:(void (^_Nonnull)(void))nextTest;
- (void)listMemberDevices:(void (^_Nonnull)(void))nextTest;
- (void)listMembersDevices:(void (^_Nonnull)(void))nextTest;
- (void)linkedAppsListMemberLinkedApps:(void (^_Nonnull)(void))nextTest;
- (void)linkedAppsListMembersLinkedApps:(void (^_Nonnull)(void))nextTest;
- (void)getInfo:(void (^_Nonnull)(void))nextTest;

// TeamMemberManagement

- (void)groupsCreate:(void (^_Nonnull)(void))nextTest;
- (void)groupsGetInfo:(void (^_Nonnull)(void))nextTest;
- (void)groupsList:(void (^_Nonnull)(void))nextTest;
- (void)groupsMembersAdd:(void (^_Nonnull)(void))nextTest;
- (void)groupsMembersList:(void (^_Nonnull)(void))nextTest;
- (void)groupsUpdate:(void (^_Nonnull)(void))nextTest;
- (void)groupsDelete:(void (^_Nonnull)(void))nextTest;
- (void)membersAdd:(void (^_Nonnull)(void))nextTest;
- (void)membersGetInfo:(void (^_Nonnull)(void))nextTest;
- (void)membersList:(void (^_Nonnull)(void))nextTest;
- (void)membersListDevices:(void (^_Nonnull)(void))nextTest;
- (void)membersSendWelcomeEmail:(void (^_Nonnull)(void))nextTest;
- (void)membersSetAdminPermissions:(void (^_Nonnull)(void))nextTest;
- (void)membersSetProfile:(void (^_Nonnull)(void))nextTest;
- (void)membersRemove:(void (^_Nonnull)(void))nextTest;

@property DropboxTeamTester * _Nonnull tester;
@property NSString * _Nonnull teamMemberId;
@property NSString * _Nonnull teamMemberId2;

@end

@interface TestFormat : NSObject

+ (void)abort:(DBRequestError * _Nonnull)error
   routeError:(id _Nonnull)routeError;
+ (void)printErrors:(DBRequestError * _Nonnull)error
         routeError:(id _Nonnull)routeError;
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
