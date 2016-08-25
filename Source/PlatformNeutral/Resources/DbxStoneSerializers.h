///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>

@protocol DbxSerializable <NSObject>

@required
+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;
+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;
- (NSString * _Nonnull)description;

@end


// This is to avoid compiler warnings for Array route arguments
@interface NSArray (DbxSerializable) <DbxSerializable>

+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end


@interface DbxNSDateSerializer : NSObject

+ (NSString * _Nonnull)serialize:(NSDate * _Nonnull)value dateFormat:(NSString * _Nonnull)dateFormat;

+ (NSDate * _Nonnull)deserialize:(NSString * _Nonnull)value dateFormat:(NSString * _Nonnull)dateFormat;

@end


@interface DbxArraySerializer : NSObject

+ (NSArray * _Nonnull)serialize:(NSArray * _Nonnull)value withBlock:(id _Nonnull (^_Nonnull)(id _Nonnull))serializeBlock;

+ (NSArray * _Nonnull)deserialize:(NSArray * _Nonnull)jsonData withBlock:(id _Nonnull (^_Nonnull)(id _Nonnull))deserializeBlock;

@end
