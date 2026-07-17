#import <XCTest/XCTest.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>
#import "TestAuthTokenGenerator.h"

@implementation TestAuthTokenGenerator

+ (NSString *)credentialForKey:(NSString *)key {
    NSString *credentialsPath = [NSProcessInfo processInfo].environment[@"SDK_TEST_CREDENTIALS_FILE"];
    XCTAssertNotEqual(credentialsPath.length, 0, @"SDK_TEST_CREDENTIALS_FILE environment variable must exist");
    NSData *credentialsData = [NSData dataWithContentsOfFile:credentialsPath];
    XCTAssertNotNil(credentialsData, @"Unable to read SDK test credentials file");
    NSDictionary<NSString *, NSString *> *credentials =
        credentialsData ? [NSJSONSerialization JSONObjectWithData:credentialsData options:0 error:nil] : nil;
    XCTAssertTrue([credentials isKindOfClass:[NSDictionary class]], @"SDK test credentials file must contain JSON");
    NSString *value = credentials[key];
    XCTAssertNotNil(value, @"%@ must exist in SDK test credentials file", key);
    XCTAssertNotEqual(value.length, 0, @"%@ must be longer than 0", key);
    XCTAssertFalse([value hasSuffix:@" "], @"%@ must not end in whitespace", key);
    return value;
}

// Easy way for all tests to get an auth token for the scopes they use.
+ (nullable DBAccessToken *)refreshToken:(nullable NSString *)refreshToken
                                  apiKey:(nullable NSString *)apiKey
                               apiSecret:(nullable NSString *)apiSecret
                                  scopes:(nonnull NSArray<NSString *> *)scopes {
    XCTAssertNotEqual(refreshToken.length, 0, @"Error: refreshToken needs to be set");
    if (refreshToken.length == 0) {
        return nil;
    }
    XCTAssertNotEqual(apiKey.length, 0, @"Error: api key needs to be set");
    if(apiKey.length == 0) {
        return nil;
    }
    XCTAssertNotEqual(apiSecret.length, 0, @"Error: api secret needs to be set");
    if (apiSecret.length == 0) {
        return nil;
    }

    NSURLComponents *bodyComponents = [[NSURLComponents alloc] init];
    bodyComponents.queryItems = @[
        [NSURLQueryItem queryItemWithName:@"grant_type" value:@"refresh_token"],
        [NSURLQueryItem queryItemWithName:@"refresh_token" value:refreshToken],
        [NSURLQueryItem queryItemWithName:@"scope" value:[scopes componentsJoinedByString:@" "]],
    ];

    NSMutableURLRequest *request =
        [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.dropboxapi.com/oauth2/token"]];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [bodyComponents.percentEncodedQuery dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    NSString *credentials = [NSString stringWithFormat:@"%@:%@", apiKey, apiSecret];
    NSData *credentialsData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSString *basicAuth = [credentialsData base64EncodedStringWithOptions:0];
    [request setValue:[NSString stringWithFormat:@"Basic %@", basicAuth] forHTTPHeaderField:@"Authorization"];

    XCTestExpectation *flag = [[XCTestExpectation alloc] init];
    __block DBAccessToken *authToken = nil;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession]
        dataTaskWithRequest:request
          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            XCTFail(@"Error: failed to refresh access token (%@)", error.localizedDescription);
            [flag fulfill];
            return;
        }

        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSDictionary<NSString *, id> *result =
            data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
        NSString *accessToken = [result[@"access_token"] isKindOfClass:[NSString class]] ? result[@"access_token"] : nil;
        NSNumber *expiresIn = [result[@"expires_in"] isKindOfClass:[NSNumber class]] ? result[@"expires_in"] : nil;
        if (httpResponse.statusCode != 200 || accessToken.length == 0 || expiresIn == nil) {
            NSString *errorDescription =
                [result[@"error_description"] isKindOfClass:[NSString class]] ? result[@"error_description"] : @"Invalid response";
            XCTFail(@"Error: failed to refresh access token (HTTP %ld: %@)", (long)httpResponse.statusCode,
                    errorDescription);
        } else {
            NSString *uid = [result[@"uid"] isKindOfClass:[NSString class]] ? result[@"uid"] : @"";
            NSTimeInterval expiration = [[NSDate date] timeIntervalSince1970] + expiresIn.doubleValue;
            authToken = [[DBAccessToken alloc] initWithAccessToken:accessToken
                                                               uid:uid
                                                      refreshToken:refreshToken
                                          tokenExpirationTimestamp:expiration];
        }
        [flag fulfill];
    }];
    [task resume];

    XCTWaiterResult result = [XCTWaiter waitForExpectations:@[flag] timeout:10];
    XCTAssertEqual(result, XCTWaiterResultCompleted, @"Error: Timeout refreshing access token");
    return authToken;
}

@end
