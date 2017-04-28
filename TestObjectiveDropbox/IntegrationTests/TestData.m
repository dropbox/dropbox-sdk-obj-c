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
    _accountId = @"dbid:AABL4QRrY7tB9viLgPUqmjkzE6Fe5ujlnlE";
    _accountId2 = @"dbid:AABZqArm5N_YcH1YxpVbjEWkdzGkYQ6mkqk";
    _accountId3 = @"dbid:AABi4KhsNtI1RhK-uQINEWkim3ucF-ASWgE";
    _accountId3Email = @"scobbe502+test1@gmail.com";
    
    // personal team data
    _teamMemberEmail = @"scobbe502+dfb@gmail.com";
    _teamMemberNewEmail = @"scobbe@yahoo.com";
    
    // OAuth 1.0 token
    _oauth1Token = @"af8oagaahpio0pqf";
    _oauth1TokenSecret = @"pdfkj7uqqskqyc2";
    
    // App key and secret
    _fullDropboxAppKey = @"4adrwp5qg3jf2lz";
    _fullDropboxAppSecret = @"b8rah3119t9bgzy";
    
    _teamMemberFileAccessAppKey = @"ye8gk3g89l1qzti";
    _teamMemberFileAccessAppSecret = @"ih95mtheg11fxq2";
    
    _teamMemberManagementAppKey = @"58b6omn1ngccg9r";
    _teamMemberManagementAppSecret = @"tptdjks2gnoib7q";
  }
  return self;
}

@end
