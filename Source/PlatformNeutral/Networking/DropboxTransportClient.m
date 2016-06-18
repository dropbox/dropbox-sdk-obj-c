	///
/// The networking client for the User and Business API.
///

#import "DbxAuthAuthError.h"
#import "DbxAuthRateLimitError.h"
#import "DbxDelegate.h"
#import "DbxErrors.h"
#import "DbxStoneBase.h"
#import "DbxTasks.h"
#import "DropboxTransportClient.h"

static NSString * const version = @"1.0.0";
static DbxDelegate *_delegate;
static NSURLSession *_session;
static NSURLSession *_backgroundSession;

typedef void(^ErrorBlock)(DbxError * _Nonnull error);

@implementation DropboxTransportClient {
    NSString * _Nullable _selectUser;
    NSDictionary <NSString *, NSString *> * _Nullable _baseHosts;
    NSString * _Nullable _userAgent;
}

+ (void) initialize {
    _delegate = [[DbxDelegate alloc] init];
    _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:_delegate delegateQueue:nil];
    _backgroundSession = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.dropbox.dropbox_sdk_obj_c_background"] delegate:_delegate delegateQueue:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken {
    return [self initWithAccessToken:accessToken andSelectUser:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser {
    return [self initWithAccessToken:accessToken andSelectUser:selectUser andBaseHosts:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> *)baseHosts {
    return [self initWithAccessToken:accessToken andSelectUser:selectUser andBaseHosts:baseHosts andUserAgent:nil];
}

- (instancetype)initWithAccessToken:(NSString *)accessToken andSelectUser:(NSString *)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> *)baseHosts andUserAgent:(NSString *)userAgent {
    self = [super init];
    if (self) {
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

- (DbxRpcTask *)requestRpc:(DbxRoute *)route arg:(id<DbxSerializable>)arg {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [DropboxTransportClient serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    // RPC request submits argument in request body
    NSData *serializedArgData = [DropboxTransportClient serializeArgData:arg];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:serializedArgData];

    NSURLSessionDataTask *task = [_session dataTaskWithRequest:request];
    DbxRpcTask *rpcTask = [[DbxRpcTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [task resume];
    
    return rpcTask;
}

- (DbxUploadTask *)requestUpload:(DbxRoute *)route arg:(id<DbxSerializable>)arg inputURL:(NSURL *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil];

    NSURLSessionUploadTask *task = [_backgroundSession uploadTaskWithRequest:request fromFile:input];
    DbxUploadTask *uploadTask = [[DbxUploadTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
    [task resume];

    return uploadTask;
}

- (DbxUploadTask *)requestUpload:(DbxRoute *)route arg:(id<DbxSerializable>)arg inputData:(NSData *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil];
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithRequest:request fromData:input];
    DbxUploadTask *uploadTask = [[DbxUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [task resume];
    
    return uploadTask;
}

- (DbxUploadTask *)requestUpload:(DbxRoute *)route arg:(id<DbxSerializable>)arg inputStream:(NSStream *)input {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil];
    
    NSURLSessionUploadTask *task = [_session uploadTaskWithStreamedRequest:request];
    DbxUploadTask *uploadTask = [[DbxUploadTask alloc] initWithTask:task session:_session delegate:_delegate route:route];
    [_delegate addUploadStream:task session:_session stream:input];
    [task resume];
    
    return uploadTask;
}

- (DbxDownloadURLTask *)requestDownload:(DbxRoute *)route arg:(id<DbxSerializable>)arg overwrite:(BOOL)overwrite destination:(NSURL *)destination {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil];

    NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
    DbxDownloadURLTask *downloadTask = [[DbxDownloadURLTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route overwrite:overwrite destination:destination];
    [task resume];

    return downloadTask;
}

- (DbxDownloadDataTask *)requestDownload:(DbxRoute *)route arg:(id<DbxSerializable>)arg {
    NSURL *requestUrl = [self getUrl:route];
    NSString *serializedArg = [[self class] serializeArgString:arg];
    NSDictionary *headers = [self getHeaders:route.attrs[@"style"] serializedArg:serializedArg host:route.attrs[@"host"]];
    
    NSURLRequest *request = [[self class] getRequest:headers url:requestUrl content:nil];
    
    NSURLSessionDownloadTask *task = [_backgroundSession downloadTaskWithRequest:request];
    DbxDownloadDataTask *downloadTask = [[DbxDownloadDataTask alloc] initWithTask:task session:_backgroundSession delegate:_delegate route:route];
    [task resume];
    
    return downloadTask;
}

+ (NSURLRequest *)getRequest:(NSDictionary *)httpHeaders url:(NSURL *)url content:(NSData *)content {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    for (NSString *key in httpHeaders) {
        [request addValue:httpHeaders[key] forHTTPHeaderField:key];
    }
    request.HTTPMethod = @"POST";
    if (content) {
        request.HTTPBody = content;
    }
    return request;
}

- (NSURL *)getUrl:(DbxRoute *)route {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", _baseHosts[route.attrs[@"host"]], route.namespace_, route.name]];
}

- (NSDictionary *)getHeaders:(NSString *)routeStyle serializedArg:(NSString *)serializedArg host:(NSString *)host {
    NSMutableDictionary <NSString *, NSString *> * headers = [[NSMutableDictionary alloc] init];
    [headers setObject:_userAgent forKey:@"User-Agent"];
    
    if (_selectUser != nil) {
        [headers setObject:_selectUser forKey:@"Dropbox-Api-Select-User"];
    }
    
    BOOL noauth = [host isEqualToString:@"notify"];
    
    if (!noauth) {
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

+ (NSData *)serializeArgData:(id<DbxSerializable>)arg {
    if (arg == nil) {
        return nil;
    }
    NSDictionary *serializedDict = [[arg class] serialize:arg];
    return [DropboxTransportClient jsonDataFromDict:serializedDict];
}

+ (NSString *)serializeArgString:(id<DbxSerializable>)arg {
    if (arg == nil) {
        return nil;
    }
    NSData *jsonData = [self serializeArgData:arg];
    NSString *asciiEscapedStr = [DropboxTransportClient asciiEscapeString:[DropboxTransportClient utf8StringFromData:jsonData]];
    NSMutableString *filteredStr = [[NSMutableString alloc] initWithString:asciiEscapedStr];
    [filteredStr replaceOccurrencesOfString:@"\\/" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, filteredStr.length)];
    return filteredStr;
}

+ (NSData *)jsonDataFromDict:(NSDictionary *)dict {
    if (dict == nil) {
        return nil;
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];

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
