///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>
#import "DbxSerializable.h"
#import "DbxStoneSerializers.h"

///
/// Route object used to encapsulate route-specific information.
///
@interface DbxRoute : NSObject

/// Name of the route.
@property (nonatomic) NSString * _Nonnull name;

/// Namespace that the route is contained within.
@property (nonatomic) NSString * _Nonnull namespace_;

/// Whether the route is deprecated.
@property (nonatomic) NSNumber * _Nonnull deprecated;

/// Class of the route's result object type (must implement `DbxSerializable`
/// protocol).
@property (nonatomic) Class<DbxSerializable> _Nullable resultType;

/// Class of the route's error object type (must implement `DbxSerializable`
/// protocol). Note: this class is only for route-specific errors, as opposed
/// to more generic Dropbox API errors, as represented by the `DbxError` class.
@property (nonatomic) Class<DbxSerializable> _Nullable errorType;

/// Custom attributes associated with each route (can pertain to authentication
/// type, host cluster, request-type, etc.).
@property (nonatomic) NSDictionary<NSString *, NSString *> * _Nonnull attrs;

/// Serialization block for the route's result object type, if that result object
/// type is an `NSArray`, otherwise `nil`. This block is designed to be passed into
/// the `serialize` method of the `DbxArraySerializer` class.
@property (nonatomic, nullable) id _Nonnull (^arraySerialBlock)(id _Nonnull array);

/// Deserialization block for the route's result object type, if that result object
/// type is an `NSArray`, otherwise `nil`. This block is designed to be passed into
/// the `deserialize` method of the `DbxArraySerializer` class.
@property (nonatomic, nullable) id _Nonnull (^arrayDeserialBlock)(id _Nonnull array);

/// Initializes the route object.
- (nonnull instancetype)init:(NSString * _Nonnull)name namespace_:(NSString * _Nonnull)namespace_ deprecated:(NSNumber * _Nonnull)deprecated resultType:(Class<DbxSerializable> _Nullable)resultType errorType:(Class<DbxSerializable> _Nullable)errorType attrs:(NSDictionary<NSString *, NSString *> * _Nonnull)attrs arraySerialBlock:(id _Nonnull (^_Nullable)(id _Nonnull))arraySerialBlock arrayDeserialBlock:(id _Nonnull (^_Nullable)(id _Nonnull))arrayDeserialBlock;

@end

///
/// Wrapper object designed to represent a `nil` response from the Dropbox API.
///
@interface DbxNilObject : NSObject

@end
