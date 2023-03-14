//
//  File.swift
//  
//
//  Created by annidy on 2023/3/14.
//

import Foundation
import common_ui_doc_utils

extension common_ui_doc_generator {
    func copyDocs() throws {
        try shellRun(arguments: ["cp", "-r", sourcePath.appendingPathComponent("docs/"), documentPath.appendingPathComponent("docs/\(platform)")])
    }
}
