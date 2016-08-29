#import <Foundation/Foundation.h>
#import "DBXAuthAuthError.h"
#import "DBXAuthRateLimitError.h"
#import "DBXDelegate.h"
#import "DBXErrors.h"
#import "DBXStoneBase.h"
#import "DBXTasks.h"
#import "DBXTransportClient.h"

@implementation DBXTask

- (DBXError *)getDBXError:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error statusCode:(int)statusCode httpHeaders:(NSDictionary *)httpHeaders {
    DBXError *dbxError = nil;
    
    if (statusCode == 200) {
        return dbxError;
    }

    NSDictionary *deserializedData = [self deserializeHttpData:data];
    
    NSString *requestId = httpHeaders[@"X-Dropbox-Request-Id"];
    NSString *errorContent = deserializedData ? deserializedData[@"error_summary"] : [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if (statusCode >= 500 && statusCode < 600) {
        dbxError = [[DBXError alloc] initAsInternalServerError:requestId statusCode:@(statusCode) errorContent:errorContent];
    } else if (statusCode == 400) {
        dbxError = [[DBXError alloc] initAsBadInputError:requestId statusCode:@(statusCode) errorContent:errorContent];
    } else if (statusCode == 401) {
        DBXAUTHAuthError *authError = [DBXAUTHAuthErrorSerializer deserialize:deserializedData[@"error"]];
        dbxError = [[DBXError alloc] initAsAuthError:requestId statusCode:@(statusCode) errorContent:errorContent structuredAuthError:authError];
    } else if (statusCode == 429) {
        DBXAUTHRateLimitError *rateLimitError = [DBXAUTHRateLimitErrorSerializer deserialize:deserializedData[@"error"]];
        NSString *retryAfter = httpHeaders[@"Retry-After"];
        double retryAfterSeconds = retryAfter.doubleValue;
        dbxError = [[DBXError alloc] initAsRateLimitError:requestId statusCode:@(statusCode) errorContent:errorContent structuredRateLimitError:rateLimitError backoff:@(retryAfterSeconds)];
    } else if (statusCode == 403 || statusCode == 404 || statusCode == 409) {
        dbxError = [[DBXError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
    } else if (!response) {
        dbxError = [[DBXError alloc] initAsOSError:errorContent];
    } else {
        dbxError = [[DBXError alloc] initAsHttpError:requestId statusCode:@(statusCode) errorContent:errorContent];
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


@implementation DBXRpcTask

- (instancetype)initWithTask:(NSURLSessionDataTask *)task session:(NSURLSession *)session delegate:(DBXDelegate *)delegate route:(DBXRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DBXRpcTask *)response:(void (^)(id, id, DBXError *))responseBlock {
    void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        
        DBXError *dbxError = [self getDBXError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil);
    };
    
    [_delegate addRpcResponseHandler:_task session:_session responseHandler:handler];
    
    return self;
}

- (DBXRpcTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DBXUploadTask

- (instancetype)initWithTask:(NSURLSessionUploadTask *)task session:(NSURLSession *)session delegate:(DBXDelegate *)delegate route:(DBXRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DBXUploadTask *)response:(void (^)(id, id, DBXError *))responseBlock {
    void (^handler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        
        DBXError *dbxError = [self getDBXError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil);
    };
    
    [_delegate addUploadResponseHandler:_task session:_session responseHandler:handler];
    
    return self;
}

- (DBXUploadTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DBXDownloadURLTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task session:(NSURLSession *)session delegate:(DBXDelegate *)delegate route:(DBXRoute *)route overwrite:(BOOL)overwrite destination:(NSURL *)destination {
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

- (DBXDownloadURLTask *)response:(void (^)(id, id, DBXError *dbxError, NSURL *))responseBlock {
    void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        NSData *data = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];

        DBXError *dbxError = [self getDBXError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
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
    
    [_delegate addDownloadResponseHandler:_task session:_session responseHandler:handler];
    
    return self;
}

- (DBXDownloadURLTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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


@implementation DBXDownloadDataTask

- (instancetype)initWithTask:(NSURLSessionDownloadTask *)task session:(NSURLSession *)session delegate:(DBXDelegate *)delegate route:(DBXRoute *)route {
    self = [self init];
    if (self) {
        _task = task;
        _session = session;
        _delegate = delegate;
        _route = route;
    }
    return self;
}

- (DBXDownloadDataTask *)response:(void (^)(id, id, DBXError *dbxError, NSData *))responseBlock {
    void (^handler)(NSURL *, NSURLResponse *, NSError *) = ^(NSURL *location, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        int statusCode = (int)httpResponse.statusCode;
        NSDictionary *httpHeaders = httpResponse.allHeaderFields;
        NSData *data = [httpHeaders[@"Dropbox-API-Result"] dataUsingEncoding:NSUTF8StringEncoding];
        
        DBXError *dbxError = [self getDBXError:data response:response error:error statusCode:statusCode httpHeaders:httpHeaders];
        if (dbxError) {
            id routeError = [self getRouteError:data statusCode:statusCode];
            return responseBlock(nil, routeError, dbxError, nil);
        }
        
        id result = [self getResult:data];
        responseBlock(result, nil, nil, [NSData dataWithContentsOfFile:[location path]]);
    };
    
    [_delegate addDownloadResponseHandler:_task session:_session responseHandler:handler];
    
    return self;
}

- (DBXDownloadDataTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock {
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