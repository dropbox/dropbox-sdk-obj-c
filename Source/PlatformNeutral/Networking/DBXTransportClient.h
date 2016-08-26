#import <Foundation/Foundation.h>
#import "DBXSerializableProtocol.h"

@class DBXDownloadDataTask;
@class DBXDownloadURLTask;
@class DBXError;
@class DBXRoute;
@class DBXRpcTask;
@class DBXUploadTask;
@protocol DBXSerializable;

///
/// The networking client for the User and Business API.
///
/// Normally, one networking client should instantiated per access token and session /
/// background session pair. By default, all upload and download requests are made via a
/// background session (except when uploading via `NSInputStream` or `NSData`,
/// in which case, it is not possible) and all rpc requests are made on using
/// a foreground session.
///
/// Requests are made via one of the request methods below. The request is launched,
/// and a `DBXTask` object is returned, from which response and progress handlers
/// can be added directly. These handlers are added via a serial delegate queue and
/// executed in a thread-safe manner. The `DBXDelegate` class retrieves the appropriate
/// handler and executes it.
///
/// Argument serialization is performed with this class.
///
@interface DBXTransportClient : NSObject

/// The Dropbox OAuth2 access token used to make requests.
@property (nonatomic) NSString * _Nonnull accessToken;

/// An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of
/// a team member.
@property (nonatomic) NSString * _Nullable selectUser;

/// A mapping of route "style" (e.g. "upload", "download", "rpc" – as defined in the
/// route's Stone spec) to the appropriate server host.
@property (nonatomic) NSDictionary <NSString *, NSString *> * _Nonnull baseHosts;

/// The user agent included in all requests. A general, non-unique identifier useful
/// for server analytics.
@property (nonatomic) NSString * _Nonnull userAgent;

/// A serial delegate queue used for executing blocks of code that touch state
/// shared across threads (mainly the request handlers storage).
@property (nonatomic) NSOperationQueue * _Nonnull delegateQueue;

///
/// `DBXTransportClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// `DBXTransportClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
/// - parameter selectUser: An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken selectUser:(NSString * _Nullable)selectUser;

///
/// `DBXTransportClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
/// - parameter backgroundSessionId: The background session identifier used to make
/// background request calls. If no identifier is supplied, a default, timestamp-based
/// identifier is used.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken backgroundSessionId:(NSString * _Nullable)backgroundSessionId;

///
/// `DBXTransportClient` convenience constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
/// - parameter selectUser: An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
/// - parameter baseHosts: A mapping of route "style" (e.g. "upload", "download", "rpc" – as defined
/// in the route's Stone spec) to the appropriate server host.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken selectUser:(NSString * _Nullable)selectUser baseHosts:(NSDictionary <NSString *, NSString *> * _Nullable)baseHosts;

///
/// `DBXTransportClient` full constructor.
///
/// - parameter accessToken: The Dropbox OAuth2 access token used to make requests.
/// - parameter selectUser: An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
/// - parameter baseHosts: A mapping of route "style" (e.g. "upload", "download", "rpc" – as defined
/// in the route's Stone spec) to the appropriate server host.
/// - parameter userAgent: The user agent included in all requests. A general, non-unique identifier
/// useful for server analytics.
/// - parameter backgroundSessionId: The background session identifier used to make background request
/// calls. If no identifier is supplied, a default, timestamp-based identifier is used.
///
/// - returns: An initialized instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken selectUser:(NSString * _Nullable)selectUser baseHosts:(NSDictionary <NSString *, NSString *> * _Nullable)baseHosts userAgent:(NSString * _Nullable)userAgent backgroundSessionId:(NSString * _Nullable)backgroundSessionId;

///
/// Request to RPC-style endpoint.
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol.
///
/// - returns: A `DBXRpcTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBXRpcTask * _Nonnull)requestRpc:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg;

///
/// Request to Upload-style endpoint (via `NSURL`).
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol.
/// - parameter inputURL: The location of the file to upload. `NSURLSession` supports background uploads
/// for this input type, so by default, all requests of this type will be made in the background.
///
/// - returns: A `DBXUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputURL:(NSURL * _Nonnull)input;

///
/// Request to Upload-style endpoint (via `NSData`).
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol.
/// - parameter inputURL: The location of the file to upload. `NSURLSession` does not support background
/// uploads for this input type, so by default, all requests of this type will be made in the foreground.
///
/// - returns: A `DBXUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputData:(NSData * _Nonnull)input;

///
/// Request to Upload-style endpoint (via `NSInputStream`).
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol.
/// - parameter inputURL: The location of the file to upload. `NSURLSession` does not support background
/// uploads for this input type, so by default, all requests of this type will be made in the foreground.
///
/// - returns: A `DBXUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputStream:(NSInputStream * _Nonnull)input;

///
/// Request to Download-style endpoint (via `NSURL` output type).
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol.
/// - parameter overwrite: Whether the outputted file should overwrite in the event of a name collision.
/// - parameter destination: Location to which output content should be downloaded.
///
/// - returns: A `DBXDownloadURLTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBXDownloadURLTask * _Nonnull)requestDownload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

///
/// Request to Download-style endpoint (with `NSData` output type).
///
/// - parameter route: The static `DBXRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// - parameter arg: The unserialized route argument to pass. Must conform to the `DBXSerializable`
/// protocol. Note, this return type is different from the return type of `requestDownload:arg`.
///
/// - returns: A `DBXDownloadDataTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled. Note, this return type is different from the return type of
/// `requestDownload:arg:overwrite:destination`.
///
- (DBXDownloadDataTask * _Nonnull)requestDownload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg;

@end
