///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import "DbxStoneBase.h"

@implementation DbxRoute

- (nonnull instancetype)init:(NSString *)name namespace_:(NSString *)namespace_ deprecated:(NSNumber *)deprecated resultType:(Class<DbxSerializable>)resultType errorType:(Class<DbxSerializable>)errorType attrs:(NSDictionary<NSString *, NSString *> *)attrs {
    self = [self init];
    if (self != nil) {
        _name = name;
        _namespace_ = namespace_;
        _deprecated = deprecated;
        _resultType = resultType;
        _errorType = errorType;
        _attrs = attrs;
    }
    return self;
}

@end


@implementation DbxNilObject

@end
