///
/// Delegate class to manage background session downloads / uploads.
///

#import <Foundation/Foundation.h>
#import "DBXDelegate.h"

static NSString *kForegroundId = @"com.dropbox.dropbox_sdk_obj_c_foreground";
static NSString *kProgressHandlerKey = @"progressHandler";
static NSString *kCompletionHandlerKey = @"completionHandler";

@implementation DBXDelegate

- (instancetype)initWithQueue:(NSOperationQueue *)delegateQueue {
    self = [super init];
    if (self) {
        _delegateQueue = delegateQueue;
        _responsesData = [NSMutableDictionary new];
        _rpcTasks = [NSMutableDictionary new];
        _uploadTasks = [NSMutableDictionary new];
        _downloadTasks = [NSMutableDictionary new];
    }
    return self;
}

- (NSString *)getSessionId:(NSURLSession *)session {
    return session.configuration.identifier ?: kForegroundId;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:dataTask.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
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
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (error && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
            [_downloadTasks[sessionId] removeObjectForKey:taskId];
        } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
            NSMutableData *responseData = _responsesData[sessionId][taskId];

            void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = _uploadTasks[sessionId][taskId][kCompletionHandlerKey];
            completionHandler(responseData, task.response, error);
            [_uploadTasks removeObjectForKey:taskId];
            [self.responsesData[sessionId] removeObjectForKey:taskId];

        } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
            NSMutableData *responseData = _responsesData[sessionId][taskId];

            void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = _rpcTasks[sessionId][taskId][kCompletionHandlerKey];
            completionHandler(responseData, task.response, error);
            [_rpcTasks removeObjectForKey:taskId];
            [self.responsesData[sessionId] removeObjectForKey:taskId];
            
        }
    }];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
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
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:downloadTask.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (_downloadTasks[sessionId][taskId]) {
            void (^progressHandler)(int64_t, int64_t, int64_t) = _downloadTasks[sessionId][taskId][kProgressHandlerKey];
            if (progressHandler) {
                progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            }
        }
    }];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:downloadTask.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        void (^completionHandler)(NSURL *, NSURLResponse *, NSError *) = _downloadTasks[sessionId][taskId][kCompletionHandlerKey];
        completionHandler(location, downloadTask.response, nil);
        [_downloadTasks[sessionId] removeObjectForKey:taskId];
    }];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSString *sessionId = [self getSessionId:session];
    [_delegateQueue addOperationWithBlock:^{
        [_uploadTasks[sessionId] removeAllObjects];
        [_downloadTasks[sessionId] removeAllObjects];
    }];
}

- (void)addRpcCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_rpcTasks[sessionId]) {
            [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_rpcTasks[sessionId][taskId]) {
            [_rpcTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }

        [_rpcTasks[sessionId][taskId] setObject:handler forKey:kCompletionHandlerKey];
    }];
}

- (void)addRpcProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_rpcTasks[sessionId]) {
            [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_rpcTasks[sessionId][taskId]) {
            [_rpcTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }
        
        [_rpcTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }];
}

- (void)addUploadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_uploadTasks[sessionId]) {
            [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_uploadTasks[sessionId][taskId]) {
            [_uploadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }
        
        [_uploadTasks[sessionId][taskId] setObject:handler forKey:kCompletionHandlerKey];
    }];
}

- (void)addUploadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_uploadTasks[sessionId]) {
            [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_uploadTasks[sessionId][taskId]) {
            [_uploadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }
        
        [_uploadTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }];
}

- (void)addDownloadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_downloadTasks[sessionId]) {
            [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_downloadTasks[sessionId][taskId]) {
            [_downloadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }
        
        [_downloadTasks[sessionId][taskId] setObject:handler forKey:kCompletionHandlerKey];
    }];
}

- (void)addDownloadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionId = [self getSessionId:session];
    NSNumber *taskId = [NSNumber numberWithUnsignedInteger:task.taskIdentifier];
    [_delegateQueue addOperationWithBlock:^{
        if (!_downloadTasks[sessionId]) {
            [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionId];
        }
        if (!_downloadTasks[sessionId][taskId]) {
            [_downloadTasks[sessionId] setObject:[NSMutableDictionary new] forKey:taskId];
        }
        
        [_downloadTasks[sessionId][taskId] setObject:handler forKey:kProgressHandlerKey];
    }];
}

@end
