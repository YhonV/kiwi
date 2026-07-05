//
//  Document.swift
//  kiwi
//
//  Created by Cactu on 12-06-26.
//
import SwiftUI

struct Document {
    var fileName: String;
    var content: String;
    var fileURL: URL?;
    var isModified: Bool = false;
}
