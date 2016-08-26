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

@property (nonatomic) NSURLSessionDataTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionDataTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxRpcTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable))responseBlock;

- (DbxRpcTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DbxUploadTask<TResponse, TError> : DbxTask

@property (nonatomic) NSURLSessionUploadTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionUploadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxUploadTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable))responseBlock;

- (DbxUploadTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DbxDownloadURLTask<TResponse, TError> : DbxTask

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;

@property (nonatomic) BOOL overwrite;

@property (nonatomic, copy) NSURL * _Nonnull destination;

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

- (DbxDownloadURLTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable, NSURL * _Nonnull))responseBlock;

- (DbxDownloadURLTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end


@interface DbxDownloadDataTask<TResponse, TError> : DbxTask

@property (nonatomic) NSURLSessionDownloadTask * _Nonnull task;

- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DbxDelegate * _Nonnull)delegate route:(DbxRoute * _Nonnull)route;

- (DbxDownloadDataTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DbxError * _Nullable, NSData * _Nonnull))responseBlock;

- (DbxDownloadDataTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

- (void)cancel;

- (void)suspend;

- (void)resume;

@end
