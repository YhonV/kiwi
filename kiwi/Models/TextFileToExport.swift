//
//  TextFileToExport.swift
//  kiwi
//
//  Created by Cactu on 05-07-26.
//
import SwiftUI
import UniformTypeIdentifiers

struct TextFileToExport: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.plainText]
    
    var text: String = "";
    
    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText;
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}
