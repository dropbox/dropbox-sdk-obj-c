///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>

///
/// Validator functions used by SDK to impose value constraints.
///
@protocol DbxSerializable <NSObject>

+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

- (NSString * _Nonnull)description;

@end


@interface NSArray (DbxSerializable) <DbxSerializable>

+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

@end


@interface DbxStringSerializer : NSObject

+ (NSString * _Nonnull)serialize:(NSString * _Nonnull)value;

+ (NSString * _Nonnull)deserialize:(NSString * _Nonnull)value;

@end


@interface DbxNSNumberSerializer : NSObject

+ (NSNumber * _Nonnull)serialize:(NSNumber * _Nonnull)value;

+ (NSNumber * _Nonnull)deserialize:(NSNumber * _Nonnull)value;

@end


@interface DbxBoolSerializer : NSObject

+ (NSNumber * _Nonnull)serialize:(NSNumber * _Nonnull)value;

+ (NSNumber * _Nonnull)deserialize:(NSNumber * _Nonnull)value;

@end


@interface DbxNSDateSerializer : NSObject

+ (NSString * _Nonnull)serialize:(NSDate * _Nonnull)value dateFormat:(NSString * _Nonnull)dateFormat;

+ (NSDate * _Nonnull)deserialize:(NSString * _Nonnull)value dateFormat:(NSString * _Nonnull)dateFormat;

@end


@interface DbxArraySerializer : NSObject

+ (NSArray * _Nonnull)serialize:(NSArray * _Nonnull)value withBlock:(id _Nonnull(^_Nonnull)(id _Nonnull obj))withBlock;

+ (NSArray * _Nonnull)deserialize:(NSArray * _Nonnull)jsonData withBlock:(id _Nonnull(^_Nonnull)(id _Nonnull obj))withBlock;

@end
