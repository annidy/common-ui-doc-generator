//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation

protocol Parser {
    func parseTag(start: String, end: String) throws -> [String: String] 
}

public class CodeParser {
    var lineParser: LineCommentParser?
    var inlineParser: BlockCommentParser?
    
    public init(fileUrl: URL) {
        self.lineParser = LineCommentParser(fileUrl: fileUrl)
        self.inlineParser = BlockCommentParser(fileUrl: fileUrl)
    }
    
    public var lineIndent: Bool {
        get {
            self.lineParser?.indent ?? false
        }
        set {
            self.lineParser?.indent = newValue
        }
    }
    
    public func parseTag(start: String, end: String) throws -> [String: String]  {
        var container = [String: String]()
        if let paser = self.lineParser {
            container.merge(try paser.parseTag(start: start, end: end)) { l, r in
                l + "\n" + r
            }
        }
        if let paser = self.inlineParser {
            container.merge(try paser.parseTag(start: start, end: end))  { l, r in
                l + "\n" + r
            }
        }
        
        return container
    }
}
