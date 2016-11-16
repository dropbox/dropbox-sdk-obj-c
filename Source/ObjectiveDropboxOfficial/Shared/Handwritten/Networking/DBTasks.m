///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBAuthAuthError.h"
#import "DBAuthRateLimitError.h"
#import "DBDelegate.h"
#import "DBErrors.h"
#import "DBHandlerTypes.h"
#import "DBStoneBase.h"
#import "DBTasks.h"
#import "DBTransportClient.h"

#pragma mark - Base network task

@implementation DBTask

- (DBError *)getDBError:(NSData *)errorData
               response:(NSURLResponse *)response
            clientError:(NSError *)clientError
             statusCode:(int)statusCode
            httpHeaders:(NSDictionary *)httpHeaders {
  DBError *dbxError;

  if (clientError) {
    return [[DBError alloc] initAsClientError:clientError];
  }

  if (statusCode == 200) {
    return nil;
  }

  NSDictionary *deserializedData = [self deserializeHttpData:errorData];

  NSString *requestId = httpHeaders[@"X-Dropbox-Request-Id"];
  NSString *errorContent;
  if (deserializedData) {
    if (deserializedData[@"error_summary"]) {
      errorContent = deserializedData[@"error_summary"];
    } else if (deserializedData[@"error"]) {
      errorContent = deserializedData[@"error"];
    } else {
      errorContent = errorData ? [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding] : nil;
    }
  } else {
    errorContent = errorData ? [[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding] : nil;
  }

  if (statusCode >= 500 && statusCode < 600) {
    dbxError = [[DBError alloc] initAsInternalServerError:requestId statusCode:@(statusCode) errorContent:errorContent];
  } else if (statusCode == 400) {
    dbxError = [[DBError alloc] initAsBadInputError:requestId statusCode:@(statusCode) errorContent:errorContent];
  } else if (statusCode == 401) {
    DBAUTHAuthError *authError = [DBAUTHAuthErrorSerializer deserialize:deserializedData[@"error"]];
    dbxError = [[DBError alloc] initAsAuthError:requestId
                                     statusCode:@(statusCode)
                                   errorContent:errorContent
                            structuredAuthError:authError];
  } else if (statusCode == 429) {
    DBAUTHRateLimitError *rateLimitError = [DBAUTHRateLimitErrorSerializer deserialize:deserializedData[@"error"]];
    NSString *retryAfter = httpHeaders[@"Retry-After"];
    double retryAfterSeconds = retryAfter.doubleValue;
    dbxError = [[DBError alloc] initAsRateLimitError:requestId
                                          statusCode:@(statusCode)
                                        errorContent:errorContent
                            structuredRateLimitError:rateLimitError
                                             backoff:@(retryAfterSeconds)];
  } else if ([self statusCodeIsRouteError:statusCode]) {
    dbxError = [[DBError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
  } else {
    dbxError = [[DBError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
  }

  return dbxError;
}

- (id)routeErrorWithData:(NSData *)data statusCode:(int)statusCode {
  if (!data) {
    return nil;
  }
  id routeError;
  NSDictionary *deserializedData = [self deserializeHttpData:data];
  if ([self statusCodeIsRouteError:statusCode]) {
    routeError = [_route.errorType deserialize:deserializedData[@"error"]];
  }
  return routeError;
}

- (NSDictionary *)deserializeHttpData:(NSData *)data {
  if (!data) {
    return nil;
  }
  NSError *error;
  return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

- (id)routeResultWithData:(NSData *)data serializationError:(NSError **)serializationError {
  if (!_route.resultType) {
    return nil;
  }
  id jsonData =
      [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:serializationError];
  if (*serializationError) {
    return nil;
  }

  if (_route.resultType) {
    if (_route.arrayDeserialBlock) {
      return _route.arrayDeserialBlock(jsonData);
    }
    return [(Class)_route.resultType deserialize:jsonData];
  }

  return nil;
}

- (BOOL)statusCodeIsRouteError:(int)statusCode {
  return statusCode == 409;
}

- (NSString *)caseInsensitiveLookup:(NSString *)lookupKey dictionary:(NSDictionary<id, id> *)dictionary {
  for (id key in dictionary) {
    NSString *keyString = (NSString *)key;
    if ([keyString.lowercaseString isEqualToString:lookupKey.lowercaseString]) {
      return (NSString *)dictionary[key];
    }
  }
  return nil;
}

@end

#pragma mark - RPC-style network task

@implementation DBRpcTask

- (instancetype)initWithTask:(NSURLSessionDataTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [self init];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
    _route = route;
  }
  return self;
}

- (DBRpcTask *)response:(void (^)(id, id, DBError *))responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBRpcTask *)response:(NSOperationQueue *)queue response:(void (^)(id, id, DBError *))responseBlock {
  DBRpcResponseBlock wrapperBlock = ^(NSData *data, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBError *dbxError =
        [self getDBError:data response:response clientError:clientError statusCode:statusCode httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError =
          [self statusCodeIsRouteError:statusCode] ? [self routeErrorWithData:data statusCode:statusCode] : nil;
      return responseBlock(nil, routeError, dbxError);
    }

    NSError *serializationError;
    id result = [self routeResultWithData:data serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBError alloc] initAsClientError:serializationError]);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil);
  };

  [_delegate addRpcResponseHandler:_task session:_session responseHandler:wrapperBlock responseHandlerQueue:queue];

  return self;
}

- (DBRpcTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBRpcTask *)progress:(NSOperationQueue *)handlerQueue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:handlerQueue];
  return self;
}

- (void)cancel {
  [self.task cancel];
}

- (void)suspend {
  [self.task suspend];
}

- (void)resume {
  [self.task resume];
}

@end

#pragma mark - Upload-style network task

@implementation DBUploadTask

- (instancetype)initWithTask:(NSURLSessionUploadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [self init];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
    _route = route;
  }
  return self;
}

- (DBUploadTask *)response:(void (^)(id, id, DBError *))responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBUploadTask *)response:(NSOperationQueue *)queue response:(void (^)(id, id, DBError *))responseBlock {
  DBUploadResponseBlock wrapperBlock = ^(NSData *data, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBError *dbxError =
        [self getDBError:data response:response clientError:clientError statusCode:statusCode httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError =
          [self statusCodeIsRouteError:statusCode] ? [self routeErrorWithData:data statusCode:statusCode] : nil;
      return responseBlock(nil, routeError, dbxError);
    }

    NSError *serializationError;
    id result = [self routeResultWithData:data serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBError alloc] initAsClientError:serializationError]);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil);
  };

  [_delegate addUploadResponseHandler:_task session:_session responseHandler:wrapperBlock responseHandlerQueue:queue];

  return self;
}

- (DBUploadTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBUploadTask *)progress:(NSOperationQueue *)handlerQueue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:handlerQueue];
  return self;
}

- (void)cancel {
  [self.task cancel];
}

- (void)suspend {
  [self.task suspend];
}

- (void)resume {
  [self.task resume];
}

@end

#pragma mark - Download-style network task (NSURL)

@implementation DBDownloadUrlTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route
                   overwrite:(BOOL)overwrite
                 destination:(NSURL *)destination {
  self = [self init];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
    _route = route;
    _overwrite = overwrite;
    _destination = destination;
  }
  return self;
}

- (DBDownloadUrlTask *)response:(void (^)(id, id, DBError *dbxError, NSURL *))responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBDownloadUrlTask *)response:(NSOperationQueue *)queue
                       response:(void (^)(id, id, DBError *dbxError, NSURL *))responseBlock {
  DBDownloadResponseBlock wrapperBlock = ^(NSURL *location, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSString *headerString = [self caseInsensitiveLookup:@"Dropbox-API-Result" dictionary:httpHeaders];
    NSData *resultData = headerString ? [headerString dataUsingEncoding:NSUTF8StringEncoding] : nil;

    if (clientError || !resultData) {
      // error data is in response body (downloaded to output tmp file)
      NSData *errorData = location ? [NSData dataWithContentsOfFile:[location path]] : nil;
      DBError *dbxError = [self getDBError:errorData
                                  response:response
                               clientError:clientError
                                statusCode:statusCode
                               httpHeaders:httpHeaders];
      id routeError =
          [self statusCodeIsRouteError:statusCode] ? [self routeErrorWithData:errorData statusCode:statusCode] : nil;
      return responseBlock(nil, routeError, dbxError, _destination);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destinationPath = [_destination path];

    if ([fileManager fileExistsAtPath:destinationPath]) {
      NSError *fileMoveError;
      if (_overwrite) {
        [fileManager removeItemAtPath:destinationPath error:&fileMoveError];
        if (fileMoveError) {
          responseBlock(nil, nil, [[DBError alloc] initAsClientError:fileMoveError], _destination);
          return;
        }
      }
      [fileManager moveItemAtPath:[location path] toPath:destinationPath error:&fileMoveError];
      if (fileMoveError) {
        responseBlock(nil, nil, [[DBError alloc] initAsClientError:fileMoveError], _destination);
        return;
      }
    } else {
      NSError *fileMoveError;
      [fileManager moveItemAtPath:[location path] toPath:destinationPath error:&fileMoveError];
      if (fileMoveError) {
        responseBlock(nil, nil, [[DBError alloc] initAsClientError:fileMoveError], _destination);
        return;
      }
    }

    NSError *serializationError;
    id result = [self routeResultWithData:resultData serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBError alloc] initAsClientError:serializationError], _destination);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil, _destination);
  };

  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:wrapperBlock responseHandlerQueue:queue];

  return self;
}

- (DBDownloadUrlTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBDownloadUrlTask *)progress:(NSOperationQueue *)handlerQueue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:handlerQueue];
  return self;
}

- (void)cancel {
  [self.task cancel];
}

- (void)suspend {
  [self.task suspend];
}

- (void)resume {
  [self.task resume];
}

@end

#pragma mark - Download-style network task (NSData)

@implementation DBDownloadDataTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task
                     session:(NSURLSession *)session
                    delegate:(DBDelegate *)delegate
                       route:(DBRoute *)route {
  self = [self init];
  if (self) {
    _task = task;
    _session = session;
    _delegate = delegate;
    _route = route;
  }
  return self;
}

- (DBDownloadDataTask *)response:(void (^)(id, id, DBError *dbxError, NSData *))responseBlock {
  return [self response:nil response:responseBlock];
}

- (DBDownloadDataTask *)response:(NSOperationQueue *)queue
                        response:(void (^)(id, id, DBError *dbxError, NSData *))responseBlock {
  DBDownloadResponseBlock wrapperBlock = ^(NSURL *location, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSString *headerString = [self caseInsensitiveLookup:@"Dropbox-API-Result" dictionary:httpHeaders];
    NSData *resultData = headerString ? [headerString dataUsingEncoding:NSUTF8StringEncoding] : nil;

    if (!resultData) {
      // error data is in response body (downloaded to output tmp file)
      NSData *errorData = location ? [NSData dataWithContentsOfFile:[location path]] : nil;
      DBError *dbxError = [self getDBError:errorData
                                  response:response
                               clientError:clientError
                                statusCode:statusCode
                               httpHeaders:httpHeaders];
      id routeError =
          [self statusCodeIsRouteError:statusCode] ? [self routeErrorWithData:errorData statusCode:statusCode] : nil;
      return responseBlock(nil, routeError, dbxError, nil);
    }

    NSError *serializationError;
    id result = [self routeResultWithData:resultData serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBError alloc] initAsClientError:serializationError], nil);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil, [NSData dataWithContentsOfFile:[location path]]);
  };

  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:wrapperBlock responseHandlerQueue:queue];

  return self;
}

- (DBDownloadDataTask *)progress:(DBProgressBlock)progressBlock {
  return [self progress:nil progress:progressBlock];
}

- (DBDownloadDataTask *)progress:(NSOperationQueue *)handlerQueue progress:(DBProgressBlock)progressBlock {
  [_delegate addProgressHandler:_task session:_session progressHandler:progressBlock progressHandlerQueue:handlerQueue];
  return self;
}

- (void)cancel {
  [self.task cancel];
}

- (void)suspend {
  [self.task suspend];
}

- (void)resume {
  [self.task resume];
}

@end
