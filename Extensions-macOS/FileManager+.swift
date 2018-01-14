//
//  FileManager+.swift
//  ARKExtensions
//
//  Created by mac on 1/3/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension FileManager {

    enum ClearError: Error {
        case notADirectory
        case doesNotExist
    }

    public func clearDirectory(_ path: String) throws {
        var isDirectory: ObjCBool = false
        if !fileExists(atPath: path, isDirectory: &isDirectory) {
            throw ClearError.doesNotExist
        }
        if !isDirectory.boolValue {
            throw ClearError.notADirectory
        }

        let contents = try contentsOfDirectory(atPath: path)
        for item in contents {
            try removeItem(atPath: path + "/" + item)
        }
    }
}
