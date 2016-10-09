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

static NSString const *const kVersion = @"1.1.2";
static NSString const *const kDefaultUserAgentPrefix = @"OfficialDropboxObjCSDKv2";
static NSString const *const kBackgroundSessionId = @"com.dropbox.dropbox_sdk_obj_c_background";

@interface DBTransportClient ()

@property (nonatomic, readonly) NSDictionary<NSString *, NSString *> * _Nonnull baseHosts;
@property (nonatomic, readonly, copy) NSString * _Nonnull userAgent;

@end

@implementation DBTransportClient

@synthesize backgroundSession = _backgroundSession;

#pragma mark - Constructors

- (instancetype)initWithAccessToken:(NSString *)accessToken {
  return [self initWithAccessToken:accessToken selectUser:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken selectUser:(NSString *)selectUser {
  return [self initWithAccessToken:accessToken selectUser:selectUser baseHosts:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken backgroundSessionId:(NSString *)backgroundSessionId {
  return [self initWithAccessToken:accessToken
                        selectUser:nil
                         baseHosts:nil
                         userAgent:nil
               backgroundSessionId:backgroundSessionId
                     delegateQueue:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
                         selectUser:(NSString *)selectUser
                          baseHosts:(NSDictionary<NSString *, NSString *> *)baseHosts {
  return [self initWithAccessToken:accessToken
                        selectUser:selectUser
                         baseHosts:baseHosts
                         userAgent:nil
               backgroundSessionId:nil
                     delegateQueue:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken
                         selectUser:(NSString *)selectUser
                          baseHosts:(NSDictionary<NSString *, NSString *> *)baseHosts
                          userAgent:(NSString *)userAgent
                backgroundSessionId:(NSString *)backgroundSessionId
                      delegateQueue:(NSOperationQueue *)delegateQueue {
  self = [super init];
  if (self) {
    _delegateQueue = delegateQueue ?: [NSOperationQueue mainQueue];
    _delegate = [[DBDelegate alloc] initWithQueue:_delegateQueue];

    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 100.0;

    _session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:_delegate delegateQueue:_delegateQueue];
    NSString *backgroundId =
        backgroundSessionId ?: [NSString stringWithFormat:@"%@.%@", kBackgroundSessionId, [NSUUID UUID].UUIDString];
    NSURLSessionConfiguration *backgroundSessionConfig =
        [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundId];
    backgroundSessionConfig.timeoutIntervalForRequest = 100.0;
    _backgroundSession =
        [NSURLSession sessionWithConfiguration:backgroundSessionConfig delegate:_delegate delegateQueue:_delegateQueue];

    NSDictionary<NSString *, NSString *> *defaultBaseHosts = @{
      @"api" : @"https://api.dropbox.com/2",
      @"content" : @"https://api-content.dropbox.com/2",
      @"notify" : @"https://notify.dropboxapi.com/2",
    };

    NSString *defaultUserAgent = [NSString stringWithFormat:@"%@/%@", kDefaultUserAgentPrefix, kVersion];

    _accessToken = accessToken;
    _selectUser = selectUser;
    _baseHosts = baseHosts ?: defaultBaseHosts;
    _userAgent = userAgent ? [[userAgent stringByAppendingString:@"/"] stringByAppendingString:defaultUserAgent]
                           : defaultUserAgent;
  }
  return self;
}

#pragma mark - RPC-style request

- (DBRpcTask *)requestRpc:(DBRoute *)route arg:(id<DBSerializable>)arg {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  // RPC request submits argument in request body
  NSData *serializedArgData = [[self class] serializeArgData:route routeArg:arg];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:serializedArgData stream:nil];

  NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
  DBRpcTask *rpcTask = [[DBRpcTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
  [task resume];

  return rpcTask;
}

#pragma mark - Upload-style request (NSURL)

- (DBUploadTask *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputUrl:(NSURL *)input {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionUploadTask *task = [_backgroundSession uploadTaskWithRequest:request fromFile:input];
  DBUploadTask *uploadTask =
      [[DBUploadTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Upload-style request (NSData)

- (DBUploadTask *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputData:(NSData *)input {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:input];
  DBUploadTask *uploadTask = [[DBUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Upload-style request (NSInputStream)

- (DBUploadTask *)requestUpload:(DBRoute *)route arg:(id<DBSerializable>)arg inputStream:(NSInputStream *)input {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:input];

  NSURLSessionUploadTask *task = [_session uploadTaskWithStreamedRequest:request];
  DBUploadTask *uploadTask = [[DBUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
  [task resume];

  return uploadTask;
}

#pragma mark - Download-style request (NSURL)

- (DBDownloadUrlTask *)requestDownload:(DBRoute *)route
                                   arg:(id<DBSerializable>)arg
                             overwrite:(BOOL)overwrite
                           destination:(NSURL *)destination {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
  DBDownloadUrlTask *downloadTask = [[DBDownloadUrlTask alloc] initWithTask:task
                                                                    session:_backgroundSession
                                                                   delegate:_delegate
                                                                      route:route
                                                                  overwrite:overwrite
                                                                destination:destination];
  [task resume];

  return downloadTask;
}

#pragma mark - Download-style request (NSData)

- (DBDownloadDataTask *)requestDownload:(DBRoute *)route arg:(id<DBSerializable>)arg {
  NSURL *requestUrl = [self urlWithRoute:route];
  NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
  NSDictionary *headers =
      [self headersWithRouteInfo:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];

  NSURLRequest *request = [[self class] requestWithHeaders:headers url:requestUrl content:nil stream:nil];

  NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
  DBDownloadDataTask *downloadTask =
      [[DBDownloadDataTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
  [task resume];

  return downloadTask;
}

#pragma mark - Internal serialization helpers

+ (NSURLRequest *)requestWithHeaders:(NSDictionary *)httpHeaders
                                 url:(NSURL *)url
                             content:(NSData *)content
                              stream:(NSInputStream *)stream {
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  for (NSString *key in httpHeaders) {
    [request addValue:httpHeaders[key] forHTTPHeaderField:key];
  }
  request.HTTPMethod = @"POST";
  if (content) {
    request.HTTPBody = content;
  }
  if (stream) {
    request.HTTPBodyStream = stream;
  }
  return request;
}

- (NSURL *)urlWithRoute:(DBRoute *)route {
  return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", _baseHosts[route.attrs[@"host"]],
                                                         route.namespace_, route.name]];
}

- (NSDictionary *)headersWithRouteInfo:(NSString *)routeStyle
                         serializedArg:(NSString *)serializedArg
                                  host:(NSString *)host {
  NSMutableDictionary<NSString *, NSString *> *headers = [[NSMutableDictionary alloc] init];
  [headers setObject:_userAgent forKey:@"User-Agent"];

  BOOL noauth = [host isEqualToString:@"notify"];

  if (!noauth) {

    if (_selectUser) {
      [headers setObject:_selectUser forKey:@"Dropbox-Api-Select-User"];
    }

    [headers setObject:[NSString stringWithFormat:@"Bearer %@", _accessToken] forKey:@"Authorization"];
  }

  if ([routeStyle isEqualToString:@"rpc"]) {
    if (serializedArg) {
      [headers setObject:@"application/json" forKey:@"Content-Type"];
    }
  } else if ([routeStyle isEqualToString:@"upload"]) {
    [headers setObject:@"application/octet-stream" forKey:@"Content-Type"];
    if (serializedArg) {
      [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
    }
  } else if ([routeStyle isEqualToString:@"download"]) {
    if (serializedArg) {
      [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
    }
  }

  return headers;
}

+ (NSData *)serializeArgData:(DBRoute *)route routeArg:(id<DBSerializable>)arg {
  if (!arg) {
    return nil;
  }

  if (route.arraySerialBlock) {
    NSArray *serializedArray = route.arraySerialBlock(arg);
    return [[self class] jsonDataWithJsonObj:serializedArray];
  }

  NSDictionary *serializedDict = [[arg class] serialize:arg];
  return [[self class] jsonDataWithJsonObj:serializedDict];
}

+ (NSString *)serializeArgString:(DBRoute *)route routeArg:(id<DBSerializable>)arg {
  if (!arg) {
    return nil;
  }
  NSData *jsonData = [self serializeArgData:route routeArg:arg];
  NSString *asciiEscapedStr = [[self class] asciiEscapeWithString:[[self class] utf8StringWithData:jsonData]];
  NSMutableString *filteredStr = [[NSMutableString alloc] initWithString:asciiEscapedStr];
  [filteredStr replaceOccurrencesOfString:@"\\/"
                               withString:@"/"
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [filteredStr length])];
  return filteredStr;
}

+ (NSData *)jsonDataWithJsonObj:(id)jsonObj {
  if (!jsonObj) {
    return nil;
  }

  NSError *error;
  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObj options:0 error:&error];

  if (!jsonData) {
    NSLog(@"Error serializing dictionary: %@", error.localizedDescription);
    return nil;
  } else {
    return jsonData;
  }
}

+ (NSString *)utf8StringWithData:(NSData *)jsonData {
  return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)asciiEscapeWithString:(NSString *)string {
  NSMutableString *result = [[NSMutableString alloc] init];
  for (int i = 0; i < string.length; i++) {
    NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
    if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding]) {
      [result appendString:substring];
    } else {
      [result appendFormat:@"\\u%04x", [string characterAtIndex:i]];
    }
  }
  return result;
}

#pragma mark - Session accessors and mutators

- (NSURLSession *)session {
  @synchronized(self) {
    return _session;
  }
}

- (void)session:(NSURLSession *)session {
  @synchronized(self) {
    _session = session;
  }
}

- (NSURLSession *)backgroundSession {
  @synchronized(self) {
    return _backgroundSession;
  }
}

- (void)setBackgroundSession:(NSURLSession *)backgroundSession {
  @synchronized(self) {
    _backgroundSession = backgroundSession;
  }
}

@end
