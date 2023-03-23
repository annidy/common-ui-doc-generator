//
//  BlockCommentParser.swift
//  
//
//  Created by annidy on 2023/3/22.
//

import Foundation
import Regex

public class BlockCommentParser {
    let fileUrl: URL
    
    public init(fileUrl: URL) {
        self.fileUrl = fileUrl
    }
    
    
    public func parseTag(start: String, end: String) throws ->  [String: String]  {
        let lineStartPattern = try Regex(#"\/\*(\s*)"# + start + #":([- 0-9a-zA-Z_]+)\*\/"#)
        let lineEndPattern = try Regex(#"\/\*(\s*)"# + end + #"(\s*)\*\/"#)
        
        var container = [String: String]()
        
        let reader = FileReader(fileUrl)
        while let line = reader?.getLine() {
            let startMatchs = lineStartPattern.match(line)
            let endMatchs = lineEndPattern.match(line)
            if startMatchs.count != endMatchs.count {
                print("\(line) unmatch inline comment")
                continue
            }
            for i in 0..<startMatchs.count {
                let mta = startMatchs[i], mte = endMatchs[i]
                let name = mta.groups.last!.trimmingCharacters(in: .whitespaces)
                let body = String(Array(line)[mta.range.upperBound..<mte.range.lowerBound])
                container[name] = [container[name], body].compactMap {$0}.joined(separator: "\n")
            }
        }
        return container
    }
}
