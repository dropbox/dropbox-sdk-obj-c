///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

/// These are internal handler block types used by the SDK. The client-facing handler blocks
/// look somewhat different.

/// Progress handler for every type of API call.
typedef void (^DBProgressBlock)(int64_t, int64_t, int64_t);

/// Response handler for RPC-style API call.
typedef void (^DBRpcResponseBlock)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

/// Response handler for Upload-style API call.
typedef void (^DBUploadResponseBlock)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);

/// Response handler for Download-style API call.
typedef void (^DBDownloadResponseBlock)(NSURL * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable);
