#import <XCTest/XCTest.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface DBTransportBaseClient (Tests)
+ (NSString *)asciiEscapeWithString:(NSString *)string;
@end

@interface TestAsciiEncoding : XCTestCase

@end

@implementation TestAsciiEncoding

// This was the prior method to ascii escape for comparison purposes.
+ (NSString *)old_asciiEscapeWithString:(NSString *)string {
  NSMutableString *result = [[NSMutableString alloc] init];
  for (NSUInteger i = 0; i < string.length; i++) {
    NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
    if ([substring canBeConvertedToEncoding:NSASCIIStringEncoding]) {
      [result appendString:substring];
    } else {
      [result appendFormat:@"\\u%04x", [string characterAtIndex:i]];
    }
  }
  return result;
}

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

+ (NSDictionary<NSString *, NSString *> *)testStrings {
    return @{
        @"hello": @"hello",
        @"": @"",
        @"こんにちは": @"\\u3053\\u3093\\u306b\\u3061\\u306f",
        @"this has a clustered flag 🇺🇸": @"this has a clustered flag \\ud83c\\uddfa\\ud83c\\uddf8",
        @"this is a big emoji 👩‍👩‍👧‍👦": @"this is a big emoji \\ud83d\\udc69\\u200d\\ud83d\\udc69\\u200d\\ud83d\\udc67\\u200d\\ud83d\\udc66",
        @"🍺": @"\\ud83c\\udf7a",
        @"this\nhas some whitespace": @"this\nhas some whitespace"
    };
}

- (void)testEncodings {
    NSDictionary *testStrings = [TestAsciiEncoding testStrings];
    for (NSString *str in [testStrings allKeys]) {
        NSString *lhs = [DBTransportBaseClient asciiEscapeWithString:str];
        NSString *rhs = testStrings[str];
        XCTAssertTrue([lhs isEqualToString:rhs]);
    }
}

- (void)testAgainstOldImplementation {
    NSDictionary *testStrings = [TestAsciiEncoding testStrings];
    for (NSString *str in [testStrings allKeys]) {
        NSString *lhs = [DBTransportBaseClient asciiEscapeWithString:str];
        NSString *rhs = [TestAsciiEncoding old_asciiEscapeWithString:str];
        XCTAssertTrue([lhs isEqualToString:rhs]);
    }
}
@end
