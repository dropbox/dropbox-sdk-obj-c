///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

@class DBDelegate;
@class DBError;
@class DBRoute;

#pragma mark - Base network task

///
/// Base class for network task wrappers.
///
/// After a network request is made via DBTransportClient, a subclass
/// of DBTask is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
@interface DBTask : NSObject {
    @protected
    NSURLSession *_session;
    DBDelegate *_delegate;
    DBRoute *_route;
}

/// The session that was used to make to the request.
@property (nonatomic, readonly) NSURLSession * _Nonnull session;

/// The delegate used manage handler code.
@property (nonatomic, readonly) DBDelegate * _Nonnull delegate;

/// Information about the route to which the request
/// was made.
@property (nonatomic, readonly) DBRoute * _Nonnull route;

@end


#pragma mark - RPC-style network task

///
/// Dropbox RPC-style Network Task.
///
/// After an RPC network request is made via DBTransportClient, a subclass
/// of DBRpcTask is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
/// TResponse is the generic representation of the route-specific result, and
/// TError is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBRpcTask<TResponse, TError> : DBTask

/// The NSURLSessionTask that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDataTask * _Nonnull task;

///
/// DBRpcTask full constructor.
///
/// @param task The NSURLSessionDataTask task that initialized the network request.
/// @param session The NSURLSession used to make the network request.
/// @param delegate The delegate that manages and executes response code.
/// @param backgroundSessionId The background session identifier used to make background request
/// @param route The static DBRoute instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDataTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBDelegate * _Nonnull)delegate route:(DBRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// @param response The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.).
///
/// @return The current DBRpcTask instance.
///
- (DBRpcTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBError * _Nullable))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes sent. The second argument is the number of total
/// bytes sent. And the third argument is the number of total bytes expected to be sent.
///
/// @return The current DBRpcTask instance.
///
- (DBRpcTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

///
/// Cancels the current request.
///
- (void)cancel;

///
/// Suspends the current request.
///
- (void)suspend;

///
/// Resumes the current request.
///
- (void)resume;

@end


#pragma mark - Upload-style network task

///
/// Dropbox Upload-style Network Task.
///
/// After an Upload network request is made via DBTransportClient, a subclass
/// of DBUploadTask is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
/// TResponse is the generic representation of the route-specific result, and
/// TError is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBUploadTask<TResponse, TError> : DBTask

/// The NSURLSessionTask that was used to make the request.
@property (nonatomic, readonly) NSURLSessionUploadTask * _Nonnull task;

///
/// DBUploadTask full constructor.
///
/// @param task The NSURLSessionDataTask task that initialized the network request.
/// @param session The NSURLSession used to make the network request.
/// @param delegate The delegate that manages and executes response code.
/// @param backgroundSessionId The background session identifier used to make background request
/// @param route The static DBRoute instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionUploadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBDelegate * _Nonnull)delegate route:(DBRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// @param response The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.).
///
/// @return The current DBUploadTask instance.
///
- (DBUploadTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBError * _Nullable))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes uploaded. The second argument is the number of total
/// bytes uploaded. And the third argument is the number of total bytes expected to be uploaded.
///
/// @return The current DBUploadTask instance.
///
- (DBUploadTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

///
/// Cancels the current request.
///
- (void)cancel;

///
/// Suspends the current request.
///
- (void)suspend;

///
/// Resumes the current request.
///
- (void)resume;

@end


#pragma mark - Download-style network task (NSURL)

///
/// Dropbox Download-style Network Task (download to NSURL).
///
/// After an Upload network request is made via DBTransportClient, a subclass
/// of DBDownloadURLTask is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled. Note, this class
/// is returned only for download requests with an NSURL output.
///
/// TResponse is the generic representation of the route-specific result, and
/// TError is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBDownloadURLTask<TResponse, TError> : DBTask

/// The NSURLSessionTask that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDownloadTask * _Nonnull task;

/// Whether the outputted file should overwrite in the event of a name collision.
@property (nonatomic, readonly) BOOL overwrite;

/// Location to which output content should be downloaded.
@property (nonatomic, readonly, copy) NSURL * _Nonnull destination;

///
/// DBDownloadURLTask full constructor.
///
/// @param task The NSURLSessionDataTask task that initialized the network request.
/// @param session The NSURLSession used to make the network request.
/// @param delegate The delegate that manages and executes response code.
/// @param backgroundSessionId The background session identifier used to make background request
/// @param route The static DBRoute instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
/// @param overwrite Whether the outputted file should overwrite in the event of a name collision.
/// @param destination Location to which output content should be downloaded.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBDelegate * _Nonnull)delegate route:(DBRoute * _Nonnull)route overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

///
/// Installs a response handler for the current request.
///
/// @param response The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.). The fourth
/// argument is the output destination to which the file was downloaded.
///
/// @return The current DBDownloadURLTask instance.
///
- (DBDownloadURLTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBError * _Nullable, NSURL * _Nonnull))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes downloaded. The second argument is the number of total
/// bytes downloaded. And the third argument is the number of total bytes expected to be downloaded.
///
/// @return The current DBDownloadURLTask instance.
///
- (DBDownloadURLTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

///
/// Cancels the current request.
///
- (void)cancel;

///
/// Suspends the current request.
///
- (void)suspend;

///
/// Resumes the current request.
///
- (void)resume;

@end


#pragma mark - Download-style network task (NSData)

///
/// Dropbox Download Network Task (download to NSData).
///
/// After an Upload network request is made via DBTransportClient, a subclass
/// of DBDownloadDataTask is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled. Note, this class
/// is returned only for download requests with an NSData output.
///
/// TResponse is the generic representation of the route-specific result, and
/// TError is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBDownloadDataTask<TResponse, TError> : DBTask

/// The NSURLSessionTask that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDownloadTask * _Nonnull task;

///
/// DBDownloadDataTask full constructor.
///
/// @param task The NSURLSessionDataTask task that initialized the network request.
/// @param session The NSURLSession used to make the network request.
/// @param delegate The delegate that manages and executes response code.
/// @param backgroundSessionId The background session identifier used to make background request
/// @param route The static DBRoute instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// @return An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBDelegate * _Nonnull)delegate route:(DBRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// @param response The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.). The fourth
/// argument is the output NSData object in memory, to which the file was downloaded.
///
/// @return The current DBDownloadURLTask instance.
///
- (DBDownloadDataTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBError * _Nullable, NSData * _Nonnull))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes downloaded. The second argument is the number of total
/// bytes downloaded. And the third argument is the number of total bytes expected to be downloaded.
///
/// @return The current DBDownloadDataTask instance.
///
- (DBDownloadDataTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

///
/// Cancels the current request.
///
- (void)cancel;

///
/// Suspends the current request.
///
- (void)suspend;

///
/// Resumes the current request.
///
- (void)resume;

@end
