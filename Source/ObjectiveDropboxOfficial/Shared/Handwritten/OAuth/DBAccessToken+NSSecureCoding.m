///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthManager.h"
#import "DBAccessToken+NSSecureCoding.h"

@implementation DBAccessToken (NSSecureCoding)

+ (DBAccessToken *)createTokenFromData:(NSData *)data {
  DBAccessToken *token = nil;
  if (@available(iOS 11.0, *)) {
    token = [NSKeyedUnarchiver unarchivedObjectOfClass:[DBAccessToken class] fromData:data error:NULL];
  } else {
    id object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([object isKindOfClass:[DBAccessToken class]]) {
      token = object;
    }
  }
  return token;
}

+ (NSData *)covertTokenToData:(DBAccessToken *)token {
  NSData *data = nil;
  if (@available(iOS 11.0, *)) {
    data = [NSKeyedArchiver archivedDataWithRootObject:token requiringSecureCoding:YES error:NULL];
  } else {
    data = [NSKeyedArchiver archivedDataWithRootObject:token];
  }
  return data;
}


@end
