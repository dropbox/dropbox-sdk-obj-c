///
/// Classes encapsulating logic for each Dropbox API request type.
///

@class DBXDelegate;
#import "DBXErrors.h"
@class DBXRoute;
#import "DBXStoneSerializers.h"

@interface DBXTask : NSObject {
    NSURLSession *_session;
    DBXDelegate *_delegate;
    DBXRoute *_route;
}

@property (nonatomic) NSURLSession * _Nonnull session;

@property (nonatomic) DBXDelegate * _Nonnull delegate;

@property (nonatomic) DBXRoute * _Nonnull route;

@end


@interface DBXRpcTask<TResponse, TError> : DBXTask

@property (nonatomic) NSURLSessionDataTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionDataTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

- (DBXRpcTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable))responseBlock;

- (DBXRpcTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DBXUploadTask<TResponse, TError> : DBXTask

@property (nonatomic) NSURLSessionUploadTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionUploadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

- (DBXUploadTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable))responseBlock;

- (DBXUploadTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DBXDownloadURLTask<TResponse, TError> : DBXTask

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;

@property (nonatomic) BOOL overwrite;

@property (nonatomic, copy) NSURL * _Nonnull destination;

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

- (DBXDownloadURLTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable, NSURL * _Nonnull))responseBlock;

- (DBXDownloadURLTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DBXDownloadDataTask<TResponse, TError> : DBXTask

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

- (DBXDownloadDataTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable, NSData * _Nonnull))responseBlock;

- (DBXDownloadDataTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end
