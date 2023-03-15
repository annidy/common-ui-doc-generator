//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

fileprivate struct Constants {

}

class CodeParser {
    let fileUrl: URL
    
    init(fileUrl: URL) {
        self.fileUrl = fileUrl
    }
    
    func parseTag(start: String, end: String) throws ->  [String: String]  {
        let lineStartPattern = try Regex(#"\/\/(\s*)"# + start + ":(.*)")
        let lineEndPattern = try Regex(#"\/\/(\s*)"# + end)
        
        var container = [String: String]()
        var marker: String?
        var contents: String!
        
        let reader = FileReader(fileUrl)
        marker = nil
        while let line = reader?.getLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if marker != nil {
                if !lineEndPattern.match(line).isEmpty {
                    container[marker!] = contents
                    marker = nil
                } else {
                    contents.append(line+"\n")
                }
            } else {
                let matchs = lineStartPattern.match(line)
                if !matchs.isEmpty {
                    marker = matchs[0].groups.last?.trimmingCharacters(in: .whitespaces)
                    contents = ""
                }
            }
        }
        if marker != nil {
            container[marker!] = contents
        }
        return container
    }
}
