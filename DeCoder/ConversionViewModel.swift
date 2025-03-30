import Foundation
import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class ConversionViewModel: ObservableObject {
    @Published var inputText = ""
    @Published var selectedFormat: ConversionFormat = .morse
    @Published var convertedText = ""
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var recentConversions: [Conversion] = []
    @Published var isReverse = false
    @Published var caesarShift = 3
    @Published var conversionProgress: Double?
    @Published var isProcessingFile = false
    
    struct Conversion: Identifiable {
        let id = UUID()
        let input: String
        let output: String
        let format: ConversionFormat
        let timestamp: Date
        let isReverse: Bool
    }
    
    func convertText() {
        guard !inputText.isEmpty else {
            showError("Please enter some text to convert")
            return
        }
        
        convertedText = selectedFormat.convert(inputText, reverse: isReverse, caesarShift: caesarShift)
        
        // Save to recent conversions
        let conversion = Conversion(
            input: inputText,
            output: convertedText,
            format: selectedFormat,
            timestamp: Date(),
            isReverse: isReverse
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
    
    func processFile(_ url: URL) {
        Task {
            isProcessingFile = true
            conversionProgress = 0
            
            do {
                let outputURL = try await FileProcessor.processFile(
                    at: url,
                    format: selectedFormat,
                    reverse: isReverse,
                    caesarShift: caesarShift
                ) { [weak self] progress in
                    self?.conversionProgress = progress
                }
                
                // Read the processed file content for preview
                let processedText = try FileManager.default.readTextFile(outputURL)
                
                // Save to recent conversions
                let conversion = Conversion(
                    input: "File: \(url.lastPathComponent)",
                    output: "Processed: \(outputURL.lastPathComponent)",
                    format: selectedFormat,
                    timestamp: Date(),
                    isReverse: isReverse
                )
                recentConversions.insert(conversion, at: 0)
                
                // Update the converted text with a preview
                let previewLength = 1000
                if processedText.count > previewLength {
                    convertedText = String(processedText.prefix(previewLength)) + "\n...(file saved)"
                } else {
                    convertedText = processedText
                }
                
            } catch {
                showError("Error processing file: \(error.localizedDescription)")
            }
            
            isProcessingFile = false
            conversionProgress = nil
        }
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