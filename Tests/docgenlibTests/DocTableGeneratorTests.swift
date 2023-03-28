//
//  DocTableGeneratorTests.swift
//  
//
//  Created by annidy on 2023/3/28.
//

import XCTest
import docgenlib

final class DocTableGeneratorTests: XCTestCase {
    
    var sut: DocTableGenerator!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = DocTableGenerator()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testJavaMethodDoc() {
        sut.appendMethod(name: "abc", docs: """
Test

Best

@param a122 aaa
@param a2   bbb
@return     true if t
""")
        print(sut.methodsTable())
    }
    
    
    func testSwiftMethodDoc() {
        sut.appendMethod(name: "abc", docs: """
magnitude of a vector in three dimensions

from the given components.

- Parameters:
    - x: The *x* component of the vector.
    - y: The *y* component of the vector.
    - z: The *z* component of the vector.

- Returns: A beautiful, brand-new bicycle
""")
        print(sut.methodsTable())
    }
    
    
    func testJavaAttributeDoc() {
        sut.appendAttribute(name: "abc", docs: """
Test
@default a122 aaa
""")
        print(sut.attributesTable())
    }
    
    
    func testSwiftAttributeDoc() {
        sut.appendAttribute(name: "abc", docs: """
Returns the magnitude of a vector in three dimensions
- Default: A beautiful, brand-new bicycle
""")
        print(sut.attributesTable())
    }
}
