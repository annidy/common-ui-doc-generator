//
//  File.swift
//  
//
//  Created by annidy on 2023/3/14.
//

import Foundation
import common_ui_doc_utils

extension common_ui_doc_generator {
    
    func commitChanges() throws {
        try shellRun(arguments: ["git", "-C", documentPath, "add", "."])
        try shellRun(arguments: ["git", "-C", documentPath, "commit", "-m", "update: common-ui-doc-generator"])
        try shellRun(arguments: ["git", "-C", documentPath, "push"])
    }
    
}
