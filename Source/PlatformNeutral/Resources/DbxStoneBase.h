///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>
#import "DbxStoneSerializers.h"

///
/// Route objects used to encapsulate route-specific information.
///
@interface DbxRoute : NSObject

- (nonnull instancetype)init:(NSString * _Nonnull)name namespace_:(NSString * _Nonnull)namespace_ deprecated:(NSNumber * _Nonnull)deprecated resultType:(Class<DbxSerializable> _Nullable)resultType errorType:(Class<DbxSerializable> _Nullable)errorType attrs:(NSDictionary<NSString *, NSString *> * _Nonnull)attrs arraySerialBlock:(id _Nonnull (^_Nullable)(id _Nonnull))arraySerialBlock arrayDeserialBlock:(id _Nonnull (^_Nullable)(id _Nonnull))arrayDeserialBlock;

@property (nonatomic) NSString * _Nonnull name;
@property (nonatomic) NSString * _Nonnull namespace_;
@property (nonatomic) NSNumber * _Nonnull deprecated;
@property (nonatomic) Class<DbxSerializable> _Nullable resultType;
@property (nonatomic) Class<DbxSerializable> _Nullable errorType;
@property (nonatomic) NSDictionary<NSString *, NSString *> * _Nonnull attrs;
@property (nonatomic, nullable) id _Nonnull (^arraySerialBlock)(id _Nonnull array);
@property (nonatomic, nullable) id _Nonnull (^arrayDeserialBlock)(id _Nonnull array);

@end


@interface DbxNilObject : NSObject

@end
