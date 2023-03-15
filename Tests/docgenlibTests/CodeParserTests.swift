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
        let p1 = FileManager.default.temporaryDirectory.appendingPathComponent("p1.txt")
        try """
// SAMPLE: abc
abc = 1
// SAMPLE END
// SAMPLE: def
def = 2
def = 2
""".write(to: p1, atomically: true, encoding: .utf8)
        parser = CodeParser(fileUrl: p1)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMarker() throws {
        let contains = parser.parseCodeMarker()
        XCTAssertEqual(contains["abc"], ["abc = 1"])
        XCTAssertEqual(contains["def"], ["def = 2", "def = 2"])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
