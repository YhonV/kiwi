//
//  DocumentService.swift
//  kiwi
//
//  Created by Cactu on 12-06-26.
//
import UniformTypeIdentifiers

enum DocumentServiceError: Error {
    case securityAccessDenied
}

class DocumentService {
    
    func openDocument(file: URL) throws -> Document {
        var document = Document(fileName: "", content: "", fileURL: nil, isModified: false)
        let gotAccess = file.startAccessingSecurityScopedResource()
        if !gotAccess { throw DocumentServiceError.securityAccessDenied }
        defer { file.stopAccessingSecurityScopedResource()}
        document.fileURL = file
        document.content = try String(contentsOf: file, encoding: .utf8)
        document.fileName = file.deletingPathExtension().lastPathComponent
        return document
    }

    func saveDocument(documentURL: URL, documentContent: String) throws -> Void{
        let url = documentURL
        let gotAccess = url.startAccessingSecurityScopedResource()
        if !gotAccess { throw DocumentServiceError.securityAccessDenied }
        defer { url.stopAccessingSecurityScopedResource()}
        
        try documentContent.write(
            to: url,
            atomically: true,
            encoding: .utf8
        )
    }

    func createDocument() {
        
    }
}

