//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation

protocol Parser {
    func parseLine(line: String, container: inout [String: String])
}

public class CodeParser {
    var tagName: String
    var lineIndent: Bool
    
    public init(tagName: String, lineIndent: Bool = true) {
        self.tagName = tagName
        self.lineIndent = lineIndent
    }
    
    public func parse(fileUrl: URL) throws -> [String: String]  {
        let parsers: [Parser?] = [
            {
                let p: LineCommentParser? = try? LineCommentParser(tagName: tagName)
                p?.indent = lineIndent
                return p as Parser?
            }(),
            try? BlockCommentParser(tagName: tagName),
            try? InlineCommentParser(tagName: tagName)
        ]
        var container = [String: String]()
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            for parser in parsers {
                parser?.parseLine(line: line, container: &container)
            }
        }
        return container
    }
}

extension Dictionary where Key == String, Value == String {
    mutating func join(text value: String, forTag tag: String) {
        if let exist = self[tag] {
            if exist.last == "\n" {
                self[tag] = exist + value
            } else {
                self[tag] = exist + "\n" + value
            }
        } else {
            self[tag] = value
        }
    }
}
