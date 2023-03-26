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
    
    func testLineCommentCompatibility() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
SAMPLE: test
/// SAMPLE: abc
abc = 1
// SAMPLE END
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], "abc = 1\n")
    }

    func testLineComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
SAMPLE: test
// SAMPLE: abc
abc = 1
// SAMPLE
// SAMPLE: unicode
中文处理
// SAMPLE
// SAMPLE: with space
space
// SAMPLE
// SAMPLE: def
def = 2
def = 2
// SAMPLE
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
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
// SAMPLE
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
    // SAMPLE
}
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
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
    
    func testNoIndent() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
    // SAMPLE: abc
    if (a) {
        a = 1
    }
    // SAMPLE
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE", lineIndent: false)
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertEqual(contains["abc"], "    if (a) {\n        a = 1\n    }\n")
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
// SAMPLE
abc = 1
// SAMPLE
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
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
    
    func testBlockComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/* SAMPLE: test */ abc = 1 /* SAMPLE */ aaaa /*SAMPLE:567*/5678/*SAMPLE*/
/* /* SAMPLE: 123 */1234/* SAMPLE */ */
/* SAMPLE: a-b */ a-b /* SAMPLE */
/* SAMPLE: a_b */ a_b /* SAMPLE */
/
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertEqual(contains["test"], " abc = 1 ")
        XCTAssertEqual(contains["123"], "1234")
        XCTAssertEqual(contains["567"], "5678")
        XCTAssertEqual(contains["a-b"], " a-b ")
        XCTAssertEqual(contains["a_b"], " a_b ")
    }
    
    func testInLineComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
abc = 1 // SAMPLE: test
def = 2 // SAMPLE: test
/
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertEqual(contains["test"], "abc = 1\ndef = 2\n")
    }
    
    func testJoinComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/* SAMPLE: test */123/* SAMPLE */
// SAMPLE: test
abc
// SAMPLE
ghk // SAMPLE: test
// SAMPLE: test
def
// SAMPLE
/* SAMPLE: test */456/* SAMPLE */
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertEqual(contains["test"], "123\nabc\nghk\ndef\n456")
    }

    func testXMLComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
<?xml version = "1.0" encoding = "UTF-8" ?>
<!--SAMPLE:abc-->
<class_list>
</class_list>
<!--SAMPLE-->
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(tagName: "SAMPLE")
        let contains = try parser.parse(fileUrl: p1)
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], "<class_list>\n</class_list>\n")
    }
}
