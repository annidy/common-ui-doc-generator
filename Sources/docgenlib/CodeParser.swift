//
//  CodeParser.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

fileprivate struct Constants {
    static let markerBeginPattern  = #"(\s*)SAMPLE:(.*)"#
    static let markerEndPattern  = #"(\s*)SAMPLE END"#
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
                if line.contains(pattern: Constants.markerEndPattern) {
                    container[marker!] = contents
                    marker = nil
                } else {
                    contents.append(line)
                }
            } else {
                let m = line.match(pattern: Constants.markerBeginPattern)
                if m.count == 3 {
                    marker = line.substring(with: m[2]).trimmingCharacters(in: .whitespaces)
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
