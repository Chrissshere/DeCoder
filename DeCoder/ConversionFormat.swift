import Foundation

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
}

// MARK: - Conversion Logic
extension ConversionFormat {
    func convert(_ text: String) -> String {
        switch self {
        case .morse:
            return text.map { Self.morseCodeMap[$0] ?? "" }.joined(separator: " ")
        case .binary:
            return text.map { char in
                if let ascii = char.asciiValue {
                    return String(ascii, radix: 2).padding(toLength: 8, withPad: "0", startingAt: 0)
                }
                return ""
            }.joined(separator: " ")
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
} 