///
/// Copyright (c) 2016 Dropbox, Inc. All rights reserved.
///

#import "DBGlobalErrorResponseHandler.h"
#import <objc/runtime.h>

static DBNetworkErrorResponseBlock s_networkErrorResponseBlock = nil;
static NSOperationQueue *s_networkErrorQueue;

static NSMutableDictionary<Class, DBRouteErrorResponseBlock> * _Nullable s_routeErrorToResponseBlock;
static NSMutableDictionary<Class, NSOperationQueue *> * _Nullable s_routeErrorToQueue;

static NSLock *s_lock;

@implementation DBGlobalErrorResponseHandler

+ (void)initialize {
  static dispatch_once_t once;
  dispatch_once(&once, ^{
    s_networkErrorQueue = [NSOperationQueue mainQueue];

    s_routeErrorToResponseBlock = [NSMutableDictionary new];
    s_routeErrorToQueue = [NSMutableDictionary new];

    s_lock = [NSLock new];
  });
}

+ (void)registerRouteErrorResponseBlock:(DBRouteErrorResponseBlock)routeResponseBlock
                         routeErrorType:(id)routeErrorType {
  [self registerRouteErrorResponseBlock:routeResponseBlock routeErrorType:routeErrorType queue:nil];
}

+ (void)registerRouteErrorResponseBlock:(DBRouteErrorResponseBlock)routeResponseBlock
                         routeErrorType:(id)routeErrorType
                                  queue:(NSOperationQueue *)queue {
  NSOperationQueue *queueToUse = queue ?: [NSOperationQueue mainQueue];

  [s_lock lock];
  s_routeErrorToResponseBlock[routeErrorType] = routeResponseBlock;
  s_routeErrorToQueue[routeErrorType] = queueToUse;
  [s_lock unlock];
}

+ (void)removeRouteErrorResponseBlockWithRouteErrorType:(id)routeErrorType {
  [s_lock lock];
  [s_routeErrorToResponseBlock removeObjectForKey:routeErrorType];
  [s_lock unlock];
}

+ (void)registerNetworkErrorResponseBlock:(DBNetworkErrorResponseBlock)networkErrorResponseBlock {
  [self registerNetworkErrorResponseBlock:networkErrorResponseBlock queue:nil];
}

+ (void)registerNetworkErrorResponseBlock:(DBNetworkErrorResponseBlock)networkErrorResponseBlock
                                    queue:(NSOperationQueue * _Nullable)queue {
  NSOperationQueue *queueToUse = queue;

  [s_lock lock];
  s_networkErrorResponseBlock = networkErrorResponseBlock;

  if (queueToUse) {
    s_networkErrorQueue = queueToUse;
  }
  [s_lock unlock];
}

+ (void)removeNetworkErrorResponseBlock {
  [s_lock lock];
  s_networkErrorResponseBlock = nil;
  [s_lock unlock];
}

+ (void)executeRegisteredResponseBlocksWithRouteError:(id)routeError error:(DBRequestError *)error {
  if (routeError) {
    // execute route error block
    Class errorClass = [routeError class];
    NSDictionary<Class, id> *instanceVariablesClassesToValues =
        [[self class] instanceVariablesDataFromRouteError:routeError];

    [s_lock lock];

    NSOperationQueue *queueToUse = s_routeErrorToQueue[errorClass];

    if ([s_routeErrorToResponseBlock objectForKey:errorClass]) {
      [queueToUse addOperationWithBlock:^{
        [s_lock lock];
        if (s_routeErrorToResponseBlock[errorClass]) {
          s_routeErrorToResponseBlock[errorClass](routeError, error);
        }
        [s_lock unlock];
      }];
    }

    for (Class instanceClass in instanceVariablesClassesToValues) {
      if ([s_routeErrorToResponseBlock objectForKey:instanceClass]) {

        [queueToUse addOperationWithBlock:^{
          [s_lock lock];
          if (s_routeErrorToResponseBlock[instanceClass]) {
            s_routeErrorToResponseBlock[instanceClass](instanceVariablesClassesToValues[instanceClass], error);
          }
          [s_lock unlock];
        }];
      }
    }
    [s_lock unlock];
  }

  // execute network error block
  if (error) {
    [s_lock lock];
    if (s_networkErrorResponseBlock) {
      NSOperationQueue *queueToUse = s_networkErrorQueue;

      [queueToUse addOperationWithBlock:^{
        [s_lock lock];
        if (s_networkErrorResponseBlock) {
          s_networkErrorResponseBlock(error);
        }
        [s_lock unlock];
      }];
    }
    [s_lock unlock];
  }
}

+ (NSDictionary<Class, id> *)instanceVariablesDataFromRouteError:(id)routeError {
  Class errorClass = [routeError class];

  NSMutableDictionary<Class, id> *result = [NSMutableDictionary new];

  // from http://stackoverflow.com/questions/16861204/property-type-or-class-using-reflection
  unsigned int count;
  objc_property_t *props = class_copyPropertyList([errorClass class], &count);

  for (int i = 0; i < count; i++) {
    objc_property_t property = props[i];
    const char *name = property_getName(property);
    NSString *propertyName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];

    const char *type = property_getAttributes(property);

    NSString *typeString = [NSString stringWithUTF8String:type];
    NSArray *attributes = [typeString componentsSeparatedByString:@","];
    NSString *typeAttribute = [attributes objectAtIndex:0];
    NSString *propertyType = [typeAttribute substringFromIndex:1];

    if ([typeAttribute hasPrefix:@"T@"]) {
      NSString *typeClassName =
          [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length] - 4)]; // turns @"NSDate" into NSDate
      Class typeClass = NSClassFromString(typeClassName);
      if (typeClass != nil && typeClass != [NSString class]) {
        // we try / catch here because for union types, a runtime exception is thrown
        // when a value type that doesn't correspond to the tag state is accessed.
        @try {
          id object = [routeError valueForKey:propertyName];
          result[typeClass] = object;
          NSDictionary<Class, id> *additionalData = [[self class] instanceVariablesDataFromRouteError:object];
          [result addEntriesFromDictionary:additionalData];
        } @catch (NSException *) {
        }
        // recursively retrieve instance data
      }
    }
  }
  return result;
}

@end
