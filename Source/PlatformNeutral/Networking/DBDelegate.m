///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBDelegate.h"
#import "DBSessionData.h"

static NSString const *const kForegroundId = @"com.dropbox.dropbox_sdk_obj_c_foreground";

@interface DBDelegate ()

@property(nonatomic) NSOperationQueue * _Nonnull delegateQueue;
@property(nonatomic) NSMutableDictionary<NSString *, DBSessionData *> * _Nonnull sessionData;

@end

#pragma mark - Initializers

@implementation DBDelegate

- (instancetype)initWithQueue:(NSOperationQueue *)delegateQueue {
  self = [super init];
  if (self) {
    if (delegateQueue) {
      _delegateQueue = delegateQueue;
    } else {
      _delegateQueue = [NSOperationQueue mainQueue];
    }
    [_delegateQueue setMaxConcurrentOperationCount:1];
    _sessionData = [NSMutableDictionary new];
  }
  return self;
}

#pragma mark - Delegate protocol methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
  DBSessionData *sessionData = [self sessionDataWithSession:session];
  NSNumber *taskId = @(dataTask.taskIdentifier);

  if (sessionData.responsesData[taskId]) {
    [sessionData.responsesData[taskId] appendData:data];
  } else {
    sessionData.responsesData[taskId] = [NSMutableData dataWithData:data];
  }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  DBSessionData *sessionData = [self sessionDataWithSession:session];
  NSNumber *taskId = @(task.taskIdentifier);

  if (error && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
    DBDownloadResponseBlock responseHandler = sessionData.downloadHandlers[taskId];
    if (responseHandler) {
      responseHandler(nil, task.response, error);
      [sessionData.downloadHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else {
      sessionData.completionData[taskId] = [[DBCompletionData alloc] initWithCompletionData:nil
                                                                               responseMetadata:task.response
                                                                              responseError:error
                                                                                  urlOutput:nil];
    }
  } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
    NSMutableData *responseData = sessionData.responsesData[taskId];
    DBUploadResponseBlock responseHandler = sessionData.uploadHandlers[taskId];
    if (responseHandler) {
      responseHandler(responseData, task.response, error);
      [sessionData.responsesData removeObjectForKey:taskId];
      [sessionData.uploadHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else {
      sessionData.completionData[taskId] = [[DBCompletionData alloc] initWithCompletionData:responseData
                                                                               responseMetadata:task.response
                                                                              responseError:error
                                                                                  urlOutput:nil];
    }
  } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
    NSMutableData *responseData = sessionData.responsesData[taskId];
    DBRpcResponseBlock responseHandler = sessionData.rpcHandlers[taskId];
    if (responseHandler) {
      responseHandler(responseData, task.response, error);
      [sessionData.responsesData removeObjectForKey:taskId];
      [sessionData.rpcHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else {
      sessionData.completionData[taskId] = [[DBCompletionData alloc] initWithCompletionData:responseData
                                                                               responseMetadata:task.response
                                                                              responseError:error
                                                                                  urlOutput:nil];
    }
  }
}

- (void)URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  DBSessionData *sessionData = [self sessionDataWithSession:session];
  NSNumber *taskId = @(task.taskIdentifier);

  if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
    DBProgressBlock progressHandler = sessionData.progressHandlers[taskId];
    if (progressHandler) {
      progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
    } else {
      sessionData.progressData[taskId] = [[DBProgressData alloc] initWithProgressData:bytesSent
                                                                       totalCommitted:totalBytesSent
                                                                     expectedToCommit:totalBytesExpectedToSend];
    }
  } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
    DBProgressBlock progressHandler = sessionData.progressHandlers[taskId];
    if (progressHandler) {
      progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
    } else {
      sessionData.progressData[taskId] = [[DBProgressData alloc] initWithProgressData:bytesSent
                                                                       totalCommitted:totalBytesSent
                                                                     expectedToCommit:totalBytesExpectedToSend];
    }
  }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  DBSessionData *sessionData = [self sessionDataWithSession:session];
  NSNumber *taskId = @(downloadTask.taskIdentifier);

  DBProgressBlock progressHandler = sessionData.progressHandlers[taskId];
  if (progressHandler) {
    progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
  } else {
    sessionData.progressData[taskId] = [[DBProgressData alloc] initWithProgressData:bytesWritten
                                                                     totalCommitted:totalBytesWritten
                                                                   expectedToCommit:totalBytesExpectedToWrite];
  }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
  DBSessionData *sessionData = [self sessionDataWithSession:session];
  NSNumber *taskId = @(downloadTask.taskIdentifier);

  DBDownloadResponseBlock responseHandler = sessionData.downloadHandlers[taskId];
  if (responseHandler) {
    responseHandler(location, downloadTask.response, nil);
    [sessionData.downloadHandlers removeObjectForKey:taskId];
    [sessionData.progressHandlers removeObjectForKey:taskId];
  } else {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *tmpOutputPath = [NSTemporaryDirectory()
        stringByAppendingPathComponent:[NSString
                                           stringWithFormat:@"%@_%lld", [location lastPathComponent],
                                                            (long long)[[NSDate date] timeIntervalSince1970] * 1000]];

    NSError *fileMoveError;
    [fileManager moveItemAtPath:[location path] toPath:tmpOutputPath error:&fileMoveError];
    if (fileMoveError) {
      NSLog(@"Error moving file to temporary storage location: %@", fileMoveError);
    }

    sessionData.completionData[taskId] =
        [[DBCompletionData alloc] initWithCompletionData:nil
                                            responseMetadata:downloadTask.response
                                           responseError:nil
                                               urlOutput:[NSURL URLWithString:tmpOutputPath]];
  }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
}

- (void)addProgressHandler:(NSURLSessionTask *)task
                   session:(NSURLSession *)session
           progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
  NSNumber *taskId = @(task.taskIdentifier);

  [_delegateQueue addOperationWithBlock:^{
    DBSessionData *sessionData = [self sessionDataWithSession:session];
    // there is a handler queued to be executed
    DBProgressData *progressData = sessionData.progressData[taskId];
    if (progressData) {
      handler(progressData.committed, progressData.totalCommitted, progressData.expectedToCommit);
      [sessionData.progressData removeObjectForKey:taskId];
    } else if (!sessionData.progressHandlers[taskId]) {
      sessionData.progressHandlers[taskId] = handler;
    }
  }];
}

#pragma mark - Add RPC-style handler

- (void)addRpcResponseHandler:(NSURLSessionTask *)task
                      session:(NSURLSession *)session
              responseHandler:(DBRpcResponseBlock)handler {
  NSNumber *taskId = @(task.taskIdentifier);
  DBSessionData *sessionData = [self sessionDataWithSession:session];

  [_delegateQueue addOperationWithBlock:^{
    DBCompletionData *completionData = sessionData.completionData[taskId];
    if (completionData) {
      handler(completionData.responseBody, completionData.responseMetadata, completionData.responseError);
      [sessionData.completionData removeObjectForKey:taskId];
      [sessionData.rpcHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else if (!sessionData.uploadHandlers[taskId]) {
      sessionData.rpcHandlers[taskId] = handler;
    }
  }];
}

#pragma mark - Add Upload-style handler

- (void)addUploadResponseHandler:(NSURLSessionTask *)task
                         session:(NSURLSession *)session
                 responseHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
  NSNumber *taskId = @(task.taskIdentifier);
  DBSessionData *sessionData = [self sessionDataWithSession:session];

  [_delegateQueue addOperationWithBlock:^{
    DBCompletionData *completionData = sessionData.completionData[taskId];
    if (completionData) {
      handler(completionData.responseBody, completionData.responseMetadata, completionData.responseError);
      [sessionData.completionData removeObjectForKey:taskId];
      [sessionData.uploadHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else if (!sessionData.uploadHandlers[taskId]) {
      sessionData.uploadHandlers[taskId] = handler;
    }
  }];
}

#pragma mark - Add Download-style handler

- (void)addDownloadResponseHandler:(NSURLSessionTask *)task
                           session:(NSURLSession *)session
                   responseHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))handler {
  NSNumber *taskId = @(task.taskIdentifier);
  DBSessionData *sessionData = [self sessionDataWithSession:session];

  [_delegateQueue addOperationWithBlock:^{
    DBCompletionData *completionData = sessionData.completionData[taskId];
    if (completionData) {
      handler(completionData.urlOutput, completionData.responseMetadata, completionData.responseError);

      [sessionData.completionData removeObjectForKey:taskId];
      [sessionData.downloadHandlers removeObjectForKey:taskId];
      [sessionData.progressHandlers removeObjectForKey:taskId];
    } else if (!sessionData.uploadHandlers[taskId]) {
      sessionData.downloadHandlers[taskId] = handler;
    }
  }];
}

- (NSString *)sessionIdWithSession:(NSURLSession *)session {
  return session.configuration.identifier ?: kForegroundId;
}

- (DBSessionData *)sessionDataWithSession:(NSURLSession *)session {
  NSString *sessionId = [self sessionIdWithSession:session];
  if (!_sessionData[sessionId]) {
    _sessionData[sessionId] = [[DBSessionData alloc] initWithSessionId:sessionId];
  }
  return _sessionData[sessionId];
}

@end
