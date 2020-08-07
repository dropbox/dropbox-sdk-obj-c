///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBHandlerTypes.h"
#import "DBHandlerTypesInternal.h"
#import "DBTasks.h"
#import <Foundation/Foundation.h>

@protocol DBAccessTokenProvider;

NS_ASSUME_NONNULL_BEGIN

/// Response handler for DBURLSessionTask.
@interface DBURLSessionTaskResponseBlockWrapper : NSObject

/// Handler wrapper for RPC tasks.
+ (DBURLSessionTaskResponseBlockWrapper *)withRpcResponseBlock:(DBRpcResponseBlockStorage)responseBlock;
/// Handler wrapper for upload tasks.
+ (DBURLSessionTaskResponseBlockWrapper *)withUploadResponseBlock:(DBUploadResponseBlockStorage)responseBlock;
/// Handler wrapper for download tasks.
+ (DBURLSessionTaskResponseBlockWrapper *)withDownloadResponseBlock:(DBDownloadResponseBlockStorage)responseBlock;

@end

/// Protocol for custom URLSession tasks that are used internally by the DBTask classes.
@protocol DBURLSessionTask <NSObject>

typedef void (^DBURLSessionTaskSetupBlock)(NSUInteger taskIdentifier);

/// The `NSURLSession` used to make the network request.
@property (nonatomic, readonly) NSURLSession *session;

/// Creates a new instance with same initial setup.
- (id<DBURLSessionTask>)duplicate;

/// Cancels the API request.
- (void)cancel;

/// Suspends the API request.
- (void)suspend;

/// Resumes the API request.
- (void)resume;

/// Sets progress handler for the task.
/// @param progressBlock The `DBProgressBlock` that handles task progress.
/// @param queue An optional operation queue on which to execute progress handler code. If not provided, the handler
/// may be executed on any queue.
- (void)setProgressBlock:(DBProgressBlock)progressBlock queue:(nullable NSOperationQueue *)queue;

/// Sets response/completion handler for the task.
/// @param responseBlock The `DBURLSessionTaskResponseBlock` that handles task response.
/// @param queue An optional operation queue on which to execute response handler code. If not provided, the handler
/// may be executed on any queue.
- (void)setResponseBlock:(DBURLSessionTaskResponseBlockWrapper *)responseBlock queue:(nullable NSOperationQueue *)queue;

@end

/// Block that creates the actual API request.
typedef NSURLSessionTask *_Nonnull (^DBURLSessionTaskCreationBlock)(void);

/// A class that wraps a network request that calls Dropbox API.
/// This class will first attempt to refresh the access token and conditionally proceed to the actual API call.
@interface DBURLSessionTaskWithTokenRefresh : NSObject <DBURLSessionTask>

- (instancetype)init NS_UNAVAILABLE;

/// Designated Initializer.
///
/// @param taskCreationBlock The block that creates the actual API request.
/// @param taskDelegate The delegate used manage request handler code.
/// @param urlSession The `NSURLSession` used to make the API network request.
/// @param tokenProvider The `DBAccessTokenProvider` object to perform token refresh.
///
- (instancetype)initWithTaskCreationBlock:(DBURLSessionTaskCreationBlock)taskCreationBlock
                             taskDelegate:(nullable DBDelegate *)taskDelegate
                               urlSession:(NSURLSession *)urlSession
                            tokenProvider:(id<DBAccessTokenProvider>)tokenProvider NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
