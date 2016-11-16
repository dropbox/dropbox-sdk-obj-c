///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

#import "DBSerializableProtocol.h"

@class DBDelegate;
@class DBDownloadDataTask;
@class DBDownloadUrlTask;
@class DBError;
@class DBRoute;
@class DBRpcTask;
@class DBUploadTask;
@protocol DBSerializable;

///
/// The networking client for the User and Business API.
///
/// Normally, one networking client should instantiated per access token and session /
/// background session pair. By default, all Upload-style and Download-style requests are
/// made via a background session (except when uploading via `NSInputStream` or `NSData`,
/// or downloading to `NSData`, in which case, it is not possible) and all RPC-style request
/// are made using a foreground session.
///
/// Requests are made via one of the request methods below. The request is launched,
/// and a `DBTask` object is returned, from which response and progress handlers
/// can be added directly. By default, these handlers are added / executed using the main thread
/// queue and executed in a thread-safe manner (unless a custom delegate queue is supplied via
/// the `DBTransportClient` constructor). The `DBDelegate` class then retrieves the appropriate
/// handler and executes it.
///
/// While response handlers are not optional, they do not necessarily need to have been installed
/// by the time the SDK has received its server response. If this is the case, completion data will
/// be saved, and the handler will be executed with the completion data upon its installation.
/// Downloaded content will be moved from a temporary location to the final destination when the
/// response handler code is executed.
///
/// Argument serialization is performed with this class.
///
@interface DBTransportClient : NSObject

/// The delegate used to manage execution of all response / error code. By default, this
/// is an instance of `DBDelegate` with the main thread queue as delegate queue.
@property (nonatomic, readonly) DBDelegate * _Nonnull delegate;

/// A serial delegate queue used for executing blocks of code that touch state
/// shared across threads (mainly the request handlers storage).
@property (nonatomic, readonly) NSOperationQueue * _Nonnull delegateQueue;

/// The foreground session used to make all foreground requests (RPC style requests, upload
/// from `NSData` and `NSInputStream`, and download to `NSData`).
@property (nonatomic) NSURLSession * _Nonnull session;

/// The background session used to make all background requests (Upload and Download style
/// requests, except for upload from `NSData` and `NSInputStream`, and download to `NSData`).
@property (nonatomic) NSURLSession * _Nonnull backgroundSession;

/// The Dropbox OAuth2 access token used to make requests.
@property (nonatomic, copy) NSString * _Nonnull accessToken;

/// An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of
/// a team member.
@property (nonatomic, readonly, copy) NSString * _Nullable selectUser;

#pragma mark - Constructors

///
/// `DBTransportClient` convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
///
/// @return An initialized `DBTransportClient` instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

///
/// `DBTransportClient` convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
/// @param selectUser An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
///
/// @return An initialized `DBTransportClient` instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nullable)accessToken selectUser:(NSString * _Nullable)selectUser;

///
/// `DBTransportClient` convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
/// @param backgroundSessionId The background session identifier used to make
/// background request calls. If no identifier is supplied, a default, timestamp-based
/// identifier is used.
///
/// @return An initialized `DBTransportClient` instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nullable)accessToken
                        backgroundSessionId:(NSString * _Nullable)backgroundSessionId;

///
/// `DBTransportClient` convenience constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
/// @param selectUser An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
/// @param baseHosts A mapping of route "style" (e.g. "upload", "download", "rpc" – as defined
/// in the route's Stone spec) to the appropriate server host.
///
/// @return An initialized `DBTransportClient` instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nullable)accessToken
                                 selectUser:(NSString * _Nullable)selectUser
                                  baseHosts:(NSDictionary<NSString *, NSString *> * _Nullable)baseHosts;

///
/// `DBTransportClient` full constructor.
///
/// @param accessToken The Dropbox OAuth2 access token used to make requests.
/// @param selectUser An additional authentication header field used when a team app with
/// the appropriate permissions "performs" user actions on behalf of a team member.
/// @param baseHosts A mapping of route "style" (e.g. "upload", "download", "rpc" – as defined
/// in the route's Stone spec) to the appropriate server host.
/// @param userAgent The user agent included in all requests. A general, non-unique identifier
/// useful for server analytics.
/// @param backgroundSessionId The background session identifier used to make background request
/// calls. If no identifier is supplied, a default, timestamp-based identifier is used.
/// @param delegateQueue The queue used by `DBDelegate` for safely executing response code. If
/// nil, then `DBTransportClient` defaults to using the main queue. This must be a serial queue.
///
/// @return An initialized `DBTransportClient` instance.
///
- (nonnull instancetype)initWithAccessToken:(NSString * _Nullable)accessToken
                                 selectUser:(NSString * _Nullable)selectUser
                                  baseHosts:(NSDictionary<NSString *, NSString *> * _Nullable)baseHosts
                                  userAgent:(NSString * _Nullable)userAgent
                        backgroundSessionId:(NSString * _Nullable)backgroundSessionId
                              delegateQueue:(NSOperationQueue * _Nullable)delegateQueue;

#pragma mark - RPC-style request

///
/// Request to RPC-style endpoint.
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol.
///
/// @return A `DBRpcTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBRpcTask * _Nonnull)requestRpc:(DBRoute * _Nonnull)route arg:(id<DBSerializable> _Nullable)arg;

#pragma mark - Upload-style request (NSURL)

///
/// Request to Upload-style endpoint (via `NSURL`).
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol.
/// @param input The location of the file to upload. NSURLSession supports background uploads
/// for this input type, so by default, all requests of this type will be made in the background.
///
/// @return A `DBUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBUploadTask * _Nonnull)requestUpload:(DBRoute * _Nonnull)route
                                    arg:(id<DBSerializable> _Nullable)arg
                               inputUrl:(NSURL * _Nonnull)input;

#pragma mark - Upload-style request (NSData)

///
/// Request to Upload-style endpoint (via `NSData`).
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol.
/// @param input The location of the file to upload. NSURLSession does not support background
/// uploads for this input type, so by default, all requests of this type will be made in the foreground.
///
/// @return A `DBUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBUploadTask * _Nonnull)requestUpload:(DBRoute * _Nonnull)route
                                    arg:(id<DBSerializable> _Nullable)arg
                              inputData:(NSData * _Nonnull)input;

#pragma mark - Upload-style request (NSInputStream)

///
/// Request to Upload-style endpoint (via `NSInputStream`).
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol.
/// @param input The location of the file to upload. `NSURLSession` does not support background
/// uploads for this input type, so by default, all requests of this type will be made in the foreground.
///
/// @return A `DBUploadTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBUploadTask * _Nonnull)requestUpload:(DBRoute * _Nonnull)route
                                    arg:(id<DBSerializable> _Nullable)arg
                            inputStream:(NSInputStream * _Nonnull)input;

#pragma mark - Download-style request (NSURL)

///
/// Request to Download-style endpoint (via `NSURL` output type).
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol.
/// @param overwrite Whether the outputted file should overwrite in the event of a name collision.
/// @param destination Location to which output content should be downloaded.
///
/// @return A `DBDownloadUrlTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled.
///
- (DBDownloadUrlTask * _Nonnull)requestDownload:(DBRoute * _Nonnull)route
                                           arg:(id<DBSerializable> _Nullable)arg
                                     overwrite:(BOOL)overwrite
                                   destination:(NSURL * _Nonnull)destination;

#pragma mark - Download-style request (NSData)

///
/// Request to Download-style endpoint (with `NSData` output type).
///
/// @param route The static `DBRoute` instance associated with the route. Contains information
/// like route host, response type, etc.
/// @param arg The unserialized route argument to pass. Must conform to the `DBSerializable`
/// protocol. Note, this return type is different from the return type of `requestDownload:arg`.
///
/// @return A `DBDownloadDataTask` where response and progress handlers can be added, and the request can
/// be halted or cancelled. Note, this return type is different from the return type of
/// `requestDownload:arg:overwrite:destination`.
///
- (DBDownloadDataTask * _Nonnull)requestDownload:(DBRoute * _Nonnull)route arg:(id<DBSerializable> _Nullable)arg;

@end
