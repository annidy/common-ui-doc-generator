//
//  Rewriter.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation
import Regex

class Rewriter {
    
    struct Replace {
        let range: Range<Int>
        let value: String
    }
    
    let fileUrl: URL
    var fileContent: String
    var replaces: [Replace]
    
    init(fileUrl: URL) throws {
        self.fileUrl = fileUrl
        fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
        replaces = []
    }
    
    func replace(variable: String, value: String) {
        guard let pattern = try? Regex("\\{\\{\(variable)\\}\\}") else {
            return
        }
        let matchs = pattern.match(fileContent)
        for match in matchs {
            replaces.append(Replace(range: match.range, value: value))
        }
    }
    
    func renderString() -> String {
        let sorted = replaces.sorted { l, r in
            l.range.lowerBound < r.range.lowerBound
        }
        let source = Array(fileContent).map {String($0)}
        var render = [String]()
        var cursor = 0
        for replace in sorted {
            render.append(contentsOf: source[cursor..<replace.range.lowerBound])
            render.append(replace.value)
            cursor = replace.range.upperBound
        }
        render.append(contentsOf: source[cursor...])
        return render.joined()
    }
}
