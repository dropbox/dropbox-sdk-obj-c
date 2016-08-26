///
/// The objects in this file are used by generated code and should not need to be invoked manually.
///

#import <Foundation/Foundation.h>

///
/// Protocol which all Obj-C SDK API route objects must implement, otherwise a compiler-warning
/// is generated.
///
@protocol DBXSerializable <NSObject>

@required

///
/// Class method which returns a json-compatible dictionary representation of the
/// supplied object.
///
/// - parameter obj: The API object to be serialized.
///
/// - returns: A serialized, json-compatible dictionary representation of the API object.
///
+ (NSDictionary * _Nonnull)serialize:(id _Nonnull)obj;

///
/// Class method which returns an instantiation of the supplied object as represented
/// by a json-compatible dictionary.
///
/// - parameter dict: The API object to be serialized.
///
/// - returns: A serialized, json-compatible dictionary representation of the API object.
///
+ (id _Nonnull)deserialize:(NSDictionary * _Nonnull)dict;

/// Returns a human-readable representation of the given object.
- (NSString * _Nonnull)description;

@end