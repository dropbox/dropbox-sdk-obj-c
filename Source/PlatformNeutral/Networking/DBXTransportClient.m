	///
/// The networking client for the User and Business API.
///

#import "DBXAuthAuthError.h"
#import "DBXAuthRateLimitError.h"
#import "DBXDelegate.h"
#import "DBXErrors.h"
#import "DBXStoneBase.h"
#import "DBXTasks.h"
#import "DBXTransportClient.h"

static NSString * const version = @"1.0.0";
static DBXDelegate *_delegate;
static NSURLSession *_session;
static NSURLSession *_backgroundSession;
static NSString *kBackgroundSessionId = @"com.dropbox.dropbox_sdk_obj_c_background";

typedef void(^ErrorBlock)(DBXError * _Nonnull error);

@implementation DBXTransportClient

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    return [self initWithAccessToken:accessToken andSelectUser:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser {
    return [self initWithAccessToken:accessToken andSelectUser:selectUser andBaseHosts:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andBackgroundSessionId:(NSString *)backgroundSessionId {
    return [self initWithAccessToken:accessToken andSelectUser:nil andBaseHosts:nil andUserAgent:nil andBackgroundSessionId:backgroundSessionId];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> *)baseHosts {
    return [self initWithAccessToken:accessToken andSelectUser:selectUser andBaseHosts:baseHosts andUserAgent:nil andBackgroundSessionId:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> *)baseHosts andUserAgent:(NSString *)userAgent andBackgroundSessionId:(NSString *)backgroundSessionId {
    self = [super init];
    if (self) {
        _delegateQueue = [NSOperationQueue new];
        [_delegateQueue setMaxConcurrentOperationCount:1];
        _delegate = [[DBXDelegate alloc] initWithQueue:_delegateQueue];
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:_delegate delegateQueue:_delegateQueue];
        NSString *backgroundId = backgroundSessionId ?: [NSString stringWithFormat:@"%@%lld", kBackgroundSessionId, (long long)[[NSDate date] timeIntervalSince1970] * 1000];
        _backgroundSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundId] delegate:_delegate delegateQueue:_delegateQueue];

        NSDictionary <NSString *, NSString *> * defaultBaseHosts = @{
            @"api" : @"https://api.dropbox.com/2",
            @"content" : @"https://api-content.dropbox.com/2",
            @"notify" : @"https://notify.dropboxapi.com/2",
        };
        
        NSString *defaultUserAgent = [NSString stringWithFormat:@"OfficialDropboxObjCSDKv2/%@", version];
        
        _accessToken = accessToken;
        _selectUser = selectUser;
        _baseHosts = baseHosts ?: defaultBaseHosts;
        _userAgent = userAgent ? [[userAgent stringByAppendingString:@"/"] stringByAppendingString:defaultUserAgent] : defaultUserAgent;
    }
    return self;
}

- (DBXRpcTask *)requestRpc:(DBXRoute *)route arg:(id<DBXSerializable>)arg {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    // RPC request submits argument in request body
    NSData *serializedArgData = [[self class] serializeArgData:route routeArg:arg];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:serializedArgData stream:nil];

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    DBXRpcTask *rpcTask = [[DBXRpcTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [task resume];
    
    return rpcTask;
}

- (DBXUploadTask *)requestUpload:(DBXRoute *)route arg:(id<DBXSerializable>)arg inputURL:(NSURL *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil stream:nil];

    NSURLSessionUploadTask *task = [_backgroundSession uploadTaskWithRequest:request fromFile:input];
    DBXUploadTask *uploadTask = [[DBXUploadTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
    [task resume];

    return uploadTask;
}

- (DBXUploadTask *)requestUpload:(DBXRoute *)route arg:(id<DBXSerializable>)arg inputData:(NSData *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil stream:nil];
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:input];
    DBXUploadTask *uploadTask = [[DBXUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [task resume];
    
    return uploadTask;
}

- (DBXUploadTask *)requestUpload:(DBXRoute *)route arg:(id<DBXSerializable>)arg inputStream:(NSInputStream *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil stream:input];
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithStreamedRequest:request];
    DBXUploadTask *uploadTask = [[DBXUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [task resume];
    
    return uploadTask;
}

- (DBXDownloadURLTask *)requestDownload:(DBXRoute *)route arg:(id<DBXSerializable>)arg overwrite:(BOOL)overwrite destination:(NSURL *)destination {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil stream:nil];

    NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
    DBXDownloadURLTask *downloadTask = [[DBXDownloadURLTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route overwrite:overwrite destination:destination];
    [task resume];

    return downloadTask;
}

- (DBXDownloadDataTask *)requestDownload:(DBXRoute *)route arg:(id<DBXSerializable>)arg {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:route routeArg:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil stream:nil];
    
    NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
    DBXDownloadDataTask *downloadTask = [[DBXDownloadDataTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
    [task resume];
    
    return downloadTask;
}

+ (NSURLRequest *)getRequest:(NSDictionary *)httpHeaders url:(NSURL *)url content:(NSData *)content stream:(NSInputStream *)stream {
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

- (NSURL *)getUrl:(DBXRoute *)route {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", _baseHosts[route.attrs[@"host"]], route.namespace_, route.name]];
}

- (NSDictionary *)getHeaders:(NSString *)routeStyle serializedArg:(NSString *)serializedArg host:(NSString *)host {
    NSMutableDictionary <NSString *, NSString *> * headers = [[NSMutableDictionary alloc] init];
    [headers setObject:_userAgent forKey:@"User-Agent"];
    
    BOOL noauth = [host isEqualToString:@"notify"];

    if (!noauth) {
        
        if (_selectUser) {
            [headers setObject:_selectUser forKey:@"Dropbox-Api-Select-User"];
        }

        [headers setObject:[NSString stringWithFormat:@"Bearer %@", _accessToken] forKey:@"Authorization"];
    }
    
    if ([routeStyle isEqualToString:@"rpc"]) {
        if (serializedArg != nil) {
            [headers setObject:@"application/json" forKey:@"Content-Type"];
        }
    } else if ([routeStyle isEqualToString:@"upload"]) {
        [headers setObject:@"application/octet-stream" forKey:@"Content-Type"];
        if (serializedArg != nil) {
            [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
        }
    } else if ([routeStyle isEqualToString:@"download"]) {
        if (serializedArg != nil) {
            [headers setObject:serializedArg forKey:@"Dropbox-API-Arg"];
        }
    }
    
    return headers;
}

+ (NSData *)serializeArgData:(DBXRoute *)route routeArg:(id<DBXSerializable>)arg {
    if (arg == nil) {
        return nil;
    }

    if (route.arraySerialBlock) {
        NSArray *serializedArray = route.arraySerialBlock(arg);
        return [[self class] jsonDataFromJsonObj:serializedArray];
    }

    NSDictionary *serializedDict = [[arg class] serialize:arg];
    return [[self class] jsonDataFromJsonObj:serializedDict];
}

+ (NSString *)serializeArgString:(DBXRoute *)route routeArg:(id<DBXSerializable>)arg {
    if (arg == nil) {
        return nil;
    }
    NSData *jsonData = [self serializeArgData:route routeArg:arg];
    NSString *asciiEscapedStr = [[self class] asciiEscapeString:[[self class] utf8StringFromData:jsonData]];
    NSMutableString *filteredStr = [[NSMutableString alloc] initWithString:asciiEscapedStr];
    [filteredStr replaceOccurrencesOfString:@"\\/" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, [filteredStr length])];
    return filteredStr;
}

+ (NSData *)jsonDataFromJsonObj:(id)jsonObj {
    if (jsonObj == nil) {
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

+ (NSString *)utf8StringFromData:(NSData *)jsonData {
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (NSString *)asciiEscapeString:(NSString *)string {
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < string.length; i++) {
        NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
        if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding]) {
            [result appendString:substring];
        }
        else {
            [result appendFormat:@"\\u%04x", [string characterAtIndex:i]];
        }
    }
    return result;
}

+ (NSURLSession *)session {
    @synchronized (self) {
        return _session;
    }
}

+ (void)setSession:(NSURLSession *)session {
    @synchronized (self) {
        _session = session;
    }
}

+ (NSURLSession *)backgroundSession {
    @synchronized (self) {
        return _backgroundSession;
    }
}

+ (void)setBackgroundSession:(NSURLSession *)backgroundSession {
    @synchronized (self) {
        _backgroundSession = backgroundSession;
    }
}

@end
