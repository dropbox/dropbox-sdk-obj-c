///
/// Class for storing OAuth tokens.
///

#import <Foundation/Foundation.h>

@interface DbxKeychain : NSObject

+ (BOOL)setWithString:(NSString *)key value:(NSString *)value;

+ (BOOL)setWithData:(NSString *)key value:(NSData *)value;

+ (NSData *)getAsData:(NSString *)key;

+ (NSArray<NSString *> *)getAll;

+ (NSString *)get:(NSString *)key;

+ (BOOL)delete:(NSString *)key;

+ (BOOL)clear;

@end
