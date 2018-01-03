//
//  FileManager+.swift
//  ARKExtensions
//
//  Created by mac on 1/3/18.
//  Copyright © 2018 arkdan. All rights reserved.
//

import Foundation

extension FileManager {
    public func clearDirectory(_ path: String) {
        var isDirectory: ObjCBool = false
        if !fileExists(atPath: path, isDirectory: &isDirectory) {
            fatalError()
        }
        if !isDirectory.boolValue {
            fatalError()
        }

        let paths: [String]
        do {
            paths = try contentsOfDirectory(atPath: path)
        } catch {
            print("\(#function) error: \((error as NSError).localizedDescription)")
            return
        }
        for p in paths {
            try? removeItem(atPath: path + "/" + p)
        }
    }
}
