//
//  CodeParserTests.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import XCTest
@testable import docgenlib

final class CodeParserTests: XCTestCase {
    
    var parser: CodeParser!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLineComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
SAMPLE: test
// SAMPLE: abc
abc = 1
// SAMPLE END
// SAMPLE: unicode
中文处理
// SAMPLE END
// SAMPLE: with space
space
// SAMPLE END
// SAMPLE: def
def = 2
def = 2

""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], "abc = 1\n")
        XCTAssertEqual(contains["unicode"], "中文处理\n")
        XCTAssertEqual(contains["with space"], "space\n")
        XCTAssertEqual(contains["def"], "def = 2\ndef = 2\n")
    }
    func testIndent() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
// SAMPLE: abc
if (a) {
    a = 1
    中文abc
}
// SAMPLE END
{
    // SAMPLE: def
    if (b) {
        b = 1
        中文abc
    中文abc
bbbbb
bbbb
bbb
bb
b
 c
  d
   e
    }
    // SAMPLE END
}
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], """
if (a) {
    a = 1
    中文abc
}

""")
        XCTAssertEqual(contains["def"], """
if (b) {
    b = 1
    中文abc
中文abc
bbbbb
bbbb
bbb
bb
b
 c
  d
   e
}

""")
    }
    
    func testNest() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
SAMPLE: test
// SAMPLE: abc
abc = 1
// SAMPLE: def
def = 2
def = 2
// SAMPLE END
abc = 1

""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], "abc = 1\ndef = 2\ndef = 2\nabc = 1\n")
        XCTAssertEqual(contains["def"], "def = 2\ndef = 2\n")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testInLineComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/* SAMPLE: test */ abc = 1 /* SAMPLE END */ aaaa /*SAMPLE:567*/5678/*SAMPLE END*/
/* /* SAMPLE: 123 */1234/* SAMPLE END */ */
/* SAMPLE: a-b */ a-b /* SAMPLE END */
/* SAMPLE: a_b */ a_b /* SAMPLE END */
/
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertEqual(contains["test"], " abc = 1 ")
        XCTAssertEqual(contains["123"], "1234")
        XCTAssertEqual(contains["567"], "5678")
        XCTAssertEqual(contains["a-b"], " a-b ")
        XCTAssertEqual(contains["a_b"], " a_b ")
    }
    
    func testJoinComment1() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
// SAMPLE: test
abc
// SAMPLE END
// SAMPLE: test
def
// SAMPLE END
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertEqual(contains["test"], "abc\ndef\n")
    }
    
    func testJoinComment2() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/* SAMPLE: test */abc/* SAMPLE END */
/* SAMPLE: test */def/* SAMPLE END */
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
        let contains = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
        XCTAssertEqual(contains["test"], "abc\ndef")
    }

}
