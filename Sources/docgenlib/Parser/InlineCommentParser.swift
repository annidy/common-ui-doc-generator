//
//  File.swift
//  
//
//  Created by annidy on 2023/3/23.
//

import Foundation
import Regex

public class InlineCommentParser: Parser {
    let lineStartPattern: Regex
    
    public init(tagStart: String) throws {
        lineStartPattern = try Regex(#"\/\/(\s*)"# + tagStart + ":([- 0-9a-zA-Z_]+)")
    }
    
    
    public func parseLine(line: String, container: inout [String: String]) {
        let startMatchs = lineStartPattern.match(line)
        if startMatchs.count == 0 {
            return
        }
        let prefix = line[0..<startMatchs[0].range.lowerBound]
        for p in prefix {
            if p.isWhitespace {
                continue
            }
            let name = (startMatchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!
            container[name] = [container[name], String(prefix).trimmingCharacters(in: .whitespaces)].compactMap {$0}.joined(separator: "\n")
            break
        }
    }
}
