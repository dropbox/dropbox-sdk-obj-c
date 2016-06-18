///
/// Classes encapsulating logic for each Dropbox API request type.
///

@class DbxDelegate;
#import "DbxErrors.h"
@class DbxRoute;
#import "DbxStoneSerializers.h"

@interface DbxTask : NSObject {
    NSURLSession *_session;
    DbxDelegate *_delegate;
    DbxRoute *_route;
}

@property (nonatomic) NSURLSession * _Nonnull session;
@property (nonatomic) DbxDelegate * _Nonnull delegate;
@property (nonatomic) DbxRoute * _Nonnull route;

@end


@interface DbxRpcTask<TResponse, TError> : DbxTask

- (nonnull instancetype)initWithTask:(NSURLSessionDataTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxRpcTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable))responseBlock;

- (DbxRpcTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;
- (void)suspend;
- (void)resume;

@property (nonatomic) NSURLSessionDataTask * _Nonnull task;

@end


@interface DbxUploadTask<TResponse, TError> : DbxTask

- (nonnull instancetype)initWithTask:(NSURLSessionUploadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxUploadTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable))responseBlock;

- (DbxUploadTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;
- (void)suspend;
- (void)resume;

@property (nonatomic) NSURLSessionUploadTask * _Nonnull task;

@end


@interface DbxDownloadURLTask<TResponse, TError> : DbxTask

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

- (DbxDownloadURLTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable, NSURL * _Nonnull))responseBlock;

- (DbxDownloadURLTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;
- (void)suspend;
- (void)resume;

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;
@property (nonatomic) BOOL overwrite;
@property (nonatomic) NSURL * _Nonnull destination;

@end


@interface DbxDownloadDataTask<TResponse, TError> : DbxTask

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxDownloadDataTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable, NSData * _Nonnull))responseBlock;

- (DbxDownloadDataTask *)progress:(void (^)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;
- (void)suspend;
- (void)resume;

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;

@end
