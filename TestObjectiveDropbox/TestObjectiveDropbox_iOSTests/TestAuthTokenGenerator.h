
@interface TestAuthTokenGenerator : NSObject
+ (nonnull NSString *)environmentVariableForKey:(NSString *)key;

+ (nullable NSString *)refreshToken:(nullable NSString *)refreshToken
                             apiKey:(nullable NSString *)apiKey
                             scopes:(nonnull NSArray<NSString *>*)scopes;
@end
