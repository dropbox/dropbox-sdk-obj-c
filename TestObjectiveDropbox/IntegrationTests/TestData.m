//
//  TestData.m
//  TestObjectiveDropbox_iOS
//
//  Copyright © 2016 Dropbox. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TestData.h"

@implementation TestData

- (instancetype)init {
  self = [super init];
  if (self) {
    // generic user data
    _testId = [NSString stringWithFormat:@"%d", arc4random_uniform(1000)];
    _baseFolder = @"/Testing/ObjectiveDropboxTests";
    _testFolderName = @"testFolder";
    _testFolderPath = [NSString stringWithFormat:@"%@%@%@%@%@", _baseFolder, @"/", _testFolderName, @"_", _testId];
    _testShareFolderName = @"testShareFolder";
    _testShareFolderPath =
        [NSString stringWithFormat:@"%@%@%@%@%@", _baseFolder, @"/", _testShareFolderName, @"_", _testId];
    _testFileName = @"testFile";
    _testFilePath = [NSString stringWithFormat:@"%@%@%@", _testFolderPath, @"/", _testFileName];
    _testData = @"testing data example";
    _fileData = [_testData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    _fileManager = [NSFileManager defaultManager];
    _directoryURL = [_fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0];
    _destURL = [_directoryURL URLByAppendingPathComponent:_testFileName];
    _destURLException = [_directoryURL
        URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", _testFileName, @"_does_not_exist"]];

    // generic team data
    _testIdTeam = [NSString stringWithFormat:@"%d", arc4random_uniform(1000)];
    _groupName = [NSString stringWithFormat:@"%@%@", @"GroupName", _testIdTeam];
    _groupExternalId = [NSString stringWithFormat:@"%@%@", @"group-", _testIdTeam];

    // personal user data
    _accountId = @"dbid:<ID1>";
    _accountId2 = @"dbid:<ID2>";
    _accountId3 = @"dbid:<ID3>";
    _accountId3Email = @"<EMAIL1>";

    // personal team data
    _teamMemberEmail = @"<EMAIL2>";
    _teamMemberNewEmail = @"<EMAIL3>";
    
    // OAuth 1.0 token
    _oauth1Token = @"<OAUTH_1_TOKEN>";
    _oauth1TokenSecret = @"<OAUTH_1_TOKEN_SECRET>";
    
    // App key and secret
    _fullDropboxAppKey = @"<FULL_DROPBOX_APP_KEY>";
    _fullDropboxAppSecret = @"<FULL_DROPBOX_APP_SECRET>";
    
    _teamMemberFileAccessAppKey = @"<TEAM_MEMBER_FILE_ACCESS_APP_KEY>";
    _teamMemberFileAccessAppSecret = @"<FULL_DROPBOX_APP_SECRET>";
    
    _teamMemberManagementAppKey = @"<TEAM_MEMBER_MANAGEMENT_APP_KEY>";
    _teamMemberManagementAppSecret = @"<TEAM_MEMBER_MANAGEMENT_APP_SECRET>";
  }
  return self;
}

@end
