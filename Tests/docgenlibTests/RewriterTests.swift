//
//  RewriterTests.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import XCTest
@testable import docgenlib

final class RewriterTests: XCTestCase {
    
    var rewriter: Rewriter!

    override func setUpWithError() throws {
        let file = FileManager.default.temporaryDirectory.appendingPathComponent("w1.txt")
        try """
This {{is}} an {{test}} of a functional {{test}} case
""".write(to: file, atomically: true, encoding: .utf8)
        rewriter = try Rewriter(fileUrl: file)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        rewriter.replace(variable: "is", value: "are")
        rewriter.replace(variable: "test", value: "sun")
        XCTAssertEqual(rewriter.renderString(), "This are an sun of a functional sun case")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
