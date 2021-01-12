//
//  DocumentFileWrapper.swift
//  PackageDocument App
//
//  Created by Tristan Leblanc on 12/01/2021.
//

import Foundation

class DocumentFileWrapper: FileWrapper {
    
    struct Components {
        static let data = "Data"
        static let resources = "Resources"
    }

    override var isDirectory: Bool { return true }

    // Init from document data for subsequent writing
    init(with documentData: DocumentData) {
        super.init(directoryWithFileWrappers: Self.makeFileWrappers(with: documentData))
    }
    
    // Init from a generic file wrapper for subsequent reading
    init(with fileWrapper: FileWrapper) {
        super.init(directoryWithFileWrappers: fileWrapper.fileWrappers ?? [:])
    }
    
    required init?(coder inCoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - Create Sub FileWrappers
    
    static func makeFileWrappers(with documentData: DocumentData) -> [String: FileWrapper] {
        return [
            Components.data: FileWrapper(regularFileWithContents: documentData.string.data(using: .utf8) ?? Data()),
            Components.resources : FileWrapper(directoryWithFileWrappers: resourceFileWrappers(with: documentData))
        ]
        
    }
    
    static func resourceFileWrappers(with documentData: DocumentData) -> [String: FileWrapper] {
        var out = [String: FileWrapper]()
        documentData.resources.forEach {
            out[$0.string] = FileWrapper(regularFileWithContents: $0.string.data(using: .utf8) ?? Data())
        }
        return out
    }
    
    // MARK: - Read Whole Document
    
    func readDocumentData() -> DocumentData {
        let string = readData()
        let resources = readResources()
        return DocumentData(string: string, resources: resources)
    }

    // MARK: - Read Document Atoms

    func readData() -> String  {
        guard let data = fileWrappers?[Components.data]?.regularFileContents else { return "" }
        let string = String(data: data, encoding: .utf8) ?? ""
        print("Read Document Data : \(string)")
        return string
    }

    func readResources() -> [DocumentData.ResourceData]  {
        guard let resourcesWrappers = fileWrappers?[Components.resources]?.fileWrappers else {
            return []
        }
        
        return resourcesWrappers.values.compactMap {
            guard let data = $0.regularFileContents,
                  let string = String(data: data, encoding: .utf8) else { return nil }
            print("Read Resource: \(string)")
            return DocumentData.ResourceData(string: string)
        }
    }
}
