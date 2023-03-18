//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

internal class Tag {
    let name: String
    let head: String
    let indent: Bool
    let inline: Bool
    var body: [String]
    
    init(name: String, head: String, indent: Bool, inline: Bool, body: [String]) {
        self.name = name
        self.head = head
        self.indent = indent
        self.inline = inline
        self.body = body
    }
    
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
        var markers = [Tag]()
        
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            let startMatchs = lineStartPattern.match(line)
            if !startMatchs.isEmpty {
                    markers.append(
                        Tag(
                            name: (startMatchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!,
                            head: line, indent: indent, inline: false, body: [])
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
