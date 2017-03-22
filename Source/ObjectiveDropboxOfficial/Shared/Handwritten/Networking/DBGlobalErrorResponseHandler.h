///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import <Foundation/Foundation.h>

@class DBRequestError;

NS_ASSUME_NONNULL_BEGIN

///
/// Allows for consistent, global handling of route-specific error types, as well as general network errors.
///
/// Normally, error handling is done on a request-by-request basis, in the supplied response handler. However, it is
/// convenient to handle some error behavior consistently, regardless of the request or the endpoint. An example of this
/// might be implementing retry logic for all rate-limiting errors, regardless of their source. For implementing global
/// error handling for general networking errors like rate-limiting, one of the `registerNetworkErrorResponseBlock:`
/// methods should be used. For implementing global error handling for route-specific errors, one of the
/// `registerRouteErrorResponseBlock:` methods should be used.
///
/// For the route-specific error handling, you may supply either the direct route error type, or any type that the route
/// error type contains as an instance field (or an instance field of an instance field, and so on).
///
/// @note These globally supplied response handlers will be executed *in addition* to the original request-specific
/// response handler. The global response handlers will be guaranteed to be executed first.
///
@interface DBGlobalErrorResponseHandler : NSObject

// Global response handler for route-specific errors.
typedef void (^DBRouteErrorResponseBlock)(id _Nullable routeError, DBRequestError *error);

// Global response handler for general network errors.
typedef void (^DBNetworkErrorResponseBlock)(DBRequestError *error);

///
/// Convenience method for registering a global error handler for a specific route error type.
///
/// @param routeErrorResponseBlock The response block for globally handling the route error.
/// @param routeErrorType The error type with which to associate the supplied response block. Note, this method searches
/// the route error type's instance fields recursively, so this error type may potentially match not only the route
/// error type, but any of its instance fields, and its instance fields' instance fields, and so on.
///
+ (void)registerRouteErrorResponseBlock:(DBRouteErrorResponseBlock)routeErrorResponseBlock
                         routeErrorType:(Class _Nonnull)routeErrorType;

///
/// Registers a global error handler for a specific route error type.
///
/// @param routeErrorResponseBlock The response block for globally handling the route error.
/// @param routeErrorType The error type with which to associate the supplied response block. Note, this method searches
/// the route error type's instance fields recursively, so this error type may potentially match not only the route
/// error type, but any of its instance fields, and its instance fields' instance fields, and so on.
/// @param queue The operation queue on which to execute the supplied global response handler.
///
+ (void)registerRouteErrorResponseBlock:(DBRouteErrorResponseBlock)routeErrorResponseBlock
                         routeErrorType:(Class _Nonnull)routeErrorType
                                  queue:(NSOperationQueue * _Nullable)queue;

///
/// Removes the global error handler associated with the supplied error type.
///
/// routeErrorType The associated error type of the response handler to be removed.
///
+ (void)removeRouteErrorResponseBlockWithRouteErrorType:(Class _Nonnull)routeErrorType;

///
/// Convenience method for registering a single global error handler for handling general network errors.
///
/// @note Only one block at a time may be set for handling all general network errors.
///
/// @param networkErrorResponseBlock The response block for globally handling network errors.
///
+ (void)registerNetworkErrorResponseBlock:(DBNetworkErrorResponseBlock)networkErrorResponseBlock;

///
/// Registers a single global error handler for handling general network errors.
///
/// @note Only one block at a time may be set for handling all general network errors.
///
/// @param networkErrorResponseBlock The response block for globally handling network errors.
/// @param queue The operation queue on which to execute the supplied global response handler.
///
+ (void)registerNetworkErrorResponseBlock:(DBNetworkErrorResponseBlock)networkErrorResponseBlock
                                    queue:(NSOperationQueue * _Nullable)queue;

///
/// Removes the single global error handler for general network errors.
///
+ (void)removeNetworkErrorResponseBlock;

@end

NS_ASSUME_NONNULL_END
