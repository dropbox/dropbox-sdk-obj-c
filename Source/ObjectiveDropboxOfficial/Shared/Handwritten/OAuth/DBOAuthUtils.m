///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthUtils.h"

#import "DBOAuthConstants.h"
#import "DBOAuthPKCESession.h"
#import "DBScopeRequest+Protected.h"

@implementation DBOAuthUtils

+ (NSArray<NSURLQueryItem *> *)createPkceCodeFlowParamsForAuthSession:(DBOAuthPKCESession *)authSession {
  NSMutableArray<NSURLQueryItem *> *params = [NSMutableArray new];
  DBScopeRequest *scopeRequest = authSession.scopeRequest;
  NSString *scopeString = scopeRequest.scopeString;
  if (scopeString) {
    [params addObject:[NSURLQueryItem queryItemWithName:kDBScopeKey value:scopeString]];
  }
  if (scopeRequest.includeGrantedScopes) {
    [params addObject:[NSURLQueryItem queryItemWithName:kDBIncludeGrantedScopesKey value:scopeRequest.scopeType]];
  }
  DBPkceData *pkceData = authSession.pkceData;
  [params addObjectsFromArray:@[
    [NSURLQueryItem queryItemWithName:kDBCodeChallengeKey value:pkceData.codeChallenge],
    [NSURLQueryItem queryItemWithName:kDBCodeChallengeMethodKey value:pkceData.codeChallengeMethod],
    [NSURLQueryItem queryItemWithName:kDBTokenAccessTypeKey value:authSession.tokenAccessType],
    [NSURLQueryItem queryItemWithName:kDBResponseTypeKey value:authSession.responseType],
    [NSURLQueryItem queryItemWithName:kDBStateKey value:authSession.state],
  ]];
  return params;
}

@end
