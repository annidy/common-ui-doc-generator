//
//  BlockCommentParser.swift
//  
//
//  Created by annidy on 2023/3/22.
//

import Foundation
import Regex

public class BlockCommentParser: Parser {
    let lineStartPattern: Regex
    let lineEndPattern: Regex
    
    public init(tagName: String) throws {
        lineStartPattern = try Regex(#"\/\*(\s*)"# + tagName + #":([- 0-9a-zA-Z_]+)\*\/"#)
        lineEndPattern = try Regex(#"\/\*(\s*)"# + tagName + #"(\s*)\*\/"#)
    }
    
    
    public func parseLine(line: String, container: inout [String: String]) {
        let startMatchs = lineStartPattern.match(line)
        let endMatchs = lineEndPattern.match(line)
        if startMatchs.count != endMatchs.count {
            print("\(line) unmatch inline comment")
            return
        }
        for i in 0..<startMatchs.count {
            let mta = startMatchs[i], mte = endMatchs[i]
            let name = mta.groups.last!.trimmingCharacters(in: .whitespaces)
            let body = String(Array(line)[mta.range.upperBound..<mte.range.lowerBound])
            container.join(text: body, forTag: name)
        }
    }
}
