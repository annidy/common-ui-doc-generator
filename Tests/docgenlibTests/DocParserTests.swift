//
//  DocParserTests.swift
//  
//
//  Created by annidy on 2023/3/27.
//

import XCTest
@testable import docgenlib

final class DocParserTests: XCTestCase {
    
    var sut: DocParser!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testLineComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/// SAMPLE: abc
/// abc
/// def
abc()
/// SAMPLE: abc
/// kkk
abc()
""".write(to: p1, atomically: true, encoding: .utf8)
        sut = DocParser(tagName: "SAMPLE")
        let contains = try sut.parse(fileUrl: p1)
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], ["abc\ndef\n", "kkk\n"])
    }
    
    func testBlockComment() throws {
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
/// SAMPLE: abc
/**
 * abc
 * def
 */
abc()
/// SAMPLE: def
/*
abc
def
*/
""".write(to: p1, atomically: true, encoding: .utf8)
        sut = DocParser(tagName: "SAMPLE")
        let contains = try sut.parse(fileUrl: p1)
        XCTAssertNil(contains["test"])
        XCTAssertEqual(contains["abc"], ["abc\ndef\n"])
        XCTAssertEqual(contains["def"], ["abc\ndef\n"])
    }


}
