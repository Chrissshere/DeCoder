import Foundation
import SwiftUI

@MainActor
final class ConversionViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var selectedFormat: ConversionFormat = .morse
    @Published var convertedText = ""
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var recentConversions: [Conversion] = []
    
    struct Conversion: Identifiable {
        let id = UUID()
        let input: String
        let output: String
        let format: ConversionFormat
        let timestamp: Date
    }
    
    func convertText() {
        guard !inputText.isEmpty else {
            showError("Please enter some text to convert")
            return
        }
        
        convertedText = selectedFormat.convert(inputText)
        
        // Save to recent conversions
        let conversion = Conversion(
            input: inputText,
            output: convertedText,
            format: selectedFormat,
            timestamp: Date()
        )
        recentConversions.insert(conversion, at: 0)
        
        // Keep only the last 10 conversions
        if recentConversions.count > 10 {
            recentConversions.removeLast()
        }
    }
    
    func copyToClipboard() {
        UIPasteboard.general.string = convertedText
    }
    
    func exportConversions() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        return recentConversions.map { conversion in
            """
            Format: \(conversion.format.rawValue)
            Input: \(conversion.input)
            Output: \(conversion.output)
            Date: \(dateFormatter.string(from: conversion.timestamp))
            ----------------------
            """
        }.joined(separator: "\n")
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
} 