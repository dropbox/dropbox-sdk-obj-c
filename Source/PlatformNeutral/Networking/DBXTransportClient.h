///
/// The networking client for the User and Business API.
///

#import <Foundation/Foundation.h>
#import "DBXSerializableProtocol.h"

@class DBXDownloadDataTask;
@class DBXDownloadURLTask;
@class DBXError;
@class DBXRoute;
@class DBXRpcTask;
@class DBXUploadTask;
@protocol DBXSerializable;

@interface DBXTransportClient : NSObject

@property (nonatomic, nonnull) NSString *accessToken;

@property (nonatomic, nonnull) NSString *selectUser;

@property (nonatomic, nonnull) NSDictionary <NSString *, NSString *> *baseHosts;

@property (nonatomic, nonnull) NSString *userAgent;

@property (nonatomic, nonnull) NSOperationQueue *delegateQueue;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andSelectUser:(NSString * _Nullable)selectUser;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andBackgroundSessionId:(NSString * _Nullable)backgroundSessionIdentifier;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andSelectUser:(NSString * _Nullable)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> * _Nullable)baseHosts;

- (nonnull instancetype)initWithAccessToken:(NSString * _Nonnull)accessToken andSelectUser:(NSString * _Nullable)selectUser andBaseHosts:(NSDictionary <NSString *, NSString *> * _Nullable)baseHosts andUserAgent:(NSString * _Nullable)userAgent andBackgroundSessionId:(NSString * _Nullable)backgroundSessionId;

- (DBXRpcTask * _Nonnull)requestRpc:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg;

- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputURL:(NSURL * _Nonnull)input;

- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputData:(NSData * _Nonnull)input;

- (DBXUploadTask * _Nonnull)requestUpload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg inputStream:(NSInputStream * _Nonnull)input;

- (DBXDownloadURLTask * _Nonnull)requestDownload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

- (DBXDownloadDataTask * _Nonnull)requestDownload:(DBXRoute * _Nonnull)route arg:(id<DBXSerializable> _Nullable)arg;

@end
