//
//  ContentView.swift
//  kiwi
//
//  Created by Yhon Vivas on 04-06-26.
//

import SwiftUI
import UniformTypeIdentifiers

struct Document {
    var content: String;
    var fileURL: URL?;
    var isModified: Bool = false;
}

struct ContentView: View {
    @State var currentDocument: Document;
    @State private var showFileExplorer: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                
                // Botón de abrir
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
                        
                        // caso de éxito
                        case .success(let files):
                            guard let file = files.first else { return }
                            let gotAccess = file.startAccessingSecurityScopedResource()
                            if !gotAccess { return }
                            // release access al final del codigo
                            defer { file.stopAccessingSecurityScopedResource()}
                            do {
                                currentDocument.fileURL = file
                                currentDocument.content = try String(contentsOf: file, encoding: .utf8)
                            } catch {
                                print("Error")
                                return
                            }
                        // caso de fallo
                        case .failure(let error):
                            print(error)
                        }
                    }
                
                // Botón de nuevo documento
                Button(action: {
                    currentDocument = Document(content: "", fileURL: nil, isModified: false)
                }){
                    Text("Nuevo documento")
                }
                
                // Botón de guardar
                Button(action: {
                    if let url = currentDocument.fileURL {
                        do {
                            let gotAccess = url.startAccessingSecurityScopedResource()
                            if !gotAccess { return }
                            // release access al terminar el codigo
                            defer { url.stopAccessingSecurityScopedResource()}
                            
                            try currentDocument.content.write(
                                to: url,
                                atomically: true,
                                encoding: .utf8
                            )
                        } catch {
                            print(error)
                        }
                    }
                }) {
                    Text("Guardar")
                }
            }
            TextEditor(text: $currentDocument.content)
                .font(.custom("SFPro", size: 14))
                .lineSpacing(2)
                .autocorrectionDisabled(true)
        }
        .padding()
    }
    
    func doNothing()
    {
        
    }
}

#Preview {
    ContentView(currentDocument: Document(content: "", fileURL: nil, isModified: false))
}
