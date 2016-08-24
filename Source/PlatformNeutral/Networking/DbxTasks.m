///
/// Classes encapsulating logic for each Dropbox API request type.
///

#import <Foundation/Foundation.h>
#import "DbxTasks.h"

#import "DbxAuthAuthError.h"
#import "DbxAuthRateLimitError.h"
#import "DbxDelegate.h"
#import "DbxErrors.h"
#import "DbxStoneBase.h"
#import "DbxTasks.h"
#import "DropboxTransportClient.h"
#import "DbxDelegate.h"

@implementation DbxTask

- (DbxError *)getDbxError:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error statusCode:(int)statusCode httpHeaders:(NSDictionary *)httpHeaders {
    DbxError *dbxError = nil;

    if (error || statusCode != 200) {
        NSDictionary *deserializedData = [self deserializeHttpData:data];
        
        NSString *requestId = httpHeaders[@"X-Dropbox-Request-Id"];
        NSString *errorSummary = deserializedData ? deserializedData[@"error_summary"] : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        if (statusCode >= 500 && statusCode < 600) {
            dbxError = [[DbxError alloc] init:DbxRequestInternalServerErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:nil structuredAuthError:nil structuredRateLimitError:nil backoff:nil errorDescription:nil];
        } else if (statusCode == 400) {
            dbxError = [[DbxError alloc] init:DbxRequestBadInputErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:errorSummary structuredAuthError:nil structuredRateLimitError:nil backoff:nil errorDescription:nil];
        } else if (statusCode == 401) {
            dbxError = [[DbxError alloc] init:DbxRequestAuthErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:nil structuredAuthError:[DbxAuthAuthErrorSerializer deserialize:deserializedData[@"error"]] structuredRateLimitError:nil backoff:nil errorDescription:nil];
        } else if (statusCode == 429) {
            NSString *retryAfter = httpHeaders[@"Retry-After"];
            double retryAfterSeconds = retryAfter.doubleValue;
            dbxError = [[DbxError alloc] init:DbxRequestRateLimitErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:nil structuredAuthError:nil structuredRateLimitError:[DbxAuthRateLimitErrorSerializer deserialize:deserializedData[@"error"]] backoff:[NSNumber numberWithInt:retryAfterSeconds] errorDescription:nil];
        } else if (statusCode == 403 || statusCode == 404 || statusCode == 409) {
            dbxError = [[DbxError alloc] init:DbxRequestHttpErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:nil structuredAuthError:nil structuredRateLimitError:nil backoff:nil errorDescription:nil];
        } else {
            dbxError = [[DbxError alloc] init:DbxRequestHttpErrorType requestId:requestId statusCode:[NSNumber numberWithInteger:statusCode] errorBody:errorSummary errorMessage:nil structuredAuthError:nil structuredRateLimitError:nil backoff:nil errorDescription:nil];
        }
    }
    
    return dbxError;
}

- (id)getRouteError:(NSData *)data statusCode:(int)statusCode {
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

- (id)getResult:(NSData *)data {
    if (!_route.resultType) {
        return nil;
    }
    NSError *serializationError;
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializationError];
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


@implementation DbxRpcTask

- (instancetype)initWithTask:(NSURLSessionDataTask *)task session:(NSURLSession *)session delegate:(DbxDelegate *)delegate route:(DbxRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DbxRpcTask *)response:(void (^)(id, id, DbxError *))responseBlock {
    void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        
        DbxError *dbxError = [self getDbxError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil);
    };
    
    [_delegate addRpcCompletionHandler:_task session:_session completionHandler:handler];
    
    return self;
}

- (DbxRpcTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DbxUploadTask

- (instancetype)initWithTask:(NSURLSessionUploadTask *)task session:(NSURLSession *)session delegate:(DbxDelegate *)delegate route:(DbxRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DbxUploadTask *)response:(void (^)(id, id, DbxError *))responseBlock {
    void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        
        DbxError *dbxError = [self getDbxError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil);
    };
    
    [_delegate addUploadCompletionHandler:_task session:_session completionHandler:handler];
    
    return self;
}

- (DbxUploadTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DbxDownloadURLTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task session:(NSURLSession *)session delegate:(DbxDelegate *)delegate route:(DbxRoute *)route overwrite:(BOOL)overwrite destination:(NSURL *)destination {
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

- (DbxDownloadURLTask *)response:(void (^)(id, id, DbxError *dbxError, NSURL *))responseBlock {
    void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        NSData *data = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];

        DbxError *dbxError = [self getDbxError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError, _destination);
        }

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *path = [_destination path];
        
        if (![fileManager fileExistsAtPath:path]) {
            if (_overwrite) {
                NSError *fileMoveError;
                NSLog([fileManager removeItemAtPath:[_destination path] error:&fileMoveError] ? @"File deleted at %@." : @"File not deleted at %@.", path);
                [fileManager moveItemAtPath:[location path] toPath:path error:&fileMoveError];
            } else {
                NSLog(@"File already exists at path: %@", path);
            }
        } else {
            NSError *fileMoveError;
            [fileManager moveItemAtPath:[location path] toPath:path error:&fileMoveError];
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil, _destination);
    };
    
    [_delegate addDownloadCompletionHandler:_task session:_session completionHandler:handler];
    
    return self;
}

- (DbxDownloadURLTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DbxDownloadDataTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task session:(NSURLSession *)session delegate:(DbxDelegate *)delegate route:(DbxRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DbxDownloadDataTask *)response:(void (^)(id, id, DbxError *dbxError, NSData *))responseBlock {
    void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        NSData *data = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];
        
        DbxError *dbxError = [self getDbxError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError, nil);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil, [NSData dataWithContentsOfFile:[location path]]);
    };
    
    [_delegate addDownloadCompletionHandler:_task session:_session completionHandler:handler];
    
    return self;
}

- (DbxDownloadDataTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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