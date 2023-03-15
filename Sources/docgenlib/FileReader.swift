//
//  File.swift
//  
//
//  Created by annidy on 2023/3/15.
//

import Foundation

class FileReader {
    init? (_ url: URL) {
        let path = url.path
        errno = 0
        file = fopen(path, "r")
        if file == nil {
            perror(path)
            return nil
        }
    }
    
    deinit {
        fclose(file)
    }
    
    // read an entire line. lines should be with line terminators '\n' at the end
    func getLine() -> String? {
        var line = ""
        repeat {
            var buf = [CChar](repeating: 0, count: 1024)
            errno = 0
            if fgets(&buf, Int32(buf.count), file) == nil {
                if ferror(file) != 0 {
                    perror(nil)
                }
                return line.isEmpty ? nil : line
            }
            line += String(cString: buf)
        } while line.lastIndex(of: "\n") == nil
        return line
    }
    
    private var file: UnsafeMutablePointer <FILE>?
}
