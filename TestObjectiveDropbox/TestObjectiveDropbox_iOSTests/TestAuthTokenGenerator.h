@interface TestAuthTokenGenerator : NSObject
+ (nullable NSString *)refreshToken:(nullable NSString *)refreshToken
                             apiKey:(nullable NSString *)apiKey
                             scopes:(nonnull NSArray<NSString *>*)scopes;
@end
