@class DBAccessToken;

@interface TestAuthTokenGenerator : NSObject
+ (nonnull NSString *)environmentVariableForKey:(nonnull NSString *)key;

+ (nullable DBAccessToken *)refreshToken:(nullable NSString *)refreshToken
                             apiKey:(nullable NSString *)apiKey
                             scopes:(nonnull NSArray<NSString *>*)scopes;
@end
