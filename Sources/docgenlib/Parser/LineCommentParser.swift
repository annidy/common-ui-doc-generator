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
        container[name] = body.map { li in
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
    }
}

public class LineCommentParser {
    let fileUrl: URL
    public var indent: Bool = true
    
    public init(fileUrl: URL) {
        self.fileUrl = fileUrl
    }
    
    public func parseTag(start: String, end: String) throws ->  [String: String]  {
        let lineStartPattern = try Regex(#"\/\/(\s*)"# + start + ":([- 0-9a-zA-Z_]+)")
        let lineEndPattern = try Regex(#"\/\/(\s*)"# + end)
        
        var container = [String: String]()
        var markers = [Tag]()
        
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            let startMatchs = lineStartPattern.match(line)
            if !startMatchs.isEmpty {
                    markers.append(
                        Tag(
                            name: (startMatchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!,
                            head: line, indent: indent)
                    )
                    continue
            }
            let endMatchs = lineEndPattern.match(line)
            if !endMatchs.isEmpty {
                guard let last = markers.popLast() else { continue }
                last.push(container: &container)
                continue
            }
            markers.forEach { tag in
                tag.body.append(line)
            }
        }
        markers.forEach { tag in
            tag.push(container: &container)
        }
        return container
    }
}
