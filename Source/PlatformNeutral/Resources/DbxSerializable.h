///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>

///
/// Protocol which all Obj-C SDK API route objects must implement.
///

@protocol DbxSerializable <NSObject>

@required
+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;
+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;
- (NSString * _Nonnull)description;

@end