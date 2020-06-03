///
/// Copyright (c) 2020 Dropbox, Inc. All rights reserved.
///

#import "DBOAuthTokenRequest.h"

#import "DBOAuthManager.h"
#import "DBOAuthResult.h"
#import "DBSDKConstants.h"
#import "DBTransportBaseConfig.h"
#import "DBTransportBaseHostnameConfig.h"

@interface DBOAuthTokenExchangeRequest ()

@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) DBOAuthTokenExchangeRequest* retainSelf;
@property (nonatomic, copy) DBOAuthCompletion completion;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation DBOAuthTokenExchangeRequest

- (instancetype)initWithOAuthCode:(NSString *)oauthCode
                     codeVerifier:(NSString *)codeVerifier
                           appKey:(NSString *)appKey
                           locale:(NSString *)locale
                      redirectUri:(NSString *)redirectUri {
  self = [super init];
  if (self) {
    _task = [self db_createTokenRequestTaskWithOAuthCode:oauthCode
                                            codeVerifier:codeVerifier
                                                  appKey:appKey
                                                  locale:locale
                                             redirectUri:redirectUri];
  }
  return self;
}

- (void)startWithCompletion:(DBOAuthCompletion)completion {
  [self startWithCompletion:completion queue:dispatch_get_main_queue()];
}

- (void)startWithCompletion:(DBOAuthCompletion)completion
                      queue:(dispatch_queue_t)queue {
  _retainSelf = self;
  _completion = [completion copy];
  _queue = nil;
  [_task resume];
}

- (void)cancel {
  [_task cancel];
  _retainSelf = nil;
}

- (NSURLSessionDataTask *)db_createTokenRequestTaskWithOAuthCode:(NSString *)oauthCode
                                                    codeVerifier:(NSString *)codeVerifier
                                                          appKey:(NSString *)appKey
                                                          locale:(NSString *)locale
                                                     redirectUri:(NSString *)redirectUri {
  NSURLComponents *urlComponents = [NSURLComponents new];
  urlComponents.scheme = @"https";
  urlComponents.host = [[DBTransportBaseHostnameConfig alloc] init].api;
  urlComponents.path = @"/oauth2/token";
  NSURL *url = urlComponents.URL;
  NSAssert(url, @"Unable to create oauth2/token url");

  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];

  NSDictionary<NSString *, NSString *> *paramsDict = @{
    @"grant_type": @"authorization_code",
    @"code": oauthCode,
    @"locale": locale,
    @"client_id": appKey,
    @"code_verifier": codeVerifier,
    @"redirect_uri": redirectUri
  };

  NSMutableArray<NSString *> *paramsArray = [NSMutableArray new];
  for (NSString *key in paramsDict.allKeys) {
    [paramsArray addObject:[NSString stringWithFormat:@"%@=%@", key, paramsDict[key]]];
  }
  NSString *paramsString = [paramsArray componentsJoinedByString:@"&"];
  NSData *paramsData = [paramsString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];

  request.HTTPMethod = @"POST";
  request.HTTPBody = paramsData;
  [request addValue:[DBTransportBaseConfig defaultUserAgent] forHTTPHeaderField:@"User-Agent"];
  [request addValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

  __weak typeof(self) weakSelf = self;
  return [[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    [weakSelf db_handleResponse:response data:data error:error];
  }];

  return [[NSURLSession sharedSession] dataTaskWithRequest:request];
}

- (void)db_handleResponse:(NSURLResponse *)response
                     data:(NSData *)data
                    error:(NSError *)error {
  NSDictionary<NSString *, id> *resultDict = [DBOAuthTokenExchangeRequest resultDictionaryFromData:data];
  DBOAuthResult *result = nil;
  if (error) {
    // Network error
    result = [DBOAuthResult unknownErrorWithErrorDescription:error.localizedDescription];
  } else {
    // No network error, parse response data
    result = [DBOAuthTokenExchangeRequest db_extractResultFromDict:resultDict];
  }

  dispatch_queue_t queue = _queue ?: dispatch_get_main_queue();
  dispatch_async(queue, ^{
    self->_completion(result);
  });
}

+ (NSDictionary<NSString *, id> *)resultDictionaryFromData:(NSData *)data {
  id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
  if ([json isKindOfClass:[NSDictionary<NSString *, id> class]]) {
    return json;
  } else {
    return nil;
  }
}

+ (DBOAuthResult *)db_extractResultFromDict:(NSDictionary<NSString *, id> *)dict {
  // Interpret success result if any.
  DBOAuthResult *successResult = [self db_extractSuccessResultFromDict:dict];
  if (successResult) {
    return successResult;
  }

  // Interpret error if any.
  DBOAuthResult *errorResult = [self db_extractErrorResultFromDict:dict];
  if (errorResult) {
    return errorResult;
  }

  return [DBOAuthResult unknownErrorWithErrorDescription:@"Invalid response."];
}

+ (DBOAuthResult *)db_extractErrorResultFromDict:(NSDictionary<NSString *, id> *)dict {
  id errorCode = dict[@"error"];
  if (!errorCode) {
    return nil;
  }
  id errorDescription = dict[@"error_description"];
  if ([errorCode isKindOfClass:[NSString class]] && [errorDescription isKindOfClass:[NSString class]]) {
    return [[DBOAuthResult alloc] initWithError:errorCode errorDescription:errorDescription];
  } else {
    return [DBOAuthResult unknownErrorWithErrorDescription:nil];
  }
}

+ (DBOAuthResult *)db_extractSuccessResultFromDict:(NSDictionary<NSString *, id> *)dict {
  id tokenType = dict[@"token_type"];
  id accessToken = dict[@"access_token"];
  id refreshToken = dict[@"refresh_token"];
  id userId = dict[@"uid"];
  id expiresIn = dict[@"expires_in"];

  BOOL valid =
    [tokenType isKindOfClass:[NSString class]] && [@"bearer" caseInsensitiveCompare:tokenType] == NSOrderedSame;
  valid = valid && [accessToken isKindOfClass:[NSString class]];
  valid = valid && [refreshToken isKindOfClass:[NSString class]];
  valid = valid && [userId isKindOfClass:[NSString class]];
  valid = valid && [expiresIn isKindOfClass:[NSNumber class]];

  if (valid) {
    NSTimeInterval tokenExpirationTimestamp =
      [[[NSDate new] dateByAddingTimeInterval:((NSNumber *)expiresIn).doubleValue] timeIntervalSince1970];
    DBAccessToken *token = [DBAccessToken createWithShortLivedAccessToken:accessToken
                                                                      uid:userId
                                                             refreshToken:refreshToken
                                                 tokenExpirationTimestamp:tokenExpirationTimestamp];;
    return [[DBOAuthResult alloc] initWithSuccess:token];
  } else {
    return nil;
  }
}

@end
