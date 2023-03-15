//
//  File.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation

func listFiles(root: URL, exts: [String]) -> [URL] {
    var files = [URL]()
    if let enumerator = FileManager.default.enumerator(at: root, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
        for case let fileURL as URL in enumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                if fileAttributes.isRegularFile! {
                    for ext in exts {
                        if fileURL.pathExtension == ext {
                            files.append(fileURL)
                            break
                        }
                    }
                }
            } catch { print(error, fileURL) }
        }
    }
    return files
}
