///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>

///
/// Validator functions used by SDK to impose value constraints.
///
@interface DbxStoneValidators<T> : NSObject {

}

+ (void (^_Nonnull)(NSString * _Nonnull))stringValidator:(NSNumber * _Nullable)minLength maxLength:(NSNumber * _Nullable)maxLength pattern:(NSString * _Nullable)pattern;

+ (void (^_Nonnull)(NSNumber * _Nonnull))numericValidator:(NSNumber * _Nullable)minValue maxValue:(NSNumber * _Nullable)maxValue;

+ (void (^_Nonnull)(NSArray<T> * _Nonnull))arrayValidator:(NSNumber * _Nullable)minItems maxItems:(NSNumber * _Nullable)maxItems itemValidator:(void (^_Nullable)(T _Nonnull))itemValidator;

+ (void (^_Nonnull)(T _Nonnull))nullableValidator:(void (^_Nonnull)(T _Nonnull))internalValidator;

@end
