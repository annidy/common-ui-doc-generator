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
    var tagStart: String
    var tagEnd: String
    var lineIndenet: Bool
    
    public init(tagStart: String, tagEnd: String, lineIndenet: Bool = true) {
        self.tagStart = tagStart
        self.tagEnd = tagEnd
        self.lineIndenet = lineIndenet
    }
    
    public func parse(fileUrl: URL) throws -> [String: String]  {
        let parsers: [Parser?] = [
            try? LineCommentParser(tagStart: tagStart, tagEnd: tagStart),
            try? BlockCommentParser(tagStart: tagStart, tagEnd: tagEnd),
            try? InlineCommentParser(tagStart: tagStart)
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
    mutating func joinTag(stringOptinal optional : String?, forStringKey stringKey : String) {
        self[stringKey] = [self[stringKey], optional].compactMap { $0 }.joined(separator: "\n")
    }
}
