///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBDelegate.h"
#import "DBHandlerTypes.h"
#import "DBRequestErrors.h"
#import "DBStoneBase.h"
#import "DBTasks+Protected.h"
#import "DBTasksImpl.h"
#import "DBTransportClientBase.h"

#pragma mark - RPC-style network task

@implementation DBRpcTaskImpl

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [super initWithRoute:route];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
  }
  return self;
}

- (DBRpcTask *)response:(DBRpcResponseBlock)responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBRpcTask *)response:(NSOperationQueue *)queue response:(DBRpcResponseBlock)responseBlock {
  DBRpcResponseBlockStorage storageBlock = [self storageBlockWithResponseBlock:responseBlock];
  [_delegate addRpcResponseHandler:_task session:_session responseHandler:storageBlock responseHandlerQueue:queue];
  return self;
}

- (DBRpcTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBRpcTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:queue];
  return self;
}

@end

#pragma mark - Upload-style network task

@implementation DBUploadTaskImpl

- (instancetype)initWithTask:(NSURLSessionUploadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [super initWithRoute:route];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
  }
  return self;
}

- (DBUploadTask *)response:(DBUploadResponseBlock)responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBUploadTask *)response:(NSOperationQueue *)queue response:(DBUploadResponseBlock)responseBlock {
  DBUploadResponseBlockStorage storageBlock = [self storageBlockWithResponseBlock:responseBlock];
  [_delegate addUploadResponseHandler:_task session:_session responseHandler:storageBlock responseHandlerQueue:queue];

  return self;
}

- (DBUploadTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBUploadTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:queue];
  return self;
}

@end

#pragma mark - Download-style network task (NSURL)

@implementation DBDownloadUrlTaskImpl

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route
                   overwrite:(BOOL)overwrite
                 destination:(NSURL *)destination {
  self = [super initWithRoute:route];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
    _overwrite = overwrite;
    _destination = destination;
  }
  return self;
}

- (DBDownloadUrlTask *)response:(DBDownloadUrlResponseBlock)responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBDownloadUrlTask *)response:(NSOperationQueue *)queue response:(DBDownloadUrlResponseBlock)responseBlock {
  DBDownloadResponseBlockStorage storageBlock = [self storageBlockWithResponseBlock:responseBlock];
  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:storageBlock responseHandlerQueue:queue];

  return self;
}

- (DBDownloadUrlTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBDownloadUrlTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:queue];
  return self;
}

@end

#pragma mark - Download-style network task (NSData)

@implementation DBDownloadDataTaskImpl

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [super initWithRoute:route];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
  }
  return self;
}

- (DBDownloadDataTask *)response:(DBDownloadDataResponseBlock)responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBDownloadDataTask *)response:(NSOperationQueue *)queue response:(DBDownloadDataResponseBlock)responseBlock {
  DBDownloadResponseBlockStorage storageBlock = [self storageBlockWithResponseBlock:responseBlock];
  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:storageBlock responseHandlerQueue:queue];

  return self;
}

- (DBDownloadDataTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBDownloadDataTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:queue];
  return self;
}

@end
