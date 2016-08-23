///
/// Delegate class to manage background session downloads / uploads.
///

#import <Foundation/Foundation.h>
#import "DbxDelegate.h"


@implementation DbxDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    NSMutableData *responseData = _responsesData[sessionIdentifier][@(dataTask.taskIdentifier)];
    if (!responseData) {
        _responsesData[sessionIdentifier] = [NSMutableDictionary new];
        _responsesData[sessionIdentifier][@(dataTask.taskIdentifier)] = [NSMutableData dataWithData:data];
    } else {
        if (!_responsesData[sessionIdentifier]) {
            _responsesData[sessionIdentifier] = [NSMutableDictionary new];
        }
        [_responsesData[sessionIdentifier][@(dataTask.taskIdentifier)] appendData:data];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";

    if (error && [task isKindOfClass:[NSURLSessionDownloadTask class]]) {
        [_downloadTasks[sessionIdentifier] removeObjectForKey:@(task.taskIdentifier)];
    } else if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        NSMutableData *responseData = _responsesData[sessionIdentifier][@(task.taskIdentifier)];

        void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = _uploadTasks[sessionIdentifier][@(task.taskIdentifier)][@"completionHandlers"];
        completionHandler(responseData, task.response, error);
        
        [self.responsesData[sessionIdentifier] removeObjectForKey:@(task.taskIdentifier)];

    } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        NSMutableData *responseData = _responsesData[sessionIdentifier][@(task.taskIdentifier)];

        void (^completionHandler)(NSData *, NSURLResponse *, NSError *) = _rpcTasks[sessionIdentifier][@(task.taskIdentifier)][@"completionHandlers"];
        completionHandler(responseData, task.response, error);
        
        [self.responsesData[sessionIdentifier] removeObjectForKey:@(task.taskIdentifier)];
        
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";

    if ([task isKindOfClass:[NSURLSessionUploadTask class]]) {
        if (_uploadTasks[sessionIdentifier][@(task.taskIdentifier)]) {
            void (^progressHandler)(int64_t, int64_t, int64_t) = _uploadTasks[sessionIdentifier][@(task.taskIdentifier)][@"progressHandlers"];
            if (progressHandler) {
                progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
            }
        }
    } else if ([task isKindOfClass:[NSURLSessionDataTask class]]) {
        if (_rpcTasks[sessionIdentifier][@(task.taskIdentifier)]) {
            void (^progressHandler)(int64_t, int64_t, int64_t) = _rpcTasks[sessionIdentifier][@(task.taskIdentifier)][@"progressHandlers"];
            if (progressHandler) {
                progressHandler(bytesSent, totalBytesSent, totalBytesExpectedToSend);
            }
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (_downloadTasks[sessionIdentifier][@(downloadTask.taskIdentifier)]) {
        void (^progressHandler)(int64_t, int64_t, int64_t) = _downloadTasks[sessionIdentifier][@(downloadTask.taskIdentifier)][@"progressHandlers"];
        if (progressHandler) {
            progressHandler(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    void (^completionHandler)(NSURL *, NSURLResponse *, NSError *) = _downloadTasks[sessionIdentifier][[NSNumber numberWithUnsignedInteger:downloadTask.taskIdentifier]][@"completionHandlers"];
    completionHandler(location, downloadTask.response, nil);
    
    [_downloadTasks[sessionIdentifier] removeObjectForKey:@(downloadTask.taskIdentifier)];
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";

    [_uploadTasks[sessionIdentifier] removeAllObjects];
    [_downloadTasks[sessionIdentifier] removeAllObjects];
}

- (void)addRpcCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";

    if (!_rpcTasks[sessionIdentifier]) {
        [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_rpcTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_rpcTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }

    [_rpcTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"completionHandlers"];
}

- (void)addRpcProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (!_rpcTasks[sessionIdentifier]) {
        [_rpcTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_rpcTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_rpcTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }
    
    [_rpcTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"progressHandlers"];
}

- (void)addUploadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (!_uploadTasks[sessionIdentifier]) {
        [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_uploadTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_uploadTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }
    
    [_uploadTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"completionHandlers"];
}

- (void)addUploadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (!_uploadTasks[sessionIdentifier]) {
        [_uploadTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_uploadTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_uploadTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }
    
    [_uploadTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"progressHandlers"];
}

- (void)addDownloadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (!_downloadTasks[sessionIdentifier]) {
        [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_downloadTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_downloadTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }
    
    [_downloadTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"completionHandlers"];
}

- (void)addDownloadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler {
    NSString *sessionIdentifier = session.configuration.identifier ?: @"foreground_tasks";
    
    if (!_downloadTasks[sessionIdentifier]) {
        [_downloadTasks setObject:[NSMutableDictionary new] forKey:sessionIdentifier];
    }
    if (!_downloadTasks[sessionIdentifier][@(task.taskIdentifier)]) {
        [_downloadTasks[sessionIdentifier] setObject:[NSMutableDictionary new] forKey:@(task.taskIdentifier)];
    }
    
    [_downloadTasks[sessionIdentifier][@(task.taskIdentifier)] setObject:handler forKey:@"progressHandlers"];
}

- (nonnull instancetype)init {
    self = [super init];
    if (self != nil) {
        _responsesData = [NSMutableDictionary new];
        _rpcTasks = [NSMutableDictionary new];
        _uploadTasks = [NSMutableDictionary new];
        _downloadTasks = [NSMutableDictionary new];
    }
    return self;
}

@end
