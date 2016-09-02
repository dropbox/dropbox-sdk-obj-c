///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

@class DBRpcData;
@class DBUploadData;
@class DBDownloadData;

///
/// Delegate class used to manage the execution of handler code for
/// RPC, Upload and Download style requests.
///
/// By default, this delegate is instantiated in the constructor of the
/// DBTransportClient class, and uses the main delegate queue, so all handler
/// code will be executed serially and on the main thread.
///
@interface DBDelegate : NSObject <NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

#pragma mark - Constructors

///
/// DBDelegate full constructor.
///
/// @param delegateQueue The queue used to execute handler code. By defaut, this
/// is the main queue, so all handler code will be executed on the main thread.
///
/// @return An initialized DBDelegate instance.
///
- (nonnull instancetype)initWithQueue:(NSOperationQueue * _Nonnull)delegateQueue;

#pragma mark - Add RPC-style handlers

///
/// Enqueues a handler to be executed upon completion of the supplied NSURLSessionTask
/// task for the corresponding RPC-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param responseHandler The handler block to be executed in the event of a successful or
/// unsuccessful network request.
///
- (void)addRpcResponseHandler:(NSURLSessionTask * _Nonnull)task
                      session:(NSURLSession * _Nonnull)session
              responseHandler:
                  (void (^_Nonnull)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

///
/// Enqueues a handler to be executed periodically to retrieve information on the progress of
/// the supplied NSURLSessionTask task for the corresponding RPC-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes sent. The second argument is the number of total
/// bytes sent. And the third argument is the number of total bytes expected to be sent.
///
- (void)addRpcProgressHandler:(NSURLSessionTask * _Nonnull)task
                      session:(NSURLSession * _Nonnull)session
              progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

#pragma mark - Add Upload-style handlers

///
/// Enqueues a handler to be executed upon completion of the supplied NSURLSessionTask
/// task for the corresponding Upload-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param responseHandler The handler block to be executed in the event of a successful or
/// unsuccessful network request.
///
- (void)addUploadResponseHandler:(NSURLSessionTask * _Nonnull)task
                         session:(NSURLSession * _Nonnull)session
                 responseHandler:
                     (void (^_Nonnull)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

///
/// Enqueues a handler to be executed periodically to retrieve information on the progress of
/// the supplied NSURLSessionTask task for the corresponding Upload-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes uploaded. The second argument is the number of total
/// bytes uploaded. And the third argument is the number of total bytes expected to be uploaded.
///
- (void)addUploadProgressHandler:(NSURLSessionTask * _Nonnull)task
                         session:(NSURLSession * _Nonnull)session
                 progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

#pragma mark - Add Download-style handlers

///
/// Enqueues a handler to be executed upon completion of the supplied NSURLSessionTask
/// task for the corresponding Download-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param responseHandler The handler block to be executed in the event of a successful or
/// unsuccessful network request.
///
- (void)addDownloadResponseHandler:(NSURLSessionTask * _Nonnull)task
                           session:(NSURLSession * _Nonnull)session
                   responseHandler:
                       (void (^_Nonnull)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))handler;

///
/// Enqueues a handler to be executed periodically to retrieve information on the progress of
/// the supplied NSURLSessionTask task for the corresponding Upload-style request.
///
/// @param task The NSURLSessionTask task associated with the API request.
/// @param session The NSURLSession session associated with the API request.
/// @param progress The progress block to be executed in the event of a request update.
/// The first argument is the number of bytes downloaded. The second argument is the number of total
/// bytes downloaded. And the third argument is the number of total bytes expected to be downloaded.
///
- (void)addDownloadProgressHandler:(NSURLSessionTask * _Nonnull)task
                           session:(NSURLSession * _Nonnull)session
                   progressHandler:(void (^_Nonnull)(int64_t, int64_t, int64_t))handler;

@end
