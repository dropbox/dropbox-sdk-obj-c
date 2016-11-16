///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBConstants.h"
#import "DBTasks.h"
#import "DBTasksStorage.h"

@interface DBTasksStorage ()

@property (nonatomic) NSMutableDictionary<NSString *, DBUploadTask *> * _Nonnull uploadTasks;
@property (nonatomic) NSMutableDictionary<NSString *, DBDownloadUrlTask *> * _Nonnull downloadUrlTasks;
@property (nonatomic) NSMutableDictionary<NSString *, DBDownloadDataTask *> * _Nonnull downloadDataTasks;

@property (nonatomic) BOOL cancel;

@end

@implementation DBTasksStorage

- (instancetype)init {
  self = [super init];
  if (self) {
    _uploadTasks = [NSMutableDictionary new];
    _downloadUrlTasks = [NSMutableDictionary new];
    _downloadDataTasks = [NSMutableDictionary new];
  }
  return self;
}

- (void)cancelAllTasks {
  @synchronized(self) {
    _cancel = YES;

    for (NSString *key in _uploadTasks) {
      DBUploadTask *task = _uploadTasks[key];
      [task cancel];
    }
    for (NSString *key in _downloadUrlTasks) {
      DBDownloadUrlTask *task = _downloadUrlTasks[key];
      [task cancel];
    }
    for (NSString *key in _downloadDataTasks) {
      DBDownloadDataTask *task = _downloadDataTasks[key];
      [task cancel];
    }

    [_uploadTasks removeAllObjects];
    [_downloadUrlTasks removeAllObjects];
    [_downloadDataTasks removeAllObjects];
  }
}

- (void)addUploadTask:(DBUploadTask *)task {
  @synchronized(self) {
    if (!_cancel) {
      NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
      NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
      [_uploadTasks setObject:task forKey:key];
    } else {
      [task cancel];
    }
  }
}

- (void)removeUploadTask:(DBUploadTask *)task {
  @synchronized(self) {
    NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
    NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
    [_uploadTasks removeObjectForKey:key];
  }
}

- (void)addDownloadUrlTask:(DBDownloadUrlTask *)task {
  @synchronized(self) {
    if (!_cancel) {
      NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
      NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
      [_downloadUrlTasks setObject:task forKey:key];
    } else {
      [task cancel];
    }
  }
}

- (void)removeDownloadUrlTask:(DBDownloadUrlTask *)task {
  @synchronized(self) {
    NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
    NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
    [_downloadUrlTasks removeObjectForKey:key];
  }
}

- (void)addDownloadDataTask:(DBDownloadDataTask *)task {
  @synchronized(self) {
    if (!_cancel) {
      NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
      NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
      [_downloadDataTasks setObject:task forKey:key];
    } else {
      [task cancel];
    }
  }
}

- (void)removeDownloadDataTask:(DBDownloadDataTask *)task {
  @synchronized(self) {
    NSString *sessionId = task.session.configuration.identifier ?: kForegroundId;
    NSString *key = [NSString stringWithFormat:@"%@/%lu", sessionId, (unsigned long)task.task.taskIdentifier];
    [_downloadDataTasks removeObjectForKey:key];
  }
}

@end
