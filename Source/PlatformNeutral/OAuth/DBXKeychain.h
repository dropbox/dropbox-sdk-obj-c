///
/// Class for storing OAuth tokens.
///

#import <Foundation/Foundation.h>

@interface DBXKeychain : NSObject

+ (BOOL)set:(NSString *)key value:(NSString *)value;

+ (NSString *)get:(NSString *)key;

+ (NSArray<NSString *> *)getAll;

+ (BOOL)delete:(NSString *)key;

+ (BOOL)clear;

@end
