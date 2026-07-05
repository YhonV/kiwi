//
//  EditorViewModel.swift
//  kiwi
//
//  Created by Cactu on 05-07-26.
//
import SwiftUI

@Observable
class EditorViewModel {
    var document:               Document   = Document(fileName: "", content: "", fileURL: nil, isModified: false)
    var lastSavedContent:       String     = ""
    var showSaveAsExporter:     Bool       = false
    var errorMessage:           String     = ""
    var showErrorAlert:         Bool       = false
    var documentService                    = DocumentService()
    var displayedFileName:      String { document.fileName.isEmpty ? "Sin titulo": document.fileName }
    
    func newDocument()
    {
        document = Document(fileName: "", content: "", fileURL: nil, isModified: false)
        lastSavedContent = ""
    }
    
    func openDocument(file: URL) throws
    {
        document = try documentService.openDocument(file: file)
        lastSavedContent = document.content
        document.isModified = false
    }
    
    func saveDocument() throws
    {
        print("Llegué al saveDocument")
        if let documentURL = document.fileURL
        {
            do
            {
                print("Guardaré doucmento")
                try documentService.saveDocument(documentURL: documentURL, documentContent: document.content)
                document.isModified = false
                lastSavedContent = document.content
            }
            
        } else
        {
            print("No tengo URL")
            showSaveAsExporter = true
        }
    }
    
    func updateModifiedState(newContent: String)
    {
        document.isModified = newContent != lastSavedContent
    }
    
    func documentWasExported(url: URL)
    {
        document.fileURL = url
        document.fileName = url.deletingPathExtension().lastPathComponent
        lastSavedContent = document.content
        document.isModified = false
    }
    
}
