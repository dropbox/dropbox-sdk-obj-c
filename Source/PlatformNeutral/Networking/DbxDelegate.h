///
/// Delegate class to manage background session downloads / uploads.
///

@class DBXRpcData;
@class DBXUploadData;
@class DBXDownloadData;

@interface DBXDelegate : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

@property (nonatomic) NSOperationQueue * _Nonnull delegateQueue;

@property (nonatomic, copy) NSString * _Nonnull foregroundIdentifier;

@property (nonatomic) NSMutableDictionary * _Nonnull responsesData;

@property (nonatomic) NSMutableDictionary * _Nonnull rpcTasks;

@property (nonatomic) NSMutableDictionary * _Nonnull uploadTasks;

@property (nonatomic) NSMutableDictionary * _Nonnull downloadTasks;

- (nonnull instancetype)initWithQueue:(NSOperationQueue * _Nonnull)delegateQueue;

- (void)addRpcCompletionHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session completionHandler:(void (^_Nonnull)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

- (void)addRpcProgressHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

- (void)addUploadCompletionHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session completionHandler:(void (^_Nonnull)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

- (void)addUploadProgressHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

- (void)addDownloadCompletionHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session completionHandler:(void (^_Nonnull)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

- (void)addDownloadProgressHandler:(NSURLSessionTask * _Nonnull)task session:(NSURLSession * _Nonnull)session progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

@end
