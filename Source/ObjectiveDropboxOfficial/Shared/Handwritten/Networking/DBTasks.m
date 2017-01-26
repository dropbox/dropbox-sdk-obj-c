///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBDelegate.h"
#import "DBHandlerTypes.h"
#import "DBRequestErrors.h"
#import "DBStoneBase.h"
#import "DBTasks.h"
#import "DBTransportClientBase.h"

#pragma mark - Base network task

@implementation DBTask : NSObject

- (instancetype)initWithRoute:(DBRoute *)route {
  self = [super init];
  if (self) {
    _route = route;
  }
  return self;
}

- (void)cancel {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (void)suspend {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (void)resume {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (void)start {
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

@end

#pragma mark - RPC-style network task

@implementation DBRpcTask

- (DBRpcTask *)response:(DBRpcResponseBlock)responseBlock {
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBRpcTask *)response:(NSOperationQueue *)queue response:(DBRpcResponseBlock)responseBlock {
#pragma unused(queue)
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBRpcTask *)progress:(DBProgressBlock)progressBlock {
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBRpcTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
#pragma unused(queue)
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBRpcResponseBlockStorage)storageBlockWithResponseBlock:(DBRpcResponseBlock)responseBlock {
  DBRpcResponseBlockStorage storageBlock = ^(NSData *data, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBRequestError *dbxError = [DBTransportClientBase dBRequestErrorWithErrorData:data
                                                                      clientError:clientError
                                                                       statusCode:statusCode
                                                                      httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError = [DBTransportClientBase statusCodeIsRouteError:statusCode]
                          ? [DBTransportClientBase routeErrorWithRouteData:_route data:data statusCode:statusCode]
                          : nil;
      responseBlock(nil, routeError, dbxError);
      return;
    }

    NSError *serializationError;
    id result =
        [DBTransportClientBase routeResultWithRouteData:_route data:data serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:serializationError]);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil);
  };

  return storageBlock;
}

@end

#pragma mark - Upload-style network task

@implementation DBUploadTask

- (DBUploadTask *)response:(DBUploadResponseBlock)responseBlock {
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBUploadTask *)response:(NSOperationQueue *)queue response:(DBUploadResponseBlock)responseBlock {
#pragma unused(queue)
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBUploadTask *)progress:(DBProgressBlock)progressBlock {
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBUploadTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
#pragma unused(queue)
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBUploadResponseBlockStorage)storageBlockWithResponseBlock:(DBUploadResponseBlock)responseBlock {
  DBUploadResponseBlockStorage storageBlock = ^(NSData *data, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;

    DBRequestError *dbxError = [DBTransportClientBase dBRequestErrorWithErrorData:data
                                                                      clientError:clientError
                                                                       statusCode:statusCode
                                                                      httpHeaders:httpHeaders];
    if (dbxError) {
      id routeError = [DBTransportClientBase statusCodeIsRouteError:statusCode]
                          ? [DBTransportClientBase routeErrorWithRouteData:_route data:data statusCode:statusCode]
                          : nil;
      return responseBlock(nil, routeError, dbxError);
    }

    NSError *serializationError;
    id result =
        [DBTransportClientBase routeResultWithRouteData:_route data:data serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:serializationError]);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil);
  };

  return storageBlock;
}

@end

#pragma mark - Download-style network task (NSURL)

@implementation DBDownloadUrlTask

- (DBDownloadUrlTask *)response:(DBDownloadUrlResponseBlock)responseBlock {
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadUrlTask *)response:(NSOperationQueue *)queue response:(DBDownloadUrlResponseBlock)responseBlock {
#pragma unused(queue)
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadUrlTask *)progress:(DBProgressBlock)progressBlock {
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadUrlTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
#pragma unused(queue)
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadResponseBlockStorage)storageBlockWithResponseBlock:(DBDownloadUrlResponseBlock)responseBlock {
  DBDownloadResponseBlockStorage storageBlock = ^(NSURL *location, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSString *headerString = [DBTransportClientBase caseInsensitiveLookup:@"Dropbox-API-Result" dictionary:httpHeaders];
    NSData *resultData = headerString ? [headerString dataUsingEncoding:NSUTF8StringEncoding] : nil;

    if (clientError || !resultData) {
      // error data is in response body (downloaded to output tmp file)
      NSData *errorData = location ? [NSData dataWithContentsOfFile:[location path]] : nil;
      DBRequestError *dbxError = [DBTransportClientBase dBRequestErrorWithErrorData:errorData
                                                                        clientError:clientError
                                                                         statusCode:statusCode
                                                                        httpHeaders:httpHeaders];
      id routeError = [DBTransportClientBase statusCodeIsRouteError:statusCode]
                          ? [DBTransportClientBase routeErrorWithRouteData:_route data:errorData statusCode:statusCode]
                          : nil;
      return responseBlock(nil, routeError, dbxError, _destination);
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *destinationPath = [_destination path];

    if ([fileManager fileExistsAtPath:destinationPath]) {
      NSError *fileMoveError;
      if (_overwrite) {
        [fileManager removeItemAtPath:destinationPath error:&fileMoveError];
        if (fileMoveError) {
          responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:fileMoveError], _destination);
          return;
        }
      }
      [fileManager moveItemAtPath:[location path] toPath:destinationPath error:&fileMoveError];
      if (fileMoveError) {
        responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:fileMoveError], _destination);
        return;
      }
    } else {
      NSError *fileMoveError;
      [fileManager moveItemAtPath:[location path] toPath:destinationPath error:&fileMoveError];
      if (fileMoveError) {
        responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:fileMoveError], _destination);
        return;
      }
    }

    NSError *serializationError;
    id result =
        [DBTransportClientBase routeResultWithRouteData:_route data:resultData serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:serializationError], _destination);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil, _destination);
  };

  return storageBlock;
}

@end

#pragma mark - Download-style network task (NSData)

@implementation DBDownloadDataTask

- (DBDownloadDataTask *)response:(DBDownloadDataResponseBlock)responseBlock {
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadDataTask *)response:(NSOperationQueue *)queue response:(DBDownloadDataResponseBlock)responseBlock {
#pragma unused(queue)
#pragma unused(responseBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadDataTask *)progress:(DBProgressBlock)progressBlock {
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadDataTask *)progress:(NSOperationQueue *)queue progress:(DBProgressBlock)progressBlock {
#pragma unused(queue)
#pragma unused(progressBlock)
  @throw [NSException
      exceptionWithName:NSInternalInconsistencyException
                 reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
               userInfo:nil];
}

- (DBDownloadResponseBlockStorage)storageBlockWithResponseBlock:(DBDownloadDataResponseBlock)responseBlock {
  DBDownloadResponseBlockStorage storageBlock = ^(NSURL *location, NSURLResponse *response, NSError *clientError) {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = (int)httpResponse.statusCode;
    NSDictionary *httpHeaders = httpResponse.allHeaderFields;
    NSString *headerString = [DBTransportClientBase caseInsensitiveLookup:@"Dropbox-API-Result" dictionary:httpHeaders];
    NSData *resultData = headerString ? [headerString dataUsingEncoding:NSUTF8StringEncoding] : nil;

    if (clientError || !resultData) {
      // error data is in response body (downloaded to output tmp file)
      NSData *errorData = location ? [NSData dataWithContentsOfFile:[location path]] : nil;
      DBRequestError *dbxError = [DBTransportClientBase dBRequestErrorWithErrorData:errorData
                                                                        clientError:clientError
                                                                         statusCode:statusCode
                                                                        httpHeaders:httpHeaders];
      id routeError = [DBTransportClientBase statusCodeIsRouteError:statusCode]
                          ? [DBTransportClientBase routeErrorWithRouteData:_route data:errorData statusCode:statusCode]
                          : nil;
      return responseBlock(nil, routeError, dbxError, nil);
    }

    NSError *serializationError;
    id result =
        [DBTransportClientBase routeResultWithRouteData:_route data:resultData serializationError:&serializationError];
    if (serializationError) {
      responseBlock(nil, nil, [[DBRequestError alloc] initAsClientError:serializationError], nil);
      return;
    }
    result = !_route.resultType ? [DBNilObject new] : result;
    responseBlock(result, nil, nil, [NSData dataWithContentsOfFile:[location path]]);
  };

  return storageBlock;
}

@end
