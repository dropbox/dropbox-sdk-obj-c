///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBDelegate.h"
#import <Foundation/Foundation.h>

static NSString const * const kForegroundId = @"com.dropbox.dropbox_sdk_obj_c_foreground";
static NSString const * const kProgressHandlerKey = @"progressHandler";
static NSString const * const kResponseHandlerKey = @"responseHandler";

@interface DBDelegate ()

@property(nonatomic) NSOperationQueue * _Nonnull delegateQueue;
@property(nonatomic, copy) NSString * _Nonnull foregroundIdentifier;
@property(nonatomic) NSMutableDictionary * _Nonnull responsesData;
@property(nonatomic) NSMutableDictionary * _Nonnull rpcTasks;
@property(nonatomic) NSMutableDictionary * _Nonnull uploadTasks;
@property(nonatomic) NSMutableDictionary * _Nonnull downloadTasks;

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
      [_delegateQueue setMaxConcurrentOperationCount:1];
    }
    _responsesData = [NSMutableDictionary new];
    _rpcTasks = [NSMutableDictionary new];
    _uploadTasks = [NSMutableDictionary new];
    _downloadTasks = [NSMutableDictionary new];
  }
  return self;
}

#pragma mark - Delegate protocol methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:dataTask.taskIdentifier];
  NSMutableData *responseData = _responsesData[sessionId][taskId];
  if (!responseData) {
    _responsesData[sessionId] = [NSMutableDictionary new];
    _responsesData[sessionId][taskId] = [NSMutableData dataWithData:data];
  } else {
    if (!_responsesData[sessionId]) {
      _responsesData[sessionId] = [NSMutableDictionary new];
    }
    [_responsesData[sessionId][taskId] appendData:data];
  }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  if (error && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
    [_downloadTasks[sessionId] removeObjectForKey:taskId];
  } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
    NSMutableData *responseData = _responsesData[sessionId][taskId];

    void (^responseHandler)(NSData *, NSURLResponse *, NSError *) =
        _uploadTasks[sessionId][taskId][kResponseHandlerKey];
    if (responseHandler) {
      responseHandler(responseData, task.response, error);
    }
    [_uploadTasks[sessionId] removeObjectForKey:taskId];
    [_responsesData[sessionId] removeObjectForKey:taskId];
  } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
    NSMutableData *responseData = _responsesData[sessionId][taskId];

    void (^responseHandler)(NSData *, NSURLResponse *, NSError *) = _rpcTasks[sessionId][taskId][kResponseHandlerKey];
    if (responseHandler) {
      responseHandler(responseData, task.response, error);
    }
    [_rpcTasks[sessionId] removeObjectForKey:taskId];
    [_responsesData[sessionId] removeObjectForKey:taskId];
  }
}

- (void)URLSession:(NSURLSession *)session
                        task:(NSURLSessionTask *)task
             didSendBodyData:(int64_t)bytesSent
              totalBytesSent:(int64_t)totalBytesSent
    totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
    if (_uploadTasks[sessionId][taskId]) {
      void (^progressHandler)(int64_t, int64_t, int64_t) = _uploadTasks[sessionId][taskId][kProgressHandlerKey];
      if (progressHandler) {
        progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
      }
    }
  } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
    if (_rpcTasks[sessionId][taskId]) {
      void (^progressHandler)(int64_t, int64_t, int64_t) = _rpcTasks[sessionId][taskId][kProgressHandlerKey];
      if (progressHandler) {
        progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
      }
    }
  }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
                 didWriteData:(int64_t)bytesWritten
            totalBytesWritten:(int64_t)totalBytesWritten
    totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:downloadTask.taskIdentifier];
  if (_downloadTasks[sessionId][taskId]) {
    void (^progressHandler)(int64_t, int64_t, int64_t) = _downloadTasks[sessionId][taskId][kProgressHandlerKey];
    if (progressHandler) {
      progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    }
  }
}

- (void)URLSession:(NSURLSession *)session
                 downloadTask:(NSURLSessionDownloadTask *)downloadTask
    didFinishDownloadingToURL:(NSURL *)location {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:downloadTask.taskIdentifier];
  void (^responseHandler)(NSURL *, NSURLResponse *, NSError *) = _downloadTasks[sessionId][taskId][kResponseHandlerKey];
  if (responseHandler) {
    responseHandler(location, downloadTask.response, nil);
  }
  [_downloadTasks[sessionId] removeObjectForKey:taskId];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
  NSString *sessionId = [self getSessionId:session];
  [_uploadTasks[sessionId] removeAllObjects];
  [_downloadTasks[sessionId] removeAllObjects];
}

- (NSString *)getSessionId:(NSURLSession *)session {
  return session.configuration.identifier ?: kForegroundId;
}

#pragma mark - Add RPC-style handler

- (void)addRpcResponseHandler:(NSURLSessionTask *)task
                      session:(NSURLSession *)session
              responseHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_rpcTasks[sessionId]) {
      [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_rpcTasks[sessionId][taskId]) {
      [_rpcTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_rpcTasks[sessionId][taskId] setObject:handler forKey:kResponseHandlerKey];
    }
  }];
}

- (void)addRpcProgressHandler:(NSURLSessionTask *)task
                      session:(NSURLSession *)session
              progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_rpcTasks[sessionId]) {
      [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_rpcTasks[sessionId][taskId]) {
      [_rpcTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_rpcTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }
  }];
}

#pragma mark - Add Upload-style handler

- (void)addUploadResponseHandler:(NSURLSessionTask *)task
                         session:(NSURLSession *)session
                 responseHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_uploadTasks[sessionId]) {
      [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_uploadTasks[sessionId][taskId]) {
      [_uploadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_uploadTasks[sessionId][taskId] setObject:handler forKey:kResponseHandlerKey];
    }
  }];
}

- (void)addUploadProgressHandler:(NSURLSessionTask *)task
                         session:(NSURLSession *)session
                 progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_uploadTasks[sessionId]) {
      [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_uploadTasks[sessionId][taskId]) {
      [_uploadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_uploadTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }
  }];
}

#pragma mark - Add Download-style handler

- (void)addDownloadResponseHandler:(NSURLSessionTask *)task
                           session:(NSURLSession *)session
                   responseHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_downloadTasks[sessionId]) {
      [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_downloadTasks[sessionId][taskId]) {
      [_downloadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_downloadTasks[sessionId][taskId] setObject:handler forKey:kResponseHandlerKey];
    }
  }];
}

- (void)addDownloadProgressHandler:(NSURLSessionTask *)task
                           session:(NSURLSession *)session
                   progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
  NSString *sessionId = [self getSessionId:session];
  NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
  [_delegateQueue addOperationWithBlock:^{
    if (!_downloadTasks[sessionId]) {
      [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
    }
    if (!_downloadTasks[sessionId][taskId]) {
      [_downloadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
    }
    if (handler) {
      [_downloadTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }
  }];
}

@end
