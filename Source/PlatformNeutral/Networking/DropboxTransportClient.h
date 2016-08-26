///
/// The networking client for the User and Business API.
///

#import <Foundation/Foundation.h>
#import "DbxSerializable.h"

@class DbxError;
@class DbxRoute;
@class DbxDownloadDataTask;
@class DbxDownloadURLTask;
@class DbxRpcTask;
@class DbxUploadTask;

@interface DropboxTransportClient : NSObject

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

- (DbxRpcTask * _Nonnull)requestRpc:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg;

- (DbxUploadTask * _Nonnull)requestUpload:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg inputURL:(NSURL * _Nonnull)input;

- (DbxUploadTask * _Nonnull)requestUpload:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg inputData:(NSData * _Nonnull)input;

- (DbxUploadTask * _Nonnull)requestUpload:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg inputStream:(NSInputStream * _Nonnull)input;

- (DbxDownloadURLTask * _Nonnull)requestDownload:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg overwrite:(BOOL)overwrite destination:(NSURL * _Nonnull)destination;

- (DbxDownloadDataTask * _Nonnull)requestDownload:(DbxRoute * _Nonnull)route arg:(id<DbxSerializable> _Nullable)arg;

@end
