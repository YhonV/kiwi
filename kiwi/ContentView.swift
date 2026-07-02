//
//  ContentView.swift
//  kiwi
//
//  Created by Yhon Vivas on 04-06-26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var document = Document(content: "", fileURL: nil, isModified: false)
    @State private var showFileExplorer: Bool = false
    @State private var errorMessage: String = ""
    @State private var showErrorAlert: Bool = false
    let documentService = DocumentService()

    var body: some View {
        VStack {
            HStack {
                
                // ===== ABRIR DOCUMENTO =====
                Button(action: {
                    showFileExplorer = true
                }){
                    Text("Abrir")
                }
                .fileImporter(
                    isPresented: $showFileExplorer,
                    allowedContentTypes: [.text],
                    allowsMultipleSelection: false) { result in
                        switch result {
                        case .success(let files):
                            do
                            {
                                guard let file = files.first else { return }
                                document = try documentService.openDocument(file: file)
                            } catch
                            {
                                errorMessage = "Error interno, intente nuevamente."
                                showErrorAlert = true
                            }
                        case .failure(_):
                            errorMessage = "Error al abrir el archivo, intente nuevamente."
                            showErrorAlert = true
                        }
                    }
                
                // ===== NUEVO DOCUMENTO =====
                Button(action: {
                    document = Document(content: "", fileURL: nil, isModified: false)
                }){
                    Text("Nuevo documento")
                }
                
                // ===== GUARDAR DOCUMENTO =====
                Button(action: {
                    if let documentURL = document.fileURL {
                        do {
                            try documentService.saveDocument(documentURL: documentURL, documentContent: document.content)
                        } catch {
                            errorMessage = "Error al guardar el documento, intente nuevamente."
                            showErrorAlert = true
                        }
                    } else {
                        errorMessage = "Este documento aún no tiene ubicación. Usa Guardar como."
                        showErrorAlert = true
                    }
                }) {
                    Text("Guardar")
                }
            }
            TextEditor(text: $document.content)
                .font(.custom("SFPro", size: 14))
                .lineSpacing(2)
                .autocorrectionDisabled(true)
        }
        .padding()
        .alert("Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
    }
}

#Preview {
    ContentView()
}
