//
//  Document.swift
//  PackageDocument App
//
//  Created by Tristan Leblanc on 12/01/2021.
//

import Cocoa

class Document: NSDocument {

    /// Specific Document errors
    enum Errors: String, Error {
        case unsupportedType
    }
    
    /// Document UTI
    /// Note it will be a lowercased version of the info.plist UTI
    
    static let UTI = "com.moosefactory.packagedocument-app.doc"
    
    /// The document data
    
    public var content: DocumentData

    override class var autosavesInPlace: Bool { true }

    /// Init a new document
    
    override init() {
        content = DocumentData.new()
    }
    
    /// Make Window Controllers for this document
    
    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
        windowController.contentViewController?.representedObject = content
    }

    /// Read document from selected package in OpenPanel
    ///
    /// Type name will be one of those declared in info.plist UTIs
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        switch typeName {
        case Document.UTI:
            let fw = DocumentFileWrapper(with: fileWrapper)
            content = fw.readDocumentData()
        default:
            throw Errors.unsupportedType
        }
    }
    
    /// Return a DocumentFileWrapper for this document
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        switch typeName {
        case Document.UTI:
            return DocumentFileWrapper( with: content)
        default:
            throw Errors.unsupportedType
        }
    }
}
