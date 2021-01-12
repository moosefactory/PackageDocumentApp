//
//  ViewController.swift
//  PackageDocument App
//
//  Created by Tristan Leblanc on 12/01/2021.
//

import Cocoa

class ViewController: NSViewController {

    override var representedObject: Any? {
        didSet {
            print(content?.string ?? "")
            content?.resources.forEach {
                print($0.string)
            }
        }
    }

    var content: DocumentData? {
        return representedObject as? DocumentData
    }
}
