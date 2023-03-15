import Foundation
import ArgumentParser
import common_ui_doc_utils

@main
struct common_ui_doc_generator: ParsableCommand {
    
    @Flag var verbose = false
    @Option(help: "source file extention")
    var codeFileExt: String = "kt,java,swift,m,mm"
    
    @Argument(help: "source folder")
    var sourcePath: String
    
    @Argument(help: "doucemnt folder")
    var docuemntPath: String

    mutating func run() throws {
        let files = listFiles(root: URL(string: sourcePath)!, exts: codeFileExt.split(separator: ",").map { String($0) })
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
