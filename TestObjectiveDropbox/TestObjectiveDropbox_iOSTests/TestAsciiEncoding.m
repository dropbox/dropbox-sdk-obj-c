#import <XCTest/XCTest.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface DBTransportBaseClient (Tests)
+ (NSString *)asciiEscapeWithString:(NSString *)string;
+ (NSString *)fast_asciiEscapeWithString:(NSString *)string;
+ (NSString *)slow_asciiEscapeWithString:(NSString *)string;
@end

@interface TestAsciiEncoding : XCTestCase

@end

@implementation TestAsciiEncoding

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
        @"this\nhas some whitespace": @"this\nhas some whitespace",
        @"héllø wörld": @"h\\u00e9ll\\u00f8 w\\u00f6rld"
    };
}

- (void)testEveryUnichar {
    for (unsigned short i=0; i < ((unsigned short)-1); i++) {
        unichar myChar = (unichar)i;
        NSString *charString = [[NSString alloc] initWithCharacters:&myChar length:1];
        NSString *lhs = [DBTransportBaseClient slow_asciiEscapeWithString:charString];
        NSString *rhs = [DBTransportBaseClient fast_asciiEscapeWithString:charString];
        XCTAssertTrue([lhs isEqualToString:rhs]);
    }
}

- (void)testEscapeWithString {
    NSDictionary *testStrings = [TestAsciiEncoding testStrings];
    dispatch_block_t testBlock = ^{
        for (NSString *str in [testStrings allKeys]) {
            NSString *lhs = [DBTransportBaseClient asciiEscapeWithString:str];
            NSString *rhs = testStrings[str];
            XCTAssertTrue([lhs isEqualToString:rhs]);
        }
    };
    
    testBlock();
    [DBTransportBaseClient setUseFastAsciiEncoding:YES];
    testBlock();
}

- (void)testEncodings {
    NSDictionary *testStrings = [TestAsciiEncoding testStrings];
    for (NSString *str in [testStrings allKeys]) {
        NSString *lhs = [DBTransportBaseClient fast_asciiEscapeWithString:str];
        NSString *rhs = testStrings[str];
        XCTAssertTrue([lhs isEqualToString:rhs]);
    }
}

- (void)testAgainstOldImplementation {
    NSDictionary *testStrings = [TestAsciiEncoding testStrings];
    for (NSString *str in [testStrings allKeys]) {
        NSString *lhs = [DBTransportBaseClient slow_asciiEscapeWithString:str];
        NSString *rhs = [DBTransportBaseClient fast_asciiEscapeWithString:str];
        XCTAssertTrue([lhs isEqualToString:rhs]);
    }
}
@end
