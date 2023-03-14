//
//  File.swift
//  
//
//  Created by annidy on 2023/3/14.
//

import Foundation

extension String {
    public func appendingPathComponent(_ str: String) -> String {
        if self.hasSuffix("/") {
            return self + str
        }
        return self + "/" + str
    }
}
