//
//  LineCommentParser.swift
//  
//
//  Created by annidy on 2023/3/22.
//

import Foundation
import Regex

private class Tag {
    let name: String
    let head: String
    let indent: Bool
    let headSapceCount: Int
    var body: [String]
    
    init(name: String, head: String, indent: Bool) {
        self.name = name
        self.head = head
        self.indent = indent
        self.body = []
        
        var headSapceCount = 0
        for c in head {
            if c.isWhitespace {
                headSapceCount += 1
            } else {
                break
            }
        }
        self.headSapceCount = headSapceCount
    }
    
    func push(container: inout [String: String]) {
        let text = body.map { li in
            if indent && li.count > headSapceCount {
                let ali = Array(li)
                for c in ali[0..<headSapceCount] {
                    if !c.isWhitespace {
                        return li
                    }
                }
                return String(ali[headSapceCount...])
            }
            return li
        }.joined()
        container.join(text: text, forTag: name)
    }
}

public class LineCommentParser: Parser {
    let lineStartPattern: Regex
    let lineEndPattern: Regex
    fileprivate var markers = [Tag]()
    public var indent: Bool = true
    
    public init(tagStart: String, tagEnd: String) throws {
        lineStartPattern = try Regex(#"\s*\/\/(\s*)"# + tagStart + ":([- 0-9a-zA-Z_]+)")
        lineEndPattern = try Regex(#"\s*\/\/(\s*)"# + tagEnd)
    }
    
    public func parseLine(line: String, container: inout [String: String]) {
        let startMatchs = lineStartPattern.match(line)
        if !startMatchs.isEmpty {
            markers.append(
                Tag(
                    name: (startMatchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!,
                    head: line, indent: indent)
            )
            return
        }
        let endMatchs = lineEndPattern.match(line)
        if !endMatchs.isEmpty {
            guard let last = markers.popLast() else { return }
            last.push(container: &container)
            return
        }
        markers.forEach { tag in
            tag.body.append(line)
        }
    }
}
