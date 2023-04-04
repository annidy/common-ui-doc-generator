//
//  DocParser.swift
//  
//
//  Created by annidy on 2023/3/27.
//

import Foundation

public class DocParser {
    var tagName: String
    
    public init(tagName: String) {
        self.tagName = tagName
    }
    
    public func parse(fileUrl: URL) throws -> [String: [String]]  {
        let parser = try AnnotationParser(tagName: tagName)
        var container = [String: [String]]()
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            parser.parseLine(line: line, container: &container)
        }
        return container
    }
}
