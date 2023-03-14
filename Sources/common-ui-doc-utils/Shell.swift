//
//  File.swift
//  
//
//  Created by annidy on 2023/3/14.
//

import Foundation
import CoreFoundation

public func shellRun(arguments: [String], stdout: Pipe? = nil) throws {
    let p = Process()
    p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
    p.arguments = arguments
    if let stdout {
        p.standardOutput = stdout
    }
    try p.run()
    p.waitUntilExit()
}
