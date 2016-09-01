///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBAuthAuthError.h"
#import "DBAuthRateLimitError.h"
#import "DBDelegate.h"
#import "DBErrors.h"
#import "DBStoneBase.h"
#import "DBTasks.h"
#import "DBTransportClient.h"
#import <Foundation/Foundation.h>

#pragma mark - Base network task

@implementation DBTask

- (DBError *)getDBError:(NSData *)data
               response:(NSURLResponse *)response
                  error:(NSError *)error
             statusCode:(int)statusCode
            httpHeaders:(NSDictionary *)httpHeaders {
  DBError *dbxError = nil;

  if (statusCode == 200) {
    return dbxError;
  }

  NSDictionary *deserializedData = [self deserializeHttpData:data];

  NSString *requestId = httpHeaders[@"X-Dropbox-Request-Id"];
  NSString *errorContent = deserializedData ? deserializedData[@"error_summary"]
                                            : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

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
  } else if (statusCode == 403 || statusCode == 404 || statusCode == 409) {
    dbxError = [[DBError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
  } else if (!response) {
    dbxError = [[DBError alloc] initAsOSError:errorContent];
  } else {
    dbxError = [[DBError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
  }

  return dbxError;
}

- (id)routeErrorWithData:(NSData *)data statusCode:(int)statusCode {
  id routeError = nil;
  NSDictionary *deserializedData = [self deserializeHttpData:data];
  if (statusCode == 403 || statusCode == 404 || statusCode == 409) {
    routeError = [_route.errorType deserialize:deserializedData[@"error"]];
  }
  return routeError;
}

- (NSDictionary *)deserializeHttpData:(NSData *)data {
  NSError *error = nil;
  return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

- (id)routeResultWithData:(NSData *)data {
  if (!_route.resultType) {
    return nil;
  }
  NSError *serializationError;
  id jsonData =
      [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
  if (!jsonData) {
    NSLog(@"Error deserializing in success handler: %@", serializationError.localizedDescription);
    NSLog(@"Data: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
  void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBError *dbxError =
        [self getDBError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError = [self routeErrorWithData:data statusCode:statusCode];
      return responseBlock(nil, routeError, dbxError);
    }

    id result = [self routeResultWithData:data];
    responseBlock(result, nil, nil);
  };

  [_delegate addRpcResponseHandler:_task session:_session responseHandler:handler];

  return self;
}

- (DBRpcTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
  [_delegate addRpcProgressHandler:_task session:_session progressHandler:progressBlock];

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
  void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBError *dbxError =
        [self getDBError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError = [self routeErrorWithData:data statusCode:statusCode];
      return responseBlock(nil, routeError, dbxError);
    }

    id result = [self routeResultWithData:data];
    responseBlock(result, nil, nil);
  };

  [_delegate addUploadResponseHandler:_task session:_session responseHandler:handler];

  return self;
}

- (DBUploadTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
  [_delegate addUploadProgressHandler:_task session:_session progressHandler:progressBlock];

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

@implementation DBDownloadURLTask

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

- (DBDownloadURLTask *)response:(void (^)(id, id, DBError *dbxError, NSURL *))responseBlock {
  void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSData *resultData = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];

    if (!resultData) {
      // error data is in response body (downloaded to output tmp file)
      NSData *errorData = [NSData dataWithContentsOfFile:[location path]];
      DBError *dbxError =
          [self getDBError:errorData response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
      id routeError = [self routeErrorWithData:errorData statusCode:statusCode];
      return responseBlock(nil, routeError, dbxError, _destination);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [_destination path];

    if (![fileManager fileExistsAtPath:path]) {
      if (_overwrite) {
        NSError *fileMoveError;
        NSLog([fileManager removeItemAtPath:[_destination path] error:&fileMoveError] ? @"File deleted at %@."
                                                                                      : @"File not deleted at %@.",
              path);
        [fileManager moveItemAtPath:[location path] toPath:path error:&fileMoveError];
      } else {
        NSLog(@"File already exists at path: %@", path);
      }
    } else {
      NSError *fileMoveError;
      [fileManager moveItemAtPath:[location path] toPath:path error:&fileMoveError];
    }

    id result = [self routeResultWithData:resultData];
    responseBlock(result, nil, nil, _destination);
  };

  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:handler];

  return self;
}

- (DBDownloadURLTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
  [_delegate addDownloadProgressHandler:_task session:_session progressHandler:progressBlock];

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
  void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSData *data = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];

    DBError *dbxError =
        [self getDBError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError = [self routeErrorWithData:data statusCode:statusCode];
      return responseBlock(nil, routeError, dbxError, nil);
    }

    id result = [self routeResultWithData:data];
    responseBlock(result, nil, nil, [NSData dataWithContentsOfFile:[location path]]);
  };

  [_delegate addDownloadResponseHandler:_task session:_session responseHandler:handler];

  return self;
}

- (DBDownloadDataTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
  [_delegate addDownloadProgressHandler:_task session:_session progressHandler:progressBlock];

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
