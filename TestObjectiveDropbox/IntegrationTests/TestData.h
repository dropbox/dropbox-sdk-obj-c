//
//  TestData.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestData : NSObject

- (nonnull instancetype)init;

// to avoid name collisions in the event of leftover test state from failure
@property(nonatomic, copy) NSString * _Nonnull testId;

@property(nonatomic, copy) NSString * _Nonnull baseFolder;

@property(nonatomic, copy) NSString * _Nonnull testFolderName;
@property(nonatomic, copy) NSString * _Nonnull testFolderPath;

@property(nonatomic, copy) NSString * _Nonnull testShareFolderName;
@property(nonatomic, copy) NSString * _Nonnull testShareFolderPath;

@property(nonatomic, copy) NSString * _Nonnull testFileName;
@property(nonatomic, copy) NSString * _Nonnull testFilePath;

@property(nonatomic, copy) NSString * _Nonnull testData;

@property(nonatomic) NSData * _Nonnull fileData;
@property(nonatomic) NSFileManager * _Nonnull fileManager;
@property(nonatomic, copy) NSURL * _Nonnull directoryURL;
@property(nonatomic, copy) NSURL * _Nonnull destURL;

@property(nonatomic, copy) NSURL * _Nonnull destURLException;

// team info

@property(nonatomic, copy) NSString * _Nonnull testIdTeam;

@property(nonatomic, copy) NSString * _Nonnull groupName;
@property(nonatomic, copy) NSString * _Nonnull groupExternalId;

// user-specific information

// account ID of the user you OAuth linked with in order to test
@property(nonatomic, copy) NSString * _Nonnull accountId;
// any additional valid Dropbox account ID
@property(nonatomic, copy) NSString * _Nonnull accountId2;
// any additional valid Dropbox account ID
@property(nonatomic, copy) NSString * _Nonnull accountId3;
// the email address of the account whose account ID is `accoundId3`
@property(nonatomic, copy) NSString * _Nonnull accountId3Email;

// team info

// email address of the team user you OAuth link with in order to test
@property(nonatomic, copy) NSString * _Nonnull teamMemberEmail;
@property(nonatomic, copy) NSString * _Nonnull teamMemberNewEmail;

// OAuth 1.0 token
@property(nonatomic, copy) NSString * _Nonnull oauth1Token;
@property(nonatomic, copy) NSString * _Nonnull oauth1TokenSecret;

// App key and secret
@property(nonatomic, copy) NSString * _Nonnull fullDropboxAppKey;
@property(nonatomic, copy) NSString * _Nonnull fullDropboxAppSecret;

@property(nonatomic, copy) NSString * _Nonnull teamMemberFileAccessAppKey;
@property(nonatomic, copy) NSString * _Nonnull teamMemberFileAccessAppSecret;

@property(nonatomic, copy) NSString * _Nonnull teamMemberManagementAppKey;
@property(nonatomic, copy) NSString * _Nonnull teamMemberManagementAppSecret;

@end
