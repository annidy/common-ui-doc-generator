//
//  AnnotationParser.swift
//  
//
//  Created by annidy on 2023/3/25.
//

import Foundation
import Regex
import Generator

enum AnnotationLineType {
case inline, block
}


class AnnotationParagraph {
    let name: String
    var type: AnnotationLineType?
    var lines: [String]
    
    public init(name: String) {
        self.name = name
        self.lines = []
    }
    
    
    public func push(line: String) -> Bool {
        var generator = line.generator()
        generator.skipWhitespace()
        
        if let type = type {
            switch type {
            case .inline:
                if generator.peek(2) != ["/", "/"] {
                    return false
                }
                generator.skipDash()
            case .block:
                if generator.peek(2) == ["*", "/"] {
                    return false
                }
                generator.skipStar()
            }
        } else {
            if generator.peek(2) == ["/", "/"] {
                type = .inline
                generator.skipDash()
            } else if generator.peek(2) == ["/", "*"] {
                type = .block
                _ = generator.next(2)
                generator.skipStar()
            } else {
                return false
            }
        }
        generator.skipWhitespace()
        lines.append(String(generator.remaining()))
        return true
    }
    
    public func eject(container: inout [String: [String]]) {
        container.join(text: lines.joined(), forTag: name)
    }
}

public class AnnotationParser: Parser {
    let lineStartPattern: Regex
    var name: String?
    var paragraph: AnnotationParagraph?
    
    public init(tagName: String) throws {
        lineStartPattern = try Regex(#"^\s*\/{2,}(\s*)"# + tagName + #":([-. 0-9a-zA-Z_]+)"#)
    }
    
    
    public func parseLine(line: String, container: inout [String: [String]]) {
        if let paragraph = paragraph {
            if !paragraph.push(line: line) {
                paragraph.eject(container: &container)
                self.paragraph = nil
            }
        } else {
            let startMatchs = lineStartPattern.match(line)
            if startMatchs.count == 0 {
                return
            }
            let name = (startMatchs[0].groups.last?.trimmingCharacters(in: .whitespaces))!
            paragraph = AnnotationParagraph(name: name)
        }
    }
}


extension Generator where Container == String {
    public mutating func skipDash() {
        while (self.peek() ?? " ") == "/" {
            self.advance()
        }
    }
    
    public mutating func skipStar() {
        while (self.peek() ?? " ") == "*" {
            self.advance()
        }
    }
}
