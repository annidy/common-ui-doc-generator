import Foundation
import ArgumentParser
import docgenlib

@main
struct docgen: ParsableCommand {
    
    @Flag
    var verbose = false
    
    @Flag(inversion: .prefixedEnableDisable, help: "indent with the marker")
    var indent = true
    
    @Option(help: "source file name extention")
    var sourceFileNameExts: String = "kt,java,swift,m,mm"
    
    @Option(help: "doucment file name extention")
    var documentFileNameExts: String = "md"
    
    @Argument(help: "source folder")
    var sourcePath: String
    
    @Argument(help: "doucemnt folder")
    var docuemntPath: String

    mutating func run() throws {
        let sourceFiles = listFiles(root: URL(string: sourcePath)!, exts: sourceFileNameExts.split(separator: ",").map { String($0) })
        var allTags = [String: String]()
        for file in sourceFiles {
            let parser = CodeParser(fileUrl: file, indent: indent)
            let tags = try parser.parseTag(start: "SAMPLE", end: "SAMPLE END")
            allTags.merge(tags)  { (_, new) in new }
        }
        let docsFilse = listFiles(root: URL(string: docuemntPath)!, exts: documentFileNameExts.split(separator: ",").map { String($0) })
        for file in docsFilse {
            let rewriter = try Rewriter(fileUrl: file)
            for (_, value) in allTags.enumerated() {
                rewriter.replace(variable: value.key, value: value.value)
            }
            try rewriter.renderString().write(to: file, atomically: true, encoding: .utf8)
        }
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
