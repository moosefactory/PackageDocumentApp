//
//  DocumentData.swift
//  PackageDocument App
//
//  Created by Tristan Leblanc on 12/01/2021.
//

import Foundation

public struct DocumentData {
    struct ResourceData {
        var string: String
    }

    var string: String
    var resources: [ResourceData]
    
    init(string: String, resources: [ResourceData]) {
        self.string = string
        self.resources = resources
    }
    
    static func new() -> DocumentData {
        DocumentData(string: "New Document Data",
                     resources: [ResourceData(string: "Res1"), ResourceData(string: "Res2")])
    }
}
