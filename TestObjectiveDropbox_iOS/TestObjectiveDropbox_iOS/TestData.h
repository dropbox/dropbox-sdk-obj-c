//
//  TestData.h
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

@interface TestData : NSObject

- (nonnull instancetype)init;

// to avoid name collisions in the event of leftover test state from failure
@property (nonatomic) NSString * _Nonnull testId;

@property (nonatomic) NSString * _Nonnull baseFolder;

@property (nonatomic) NSString * _Nonnull testFolderName;
@property (nonatomic) NSString * _Nonnull testFolderPath;

@property (nonatomic) NSString * _Nonnull testShareFolderName;
@property (nonatomic) NSString * _Nonnull testShareFolderPath;

@property (nonatomic) NSString * _Nonnull testFileName;
@property (nonatomic) NSString * _Nonnull testFilePath;

@property (nonatomic) NSString * _Nonnull testData;

@property (nonatomic) NSData * _Nonnull fileData;
@property (nonatomic) NSFileManager * _Nonnull fileManager;
@property (nonatomic) NSURL * _Nonnull directoryURL;
@property (nonatomic) NSURL * _Nonnull destURL;

@property (nonatomic) NSURL * _Nonnull destURLException;

// team info

@property (nonatomic) NSString * _Nonnull testIdTeam;

@property (nonatomic) NSString * _Nonnull groupName;
@property (nonatomic) NSString * _Nonnull groupExternalId;

// user-specific information

// account ID of the user you OAuth linked with in order to test
@property (nonatomic) NSString * _Nonnull accountId;
// any additional valid Dropbox account ID
@property (nonatomic) NSString * _Nonnull accountId2;
// any additional valid Dropbox account ID
@property (nonatomic) NSString * _Nonnull accountId3;
// the email address of the account whose account ID is `accoundId3`
@property (nonatomic) NSString * _Nonnull accountId3Email;

// team info

// email address of the team user you OAuth link with in order to test
@property (nonatomic) NSString * _Nonnull teamMemberEmail;
@property (nonatomic) NSString * _Nonnull teamMemberNewEmail;


@end
