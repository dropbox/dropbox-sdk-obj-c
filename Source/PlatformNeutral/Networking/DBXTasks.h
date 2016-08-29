@class DBXDelegate;
@class DBXError;
@class DBXRoute;

///
/// Base class for network task wrappers.
///
/// After a network request is made via `DBXTransportClient`, a subclass
/// of `DBXTask` is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
@interface DBXTask : NSObject {
    @protected
    NSURLSession *_session;
    DBXDelegate *_delegate;
    DBXRoute *_route;
}

/// The session that was used to make to the request.
@property (nonatomic, readonly) NSURLSession * _Nonnull session;

/// The delegate used manage handler code.
@property (nonatomic, readonly) DBXDelegate * _Nonnull delegate;

/// Information about the route to which the request
/// was made.
@property (nonatomic, readonly) DBXRoute * _Nonnull route;

@end

///
/// Dropbox RPC Network Task.
///
/// After an RPC network request is made via `DBXTransportClient`, a subclass
/// of `DBXRpcTask` is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
/// `TResponse` is the generic representation of the route-specific result, and
/// `TError` is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBXRpcTask<TResponse, TError> : DBXTask

/// The `NSURLSessionTask` that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDataTask * _Nonnull task;

///
/// `DBXRpcTask` full constructor.
///
/// - parameter task: The `NSURLSessionDataTask` task that initialized the network request.
/// - parameter session: The `NSURLSession` used to make the network request.
/// - parameter delegate: The delegate that manages and executes response code.
/// - parameter backgroundSessionId: The background session identifier used to make background request
/// - parameter route: The static `DBXRoute` instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDataTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// - parameter response: The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.).
///
/// - returns: The current `DBXRpcTask` instance.
///
- (DBXRpcTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// - parameter progress: The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes sent. The second argument is the number of total
/// bytes sent. And the third argument is the number of total bytes expected to be sent.
///
/// - returns: The current `DBXRpcTask` instance.
///
- (DBXRpcTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

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

///
/// Dropbox Upload Network Task.
///
/// After an Upload network request is made via `DBXTransportClient`, a subclass
/// of `DBXUploadTask` is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled.
///
/// `TResponse` is the generic representation of the route-specific result, and
/// `TError` is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBXUploadTask<TResponse, TError> : DBXTask

/// The `NSURLSessionTask` that was used to make the request.
@property (nonatomic, readonly) NSURLSessionUploadTask * _Nonnull task;

///
/// `DBXUploadTask` full constructor.
///
/// - parameter task: The `NSURLSessionDataTask` task that initialized the network request.
/// - parameter session: The `NSURLSession` used to make the network request.
/// - parameter delegate: The delegate that manages and executes response code.
/// - parameter backgroundSessionId: The background session identifier used to make background request
/// - parameter route: The static `DBXRoute` instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionUploadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// - parameter response: The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.).
///
/// - returns: The current `DBXUploadTask` instance.
///
- (DBXUploadTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// - parameter progress: The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes uploaded. The second argument is the number of total
/// bytes uploaded. And the third argument is the number of total bytes expected to be uploaded.
///
/// - returns: The current `DBXUploadTask` instance.
///
- (DBXUploadTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

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

///
/// Dropbox Download Network Task (download to `NSURL`).
///
/// After an Upload network request is made via `DBXTransportClient`, a subclass
/// of `DBXDownloadURLTask` is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled. Note, this class
/// is returned only for download requests with an `NSURL` output.
///
/// `TResponse` is the generic representation of the route-specific result, and
/// `TError` is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBXDownloadURLTask<TResponse, TError> : DBXTask

/// The `NSURLSessionTask` that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDownloadTask * _Nonnull task;

/// Whether the outputted file should overwrite in the event of a name collision.
@property (nonatomic, readonly) BOOL overwrite;

/// Location to which output content should be downloaded.
@property (nonatomic, readonly, copy) NSURL * _Nonnull destination;

///
/// `DBXDownloadURLTask` full constructor.
///
/// - parameter task: The `NSURLSessionDataTask` task that initialized the network request.
/// - parameter session: The `NSURLSession` used to make the network request.
/// - parameter delegate: The delegate that manages and executes response code.
/// - parameter backgroundSessionId: The background session identifier used to make background request
/// - parameter route: The static `DBXRoute` instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
/// - parameter overwrite: Whether the outputted file should overwrite in the event of a name collision.
/// - parameter destination: Location to which output content should be downloaded.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

///
/// Installs a response handler for the current request.
///
/// - parameter response: The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.). The fourth
/// argument is the output destination to which the file was downloaded.
///
/// - returns: The current `DBXDownloadURLTask` instance.
///
- (DBXDownloadURLTask<TResponse, TError> * _Nonnull)response:(void (^_Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable, NSURL * _Nonnull))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// - parameter progress: The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes downloaded. The second argument is the number of total
/// bytes downloaded. And the third argument is the number of total bytes expected to be downloaded.
///
/// - returns: The current `DBXDownloadURLTask` instance.
///
- (DBXDownloadURLTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

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

///
/// Dropbox Download Network Task (download to `NSData`).
///
/// After an Upload network request is made via `DBXTransportClient`, a subclass
/// of `DBXDownloadDataTask` is returned, from which response and progress handlers
/// can be installed, and the network response paused or cancelled. Note, this class
/// is returned only for download requests with an `NSData` output.
///
/// `TResponse` is the generic representation of the route-specific result, and
/// `TError` is the generic representation of the route-specific error.
///
/// Response / error deserialization is performed with this class.
///
/// For client-side handling of failed requests / application crashes, use this class
/// to reinstall response / progress handlers for the restarted tasks.
///
@interface DBXDownloadDataTask<TResponse, TError> : DBXTask

/// The `NSURLSessionTask` that was used to make the request.
@property (nonatomic, readonly) NSURLSessionDownloadTask * _Nonnull task;

///
/// `DBXDownloadDataTask` full constructor.
///
/// - parameter task: The `NSURLSessionDataTask` task that initialized the network request.
/// - parameter session: The `NSURLSession` used to make the network request.
/// - parameter delegate: The delegate that manages and executes response code.
/// - parameter backgroundSessionId: The background session identifier used to make background request
/// - parameter route: The static `DBXRoute` instance associated with the route to which the request
/// was made. Contains information like route host, response type, etc.). This is used in the deserialization
/// process.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithTask:(NSURLSessionDownloadTask * _Nonnull)task session:(NSURLSession * _Nonnull)session delegate:(DBXDelegate * _Nonnull)delegate route:(DBXRoute * _Nonnull)route;

///
/// Installs a response handler for the current request.
///
/// - parameter response: The handler block to be executed in the event of a successful or
/// unsuccessful network request. The first argument is the route-specific result. The second
/// argument is the route-specific error. And the third argument is the more general network
/// error (which includes information like Dropbox request ID, http status code, etc.). The fourth
/// argument is the output `NSData` object in memory, to which the file was downloaded.
///
/// - returns: The current `DBXDownloadURLTask` instance.
///
- (DBXDownloadDataTask<TResponse, TError> * _Nonnull)response:(void (^ _Nonnull)(TResponse _Nullable, TError _Nullable, DBXError * _Nullable, NSData * _Nonnull))responseBlock;

///
/// Installs a progress handler for the current request.
///
/// - parameter progress: The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes downloaded. The second argument is the number of total
/// bytes downloaded. And the third argument is the number of total bytes expected to be downloaded.
///
/// - returns: The current `DBXDownloadDataTask` instance.
///
- (DBXDownloadDataTask * _Nonnull)progress:(void (^_Nullable)(int64_t, int64_t, int64_t))progressBlock;

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
