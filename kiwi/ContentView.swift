//
//  ContentView.swift
//  kiwi
//
//  Created by Yhon Vivas on 04-06-26.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var showFileExplorer:    Bool    = false
    @State private var editorViewModel = EditorViewModel()
    
    var body: some View {
        VStack {
            Text(editorViewModel.document.isModified ? "\(editorViewModel.displayedFileName) *" : editorViewModel.displayedFileName)
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
                                try editorViewModel.openDocument(file: file)
                            } catch
                            {
                                editorViewModel.errorMessage = "Error interno, intente nuevamente."
                                editorViewModel.showErrorAlert = true
                            }
                        case .failure(_):
                            editorViewModel.errorMessage = "Error al abrir el archivo, intente nuevamente."
                            editorViewModel.showErrorAlert = true
                        }
                    }
                
                // ===== NUEVO DOCUMENTO =====
                Button(action: {
                    editorViewModel.newDocument()
                }){
                    Text("Nuevo documento")
                }
                
                // ===== GUARDAR DOCUMENTO =====
                Button(action: {
                    do
                    {
                        try editorViewModel.saveDocument()
                    } catch
                    {
                        editorViewModel.errorMessage = "Error al guardar el documento, intente nuevamente."
                        editorViewModel.showErrorAlert = true
                        editorViewModel.document.isModified = true
                    }
                }) {
                    Text("Guardar")
                }.fileExporter(
                    isPresented: $editorViewModel.showSaveAsExporter,
                    document: TextFileToExport(initialText: editorViewModel.document.content),
                    contentType: .plainText,
                    defaultFilename: editorViewModel.displayedFileName
                ) { result in
                    switch result {
                        case .success(let url):
                            editorViewModel.documentWasExported(url: url)
                        
                        case .failure:
                            editorViewModel.errorMessage = "Error al guardar el documento."
                            editorViewModel.showErrorAlert = true
                    }
                }
            }
            TextEditor(text: $editorViewModel.document.content)
                .font(.custom("SFPro", size: 14))
                .lineSpacing(2)
                .autocorrectionDisabled(true)
                .onChange(of: editorViewModel.document.content) { oldValue, newValue in
                    editorViewModel.updateModifiedState(newContent: newValue)
                }
        }
        .padding()
        .alert("Error", isPresented: $editorViewModel.showErrorAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(editorViewModel.errorMessage)
        }
    }
}

#Preview {
    ContentView()
}
