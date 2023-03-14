import Foundation
import ArgumentParser
import common_ui_doc_utils

@main
struct common_ui_doc_generator: ParsableCommand {
    @Option(name: [.short, .long], help: "The platform to generator")
    var platform: String
    
    @Option(name: [.short, .customLong("document")], help: "The document repository")
    var document: String
    
    @Flag var verbose = false
    
    @Argument(help: "source folder")
    var sourcePath: String
    
    var documentPath: String {
        workspacePath.appendingPathComponent(URL(string: document)!.deletingPathExtension().lastPathComponent)
    }

    mutating func run() throws {
        defer {
//            cleanWorksapce()
        }
        prepareWorkspace()
        // step1: clone the doucment
        try shellRun(arguments: ["git", "clone", document])
        try copyDocs()
        try commitChanges()
    }
}

extension common_ui_doc_generator {
    func prepareWorkspace() {
        print("workspace -> \(workspacePath)")
        try? FileManager.default.removeItem(atPath: workspacePath)
        do {
            try FileManager.default.createDirectory(atPath: workspacePath, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
        FileManager.default.changeCurrentDirectoryPath(workspacePath)
    }
    
    func cleanWorksapce() {
        print("delete -> \(workspacePath)")
        do {
            try FileManager.default.removeItem(atPath: workspacePath)
        } catch {
            print(error)
        }
    }
    
    var workspacePath: String {
        let pathComponents = (Bundle.main.executablePath ?? ".").components(separatedBy: "/").dropLast()
        var directoryPath: String = ""
        for component in pathComponents {
            directoryPath += component + "/"
        }
        return directoryPath + "workspace"
    }
}

struct RuntimeError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
