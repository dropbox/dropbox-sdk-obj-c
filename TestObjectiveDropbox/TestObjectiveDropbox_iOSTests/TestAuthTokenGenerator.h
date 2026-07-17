@class DBAccessToken;

@interface TestAuthTokenGenerator : NSObject
+ (nonnull NSString *)credentialForKey:(nonnull NSString *)key;

+ (nullable DBAccessToken *)refreshToken:(nullable NSString *)refreshToken
                                  apiKey:(nullable NSString *)apiKey
                               apiSecret:(nullable NSString *)apiSecret
                                  scopes:(nonnull NSArray<NSString *> *)scopes;
@end
