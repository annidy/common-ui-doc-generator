import Foundation
import ArgumentParser
import common_ui_doc_utils

@main
struct common_ui_doc_generator: ParsableCommand {
    
    @Flag var verbose = false
    
    @Argument(help: "source folder")
    var sourcePath: String
    
    @Argument(help: "doucemnt folder")
    var docuemntPath: String

    mutating func run() throws {
        
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
