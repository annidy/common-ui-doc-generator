//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

fileprivate struct Constants {
    static let sampleBeginPattern  = try! Regex(#"\/\/(\s*)SAMPLE:(.*)"#)
    static let sampleEndPattern  = try! Regex(#"\/\/(\s*)SAMPLE END"#)
}

class CodeParser {
    let fileUrl: URL
    
    init(fileUrl: URL) {
        self.fileUrl = fileUrl
    }
    
    func parseCodeMarker() ->  [String: [String]] {
        var container = [String: [String]]()
        var marker: String?
        var contents: [String]!
        
        let reader = FileReader(fileUrl)
        marker = nil
        while let line = reader?.getLine()?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if marker != nil {
                if !Constants.sampleEndPattern.match(line).isEmpty {
                    container[marker!] = contents
                    marker = nil
                } else {
                    contents.append(line)
                }
            } else {
                let matchs = Constants.sampleBeginPattern.match(line)
                if !matchs.isEmpty {
                    marker = matchs[0].groups.last?.trimmingCharacters(in: .whitespaces)
                    contents = []
                }
            }
        }
        if marker != nil {
            container[marker!] = contents
        }
        return container
    }
}
