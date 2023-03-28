import Foundation
import ArgumentParser
import docgenlib

@main
struct docgen: ParsableCommand {
    
    @Flag
    var verbose = false
    
    @Flag(inversion: .prefixedEnableDisable, help: "indent with codetag")
    var indent = true
    
    @Option(help: "codetag")
    var codetag = "SAMPLE"
    
    @Option
    var methodtag = "METHOD"
    
    @Option
    var attributetag = "ATTRIBUTE"
    
    @Option(help: "source file name extention")
    var sourceFileNameExts: String = "kt,java,swift,m,mm,xml,c,cpp"
    
    @Option(help: "doucment file name extention")
    var documentFileNameExts: String = "md"
    
    @Argument(help: "source folder")
    var sourcePath: String
    
    @Argument(help: "document folder")
    var docuemntPath: String
    


    mutating func run() throws {
        var sampleTags = [String: String]()
        var methodTags = [String: String]()
        var attributeTags = [String: String]()
        
        func sampleProcess(fileUrl: URL) throws {
            let parser = CodeParser(tagName: codetag, lineIndent: indent)
            let tags = try parser.parse(fileUrl: fileUrl)
            sampleTags.merge(tags)  { (_, new) in new }
        }
        
        func methodProcess(fileUrl: URL) throws {
            let parser = DocParser(tagName: methodtag)
            let tags = try parser.parse(fileUrl: fileUrl)
            methodTags.merge(tags)  { (_, new) in new }
        }
        
        func attributeProcess(fileUrl: URL) throws {
            let parser = DocParser(tagName: attributetag)
            let tags = try parser.parse(fileUrl: fileUrl)
            attributeTags.merge(tags)  { (_, new) in new }
        }
        
        let sourceFiles = listFiles(root: URL(string: sourcePath)!, exts: sourceFileNameExts.split(separator: ",").map { String($0) })

        
        for file in sourceFiles {
            try sampleProcess(fileUrl: file)
            try methodProcess(fileUrl: file)
            try attributeProcess(fileUrl: file)
        }
        
        let docsFilse = listFiles(root: URL(string: docuemntPath)!, exts: documentFileNameExts.split(separator: ",").map { String($0) })
        for file in docsFilse {
            let rewriter = try Rewriter(fileUrl: file)
            for (_, value) in sampleTags.enumerated() {
                rewriter.replace(variable: value.key, value: value.value)
            }
            let fileName = file.pathComponents.last!
            let className = String(fileName.prefix(upTo: fileName.lastIndex { $0 == "." } ?? fileName.endIndex))
            let tableRender = DocTableGenerator()
            for (_, value) in methodTags.enumerated() {
                let names = value.key.split(separator: ".")
                if names.count == 2 && names[0] == className {
                    tableRender.appendMethod(name: String(names[1]), docs: value.value)
                }
            }
            for (_, value) in attributeTags.enumerated() {
                let names = value.key.split(separator: ".")
                if names.count == 2 && names[0] == className {
                    tableRender.appendAttribute(name: String(names[1]), docs: value.value)
                }
            }
            rewriter.replace(variable: "METHODS", value: tableRender.methodsTable())
            rewriter.replace(variable: "ATTRIBUTES", value: tableRender.attributesTable())
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
