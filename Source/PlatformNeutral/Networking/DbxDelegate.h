///
/// Delegate class to manage background session downloads / uploads.
///

@class DbxRpcData;
@class DbxUploadData;
@class DbxDownloadData;

@interface DbxDelegate : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

- (void)addRpcCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler;

- (void)addRpcProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler;

- (void)addUploadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))handler;

- (void)addUploadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler;

- (void)addUploadStream:(NSURLSessionTask *)task session:(NSURLSession *)session stream:(NSStream *)stream;

- (void)addDownloadCompletionHandler:(NSURLSessionTask *)task session:(NSURLSession *)session completionHandler:(void (^)(NSURL *, NSURLResponse *, NSError *))handler;

- (void)addDownloadProgressHandler:(NSURLSessionTask *)task session:(NSURLSession *)session progressHandler:(void (^)(int64_t, int64_t, int64_t))handler;


@property (nonatomic) NSMutableDictionary * _Nonnull responsesData;

@property (nonatomic) NSMutableDictionary * _Nonnull rpcTasks;
@property (nonatomic) NSMutableDictionary * _Nonnull uploadTasks;
@property (nonatomic) NSMutableDictionary * _Nonnull downloadTasks;

@end
