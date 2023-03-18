//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

internal struct Tag {
    let name: String
    let head: String
    let indent: Bool
    let inline: Bool
    var body: [String]
    
    func push(container: inout [String: String]) {
        var headSapceCount = 0
        for c in head {
            if c.isWhitespace {
                headSapceCount += 1
            } else {
                break
            }
        }
        container[name] = body.map { li in
            li.trailingTrim(in: .whitespacesAndNewlines)
        }.map { li in
            if indent && headSapceCount > 0 && li.count >= headSapceCount {
                if li.substring(to: li.advanceIndex(li.startIndex, by: headSapceCount)).isWhitesapce() {
                    return li.substring(from: li.advanceIndex(li.startIndex, by: headSapceCount))
                }
            }
            return li
        }.joined(separator: "\n").appending(inline ? "" : "\n")
    }
}

public class CodeParser {
    let fileUrl: URL
    var indent: Bool = true
    
    public init(fileUrl: URL, indent: Bool = true) {
        self.fileUrl = fileUrl
        self.indent = indent
    }
    
    
    public func parseTag(start: String, end: String) throws ->  [String: String]  {
        let lineStartPattern = try Regex(#"\/\/(\s*)"# + start + ":(.*)")
        let lineEndPattern = try Regex(#"\/\/(\s*)"# + end)
        
        var container = [String: String]()
        var marker: Tag?
        
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            if marker != nil {
                if !lineEndPattern.match(line).isEmpty {
                    marker?.push(container: &container)
                    marker = nil
                } else {
                    marker?.body.append(line)
                }
            } else {
                let matchs = lineStartPattern.match(line)
                if !matchs.isEmpty {
                    marker = Tag(name: (matchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!,
                                 head: line, indent: indent, inline: false, body: [])
                }
            }
        }
        marker?.push(container: &container)
        return container
    }
}

extension String {

    func trailingTrim(in characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(in: characterSet)
        }
        return self
    }

    mutating func trailedTrim(in characterSet : CharacterSet) {
        self = self.trailingTrim(in: characterSet)
    }

    func isWhitesapce() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
