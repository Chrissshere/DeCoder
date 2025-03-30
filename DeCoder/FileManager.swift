import Foundation
import UniformTypeIdentifiers

extension FileManager {
    static let textTypes: [UTType] = [
        .plainText,
        .text,
        .utf8PlainText,
        .utf16PlainText,
        .utf16ExternalPlainText,
        .utf8TabSeparatedText,
        .rtf
    ]
    
    func readTextFile(_ url: URL) throws -> String {
        guard url.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "com.decoder.error", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Unable to access the file. Please grant permission."
            ])
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        return try String(contentsOf: url, encoding: .utf8)
    }
    
    func writeTextFile(_ text: String, to url: URL) throws {
        guard url.startAccessingSecurityScopedResource() else {
            throw NSError(domain: "com.decoder.error", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Unable to access the file. Please grant permission."
            ])
        }
        defer { url.stopAccessingSecurityScopedResource() }
        
        try text.write(to: url, atomically: true, encoding: .utf8)
    }
    
    func createTemporaryFile(withText text: String) throws -> URL {
        let tempDir = NSTemporaryDirectory()
        let fileName = UUID().uuidString + ".txt"
        let fileURL = URL(fileURLWithPath: tempDir).appendingPathComponent(fileName)
        
        try text.write(to: fileURL, atomically: true, encoding: .utf8)
        return fileURL
    }
}

struct BatchConversion {
    let inputText: String
    let format: ConversionFormat
    let isReverse: Bool
    let caesarShift: Int
    
    func convert() -> String {
        format.convert(inputText, reverse: isReverse, caesarShift: caesarShift)
    }
}

class FileProcessor {
    static func processFile(at url: URL,
                          format: ConversionFormat,
                          reverse: Bool = false,
                          caesarShift: Int = 3,
                          progress: @escaping (Double) -> Void) async throws -> URL {
        let text = try FileManager.default.readTextFile(url)
        
        // Split text into chunks for batch processing
        let chunks = text.split(separator: "\n")
        let totalChunks = Double(chunks.count)
        var convertedText = ""
        
        for (index, chunk) in chunks.enumerated() {
            let conversion = BatchConversion(
                inputText: String(chunk),
                format: format,
                isReverse: reverse,
                caesarShift: caesarShift
            )
            
            let converted = conversion.convert()
            convertedText += converted + "\n"
            
            let progressValue = Double(index + 1) / totalChunks
            await MainActor.run {
                progress(progressValue)
            }
        }
        
        // Create output file name
        let originalFileName = url.deletingPathExtension().lastPathComponent
        let outputFileName = "\(originalFileName)_\(format.rawValue)_\(reverse ? "decoded" : "encoded").txt"
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(outputFileName)
        
        try FileManager.default.writeTextFile(convertedText, to: outputURL)
        return outputURL
    }
} 