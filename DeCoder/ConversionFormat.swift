import Foundation
import SwiftUI

public enum ConversionFormat: String, CaseIterable, Identifiable {
    case morse = "Morse Code"
    case binary = "Binary"
    case hex = "Hexadecimal"
    case leetspeak = "Leetspeak"
    case pigLatin = "Pig Latin"
    case braille = "Braille"
    case base64 = "Base64"
    case rot13 = "ROT13"
    case ascii = "ASCII Art"
    case unicode = "Unicode"
    
    case nato = "NATO Phonetic"
    case emoji = "Emoji Text"
    case caesar = "Caesar Cipher"
    case url = "URL Encode"
    case html = "HTML Entities"
    
    public var id: String { self.rawValue }
    
    public var icon: String {
        switch self {
        case .morse: return "dot.radiowaves.right"
        case .binary: return "number"
        case .hex: return "hexagon"
        case .leetspeak: return "textformat.abc"
        case .pigLatin: return "textformat"
        case .braille: return "circle.grid.3x3"
        case .base64: return "base64"
        case .rot13: return "rotate.right"
        case .ascii: return "textformat.alt"
        case .unicode: return "character"
        case .nato: return "phone.circle"
        case .emoji: return "face.smiling"
        case .caesar: return "lock.rotation"
        case .url: return "link"
        case .html: return "chevron.left.forwardslash.chevron.right"
        }
    }
    
    public var description: String {
        switch self {
        case .morse: return "Convert text to Morse code"
        case .binary: return "Convert text to binary"
        case .hex: return "Convert text to hexadecimal"
        case .leetspeak: return "Convert text to Leetspeak"
        case .pigLatin: return "Convert text to Pig Latin"
        case .braille: return "Convert text to Braille patterns"
        case .base64: return "Convert text to Base64"
        case .rot13: return "Rotate text by 13 positions"
        case .ascii: return "Convert text to ASCII art"
        case .unicode: return "Convert to Unicode"
        case .nato: return "Convert to NATO phonetic"
        case .emoji: return "Convert to related emojis"
        case .caesar: return "Apply Caesar cipher shift"
        case .url: return "URL encode/decode text"
        case .html: return "Convert HTML entities"
        }
    }
    
    var supportsReverseConversion: Bool {
        switch self {
        case .morse, .binary, .hex, .base64, .caesar, .url, .html:
            return true
        default:
            return false
        }
    }
}

// MARK: - Conversion Maps
extension ConversionFormat {
    static let morseCodeMap: [Character: String] = [
        "A": ".-", "B": "-...", "C": "-.-.", "D": "-..", "E": ".",
        "F": "..-.", "G": "--.", "H": "....", "I": "..", "J": ".---",
        "K": "-.-", "L": ".-..", "M": "--", "N": "-.", "O": "---",
        "P": ".--.", "Q": "--.-", "R": ".-.", "S": "...", "T": "-",
        "U": "..-", "V": "...-", "W": ".--", "X": "-..-", "Y": "-.--",
        "Z": "--..", "0": "-----", "1": ".----", "2": "..---", "3": "...--",
        "4": "....-", "5": ".....", "6": "-....", "7": "--...", "8": "---..",
        "9": "----.", " ": " ", "a": ".-", "b": "-...", "c": "-.-.", "d": "-..",
        "e": ".", "f": "..-.", "g": "--.", "h": "....", "i": "..", "j": ".---",
        "k": "-.-", "l": ".-..", "m": "--", "n": "-.", "o": "---", "p": ".--.",
        "q": "--.-", "r": ".-.", "s": "...", "t": "-", "u": "..-", "v": "...-",
        "w": ".--", "x": "-..-", "y": "-.--", "z": "--.."
    ]
    
    static let leetspeakMap: [Character: String] = [
        "A": "4", "B": "8", "E": "3", "G": "9", "I": "1",
        "O": "0", "S": "5", "T": "7", "Z": "2",
        "a": "4", "b": "8", "e": "3", "g": "9", "i": "1",
        "o": "0", "s": "5", "t": "7", "z": "2"
    ]
    
    static let brailleMap: [Character: String] = [
        "A": "⠁", "B": "⠃", "C": "⠉", "D": "⠙", "E": "⠑",
        "F": "⠋", "G": "⠛", "H": "⠓", "I": "⠊", "J": "⠚",
        "K": "⠅", "L": "⠇", "M": "⠍", "N": "⠝", "O": "⠕",
        "P": "⠏", "Q": "⠟", "R": "⠗", "S": "⠎", "T": "⠞",
        "U": "⠥", "V": "⠧", "W": "⠺", "X": "⠭", "Y": "⠽",
        "Z": "⠵", " ": " ",
        "a": "⠁", "b": "⠃", "c": "⠉", "d": "⠙", "e": "⠑",
        "f": "⠋", "g": "⠛", "h": "⠓", "i": "⠊", "j": "⠚",
        "k": "⠅", "l": "⠇", "m": "⠍", "n": "⠝", "o": "⠕",
        "p": "⠏", "q": "⠟", "r": "⠗", "s": "⠎", "t": "⠞",
        "u": "⠥", "v": "⠧", "w": "⠺", "x": "⠭", "y": "⠽",
        "z": "⠵"
    ]
    
    static let natoMap: [Character: String] = [
        "A": "Alpha", "B": "Bravo", "C": "Charlie", "D": "Delta",
        "E": "Echo", "F": "Foxtrot", "G": "Golf", "H": "Hotel",
        "I": "India", "J": "Juliet", "K": "Kilo", "L": "Lima",
        "M": "Mike", "N": "November", "O": "Oscar", "P": "Papa",
        "Q": "Quebec", "R": "Romeo", "S": "Sierra", "T": "Tango",
        "U": "Uniform", "V": "Victor", "W": "Whiskey", "X": "X-ray",
        "Y": "Yankee", "Z": "Zulu",
        "0": "Zero", "1": "One", "2": "Two", "3": "Three",
        "4": "Four", "5": "Five", "6": "Six", "7": "Seven",
        "8": "Eight", "9": "Nine",
        " ": "(Space)"
    ]
    
    static let emojiMap: [Character: String] = [
        "A": "🅰️", "B": "🅱️", "C": "©️", "D": "🎯", "E": "📧",
        "F": "🎏", "G": "🎮", "H": "♓️", "I": "ℹ️", "J": "🎷",
        "K": "🔑", "L": "🕒", "M": "Ⓜ️", "N": "📈", "O": "⭕️",
        "P": "🅿️", "Q": "🎯", "R": "®️", "S": "💲", "T": "✝️",
        "U": "⛎", "V": "✌️", "W": "〰️", "X": "❌", "Y": "💹",
        "Z": "💤", " ": "➖",
        "!": "❗️", "?": "❓", ".": "⏺️", ",": "🔸",
        "1": "1️⃣", "2": "2️⃣", "3": "3️⃣", "4": "4️⃣", "5": "5️⃣",
        "6": "6️⃣", "7": "7️⃣", "8": "8️⃣", "9": "9️⃣", "0": "0️⃣"
    ]
    
    static let htmlEntities: [Character: String] = [
        "<": "&lt;", ">": "&gt;", "&": "&amp;", "\"": "&quot;",
        "'": "&apos;", "¢": "&cent;", "£": "&pound;", "¥": "&yen;",
        "€": "&euro;", "©": "&copy;", "®": "&reg;"
    ]
}

// MARK: - Conversion Logic
extension ConversionFormat {
    func convert(_ text: String, reverse: Bool = false, caesarShift: Int = 3) -> String {
        switch self {
        case .morse:
            if reverse {
                return decodeMorse(text)
            }
            return text.map { Self.morseCodeMap[$0] ?? "" }.joined(separator: " ")
            
        case .binary:
            if reverse {
                // Split into 8-bit chunks and convert each to a character
                let binaries = text.split(separator: " ")
                return binaries.compactMap { binary -> String? in
                    // Convert binary string to decimal
                    if let decimal = UInt8(String(binary), radix: 2) {
                        return String(UnicodeScalar(decimal))
                    }
                    return nil
                }.joined()
            } else {
                // Convert each character to 8-bit binary
                return text.map { char -> String in
                    let ascii = Int(char.asciiValue ?? 0)
                    return String(format: "%08d", Int(String(ascii, radix: 2)) ?? 0)
                }.joined(separator: " ")
            }
            
        case .nato:
            return text.uppercased().map { char in
                Self.natoMap[char] ?? String(char)
            }.joined(separator: " ")
            
        case .emoji:
            return text.uppercased().map { char in
                Self.emojiMap[char] ?? String(char)
            }.joined()
            
        case .caesar:
            if reverse {
                return applyCaesarCipher(text, shift: -caesarShift)
            }
            return applyCaesarCipher(text, shift: caesarShift)
            
        case .url:
            if reverse {
                return text.removingPercentEncoding ?? text
            }
            return text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? text
            
        case .html:
            if reverse {
                return decodeHTMLEntities(text)
            }
            return text.map { char in
                Self.htmlEntities[char] ?? String(char)
            }.joined()
            
        case .hex:
            return text.map { char in
                if let ascii = char.asciiValue {
                    return String(ascii, radix: 16).uppercased().padding(toLength: 2, withPad: "0", startingAt: 0)
                }
                return ""
            }.joined(separator: " ")
        case .leetspeak:
            return text.map { Self.leetspeakMap[$0] ?? String($0) }.joined()
        case .pigLatin:
            let words = text.lowercased().split(separator: " ")
            return words.map { word in
                let vowels = "aeiou"
                if let firstVowel = word.firstIndex(where: { vowels.contains($0) }) {
                    let prefix = word[..<firstVowel]
                    let suffix = word[firstVowel...]
                    return String(suffix) + String(prefix) + "ay"
                }
                return String(word) + "ay"
            }.joined(separator: " ")
        case .braille:
            return text.map { Self.brailleMap[$0] ?? String($0) }.joined()
        case .base64:
            if let data = text.data(using: .utf8) {
                return data.base64EncodedString()
            }
            return ""
        case .rot13:
            return text.map { char in
                if char.isLetter {
                    let isUppercase = char.isUppercase
                    let base = isUppercase ? Character("A").asciiValue! : Character("a").asciiValue!
                    let value = char.asciiValue!
                    let rotated = ((value - base + 13) % 26) + base
                    return String(UnicodeScalar(rotated))
                }
                return String(char)
            }.joined()
        case .ascii:
            return text.map { char in
                let upperChar = char.uppercased()
                switch upperChar {
                case "A": return "    /\\    \n   /  \\   \n  /    \\  \n /      \\ \n/        \\"
                case "B": return "|----- \n|     )\n|-----<\n|     )\n|-----'"
                case "C": return "  _____ \n /      \n|       \n \\      \n  -----'"
                case "D": return "|\\    \n| )   \n|  )  \n| )   \n|/    "
                case "E": return "|-----\n|     \n|---- \n|     \n|-----"
                default: return String(char)
                }
            }.joined(separator: "\n")
        case .unicode:
            return text.map { char in
                let scalar = String(char).unicodeScalars.first
                return "U+\(String(scalar?.value ?? 0, radix: 16).uppercased().padding(toLength: 4, withPad: "0", startingAt: 0))"
            }.joined(separator: " ")
        }
    }
    
    private func decodeMorse(_ text: String) -> String {
        // Create a simple reverse mapping with uppercase letters only
        let reverseMorseMap: [String: String] = [
            ".-": "A", "-...": "B", "-.-.": "C", "-..": "D", ".": "E",
            "..-.": "F", "--.": "G", "....": "H", "..": "I", ".---": "J",
            "-.-": "K", ".-..": "L", "--": "M", "-.": "N", "---": "O",
            ".--.": "P", "--.-": "Q", ".-.": "R", "...": "S", "-": "T",
            "..-": "U", "...-": "V", ".--": "W", "-..-": "X", "-.--": "Y",
            "--..": "Z", "-----": "0", ".----": "1", "..---": "2", "...--": "3",
            "....-": "4", ".....": "5", "-....": "6", "--...": "7", "---..": "8",
            "----.": "9", " ": " "
        ]
        
        return text.trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
            .map { code -> String in
                if code.isEmpty {
                    return " "  // Single space for word separation
                }
                return reverseMorseMap[code] ?? "?"  // Use ? for unknown patterns
            }
            .joined()
            .replacingOccurrences(of: "  ", with: " ")  // Clean up multiple spaces
    }
    
    private func decodeBinary(_ text: String) -> String {
        return text.split(separator: " ")
            .compactMap { binaryString -> String? in
                if let decimal = Int(String(binaryString), radix: 2),
                   let scalar = UnicodeScalar(decimal) {
                    return String(scalar)
                }
                return nil
            }
            .joined()
    }
    
    private func applyCaesarCipher(_ text: String, shift: Int) -> String {
        return text.map { char -> String in
            guard char.isLetter else { return String(char) }
            let isUppercase = char.isUppercase
            let base = isUppercase ? Character("A").asciiValue! : Character("a").asciiValue!
            let value = char.asciiValue!
            let shifted = Int(value - base)
            let rotated = ((shifted + shift) % 26 + 26) % 26
            let newValue = UInt8(rotated) + base
            return String(UnicodeScalar(newValue))
        }.joined()
    }
    
    private func decodeHTMLEntities(_ text: String) -> String {
        let reverseHTMLMap = Dictionary(uniqueKeysWithValues: Self.htmlEntities.map { (value: $1, key: String($0)) })
        var result = text
        for (entity, char) in reverseHTMLMap {
            result = result.replacingOccurrences(of: entity, with: char)
        }
        return result
    }
} 