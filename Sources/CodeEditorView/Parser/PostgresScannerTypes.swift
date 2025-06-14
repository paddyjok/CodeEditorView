//
//  PostgresScannerTypes.swift
//
//
//  Created by Patrick O'Keeffe on 10/13/23.
//

import Foundation

enum PostgresScannerTokenType {
    case eof
    case comment
    case metaCommand
    case newLine
    case lparen
    case rparen
    case lessThan
    case greaterThan
    case at
    case equals
    case slash
    case star
    case minus
    case plus
    case comma
    case semicolon
    case dot
    case quote
    case doubleQuote
    case slparen
    case srparen
    case percent
    case hash
    case ampersand
    case underscore
    case caret
    case tilde
    case dollar
    case colon
    case pipe
    case backTick
    case questionMark
    case bang
    case lbrace
    case rbrace
    //
    case stringLiteral(value: String)
    case identifier(value: String)
    case atIdentifier(value: String)
    case numberLiteral(value: String)
    //
    case keyword(value: String)
    
    
    
    var name: String {
        switch self {
            case .eof:
                return "eof"
            case .comment:
                return "comment"
            case .metaCommand:
                return "metaCommand"
            case .newLine:
                return "newLine"
            case .lparen:
                return "lparen"
            case .rparen:
                return "rparen"
            case .lessThan:
                return "lessThan"
            case .greaterThan:
                return "greaterThan"
            case .at:
                return "at"
            case .equals:
                return "equals"
            case .slash:
                return "slash"
            case .star:
                return "star"
            case .minus:
                return "minus"
            case .plus:
                return "plus"
            case .comma:
                return "comma"
            case .semicolon:
                return "semicolon"
            case .dot:
                return "dot"
            case .quote:
                return "quote"
            case .doubleQuote:
                return "doubleQuote"
            case .slparen:
                return "slparen"
            case .srparen:
                return "srparen"
            case .percent:
                return "percent"
            case .hash:
                return "hash"
            case .ampersand:
                return "ampersand"
            case .underscore:
                return "underscore"
            case .caret:
                return "caret"
            case .tilde:
                return "tilde"
            case .dollar:
                return "dollar"
            case .colon:
                return "colon"
            case .pipe:
                return "pipe"
            case .backTick:
                return "backTick"
            case .questionMark:
                return "questionMark"
            case .bang:
                return "bang"
            case .lbrace:
                return "lbrace"
            case .rbrace:
                return "rbrace"

            case .stringLiteral:
                return "string"
            case .identifier:
                return "identifier"
            case .atIdentifier:
                return "identifier"
            case .numberLiteral:
                return "number"
            case .keyword:
                return "keyword"
        }
    }
}

extension PostgresScannerTokenType: Equatable {
    static func == (lhs: PostgresScannerTokenType, rhs: PostgresScannerTokenType) -> Bool {
        switch (lhs, rhs) {
            case (.eof, .eof):
                return true
            case (.comment, .comment):
                return true
            case (.metaCommand, .metaCommand):
                return true
            case (.newLine, .newLine):
                return true
            case (.lparen, .lparen):
                return true
            case (.rparen, .rparen):
                return true
            case (.lessThan, .lessThan):
                return true
            case (.greaterThan, .greaterThan):
                return true
            case (.at, .at):
                return true
            case (.equals, .equals):
                return true
            case (.slash, .slash):
                return true
            case (.star, .star):
                return true
            case (.minus, .minus):
                return true
            case (.plus, .plus):
                return true
            case (.comma, .comma):
                return true
            case (.semicolon, .semicolon):
                return true
            case (.dot, .dot):
                return true
            case (.quote, .quote):
                return true
            case (.doubleQuote, .doubleQuote):
                return true
            case (.slparen, .slparen):
                return true
            case (.srparen, .srparen):
                return true
            case (.percent, .percent):
                return true
            case (.hash, .hash):
                return true
            case (.ampersand, .ampersand):
                return true
            case (.underscore, .underscore):
                return true
            case (.caret, .caret):
                return true
            case (.tilde, .tilde):
                return true
            case (.dollar, .dollar):
                return true
            case (.colon, .colon):
                return true
            case (.pipe, .pipe):
                return true
            case (.backTick, .backTick):
                return true
            case (.questionMark, .questionMark):
                return true
            case (.bang, .bang):
                return true
            case (.lbrace, .lbrace):
                return true
            case (.rbrace, .rbrace):
                return true
                
            case let (.stringLiteral(left), .stringLiteral(right)):
                return left == right
                
            case let (.identifier(left), .identifier(right)):
                return left.lowercased() == right.lowercased()
                
            case let (.atIdentifier(left), .atIdentifier(right)):
                return left.lowercased() == right.lowercased()
                
            case let (.numberLiteral(left), .numberLiteral(right)):
                return left == right
                
            case let (.keyword(left), .keyword(right)):
                return left.lowercased() == right.lowercased()
                
            default:
                return false
        }
    }
}

extension PostgresScannerTokenType {
//    var precision: Int {
//        switch self {
//                //case .exponent:
//                //    return 9
//            case .plus:
//                return 4
//            case .minus:
//                return 4
//            case .star:
//                return 7
//                //case .floatDiv:
//                //    return 7
//                //case .integerDiv:
//                //    return 6
//                //case .mod:
//                //    return 5
//                //case .concat:
//                //    return 3
//                //case .shl:
//                //    return 2
//                //case .shr:
//                //    return 2
//            case .equals:
//                return 1
//                //case .notEquals:
//                //    return 1
//            case .lessThan:
//                return 1
//                //case .lessThanEquals:
//                //    return 1
//            case .greaterThan:
//                return 1
//                //case .greaterThanEquals:
//                //    return 1
//                //case .not:
//                //    return 0
//                //case .and:
//                //    return 0
//                //case .or:
//                //    return 0
//            default:
//                fatalError("Internal error: Missed case \(self)")
//        }
//    }
//    
//    var unaryPrecision: Int {
//        switch self {
//            case .plus:
//                return 8
//            case .minus:
//                return 8
//            default:
//                fatalError("Internal error: Missed case \(self)")
//        }
//    }
//    
//    var associativity: Associativity {
//        switch self {
//                //case .exponent:
//                //    return .right
//            case .plus:
//                return .left
//            case .minus:
//                return .left
//            case .star:
//                return .left
//                //case .floatDiv:
//                //    return .left
//                //case .integerDiv:
//                //    return .left
//                //case .mod:
//                //    return .left
//                //case .concat:
//                //    return .left
//                //case .shl:
//                //    return .left
//                //case .shr:
//                //    return .left
//            case .equals:
//                return .left
//                //case .notEquals:
//                //    return .left
//            case .lessThan:
//                return .left
//                //case .lessThanEquals:
//                //    return .left
//            case .greaterThan:
//                return .left
//                //case .greaterThanEquals:
//                //    return .left
//                //case .not:
//                //    return .left
//                //case .and:
//                //    return .left
//                //case .or:
//                //    return .left
//            default:
//                fatalError("Internal error: Missed case \(self)")
//        }
//    }
//    
//    var operation: OperationType {
//        switch self {
//                //case .exponent:
//                //    return .exponent
//            case .plus:
//                return .plus
//            case .minus:
//                return .minus
//            case .star:
//                return .mult
//                //case .floatDiv:
//                //    return .floatDiv
//                //case .integerDiv:
//                //    return .integerDiv
//                //case .mod:
//                //    return .mod
//                //case .concat:
//                //    return .concat
//                //case .shl:
//                //    return .shl
//                //case .shr:
//                //    return .shr
//            case .equals:
//                return .equals
//                //case .notEquals:
//                //    return .notEquals
//            case .lessThan:
//                return .lessThan
//                //case .lessThanEquals:
//                //    return .lessThanEquals
//            case .greaterThan:
//                return .greaterThan
//                //case .greaterThanEquals:
//                //    return .greaterThanEquals
//                //case .not:
//                //    return .not
//                //case .and:
//                //    return .and
//                //case .or:
//                //    return .or
//            default:
//                fatalError("Internal error: Missed case \(self)")
//        }
//    }
//    
    var isIdentifier: Bool {
        get {
            switch self {
                case .identifier(_):
                    return true
                default:
                    return false
            }
        }
    }
    
    var isAtIdentifier: Bool {
        get {
            switch self {
                case .atIdentifier(_):
                    return true
                default:
                    return false
            }
        }
    }
    
    var isStringLiteral: Bool {
        get {
            switch self {
                case .stringLiteral(_):
                    return true
                default:
                    return false
            }
        }
    }
    
    var isNumberLiteral: Bool {
        get {
            switch self {
                case .numberLiteral(_):
                    return true
                default:
                    return false
            }
        }
    }
    
    var identifierValue: String {
        get {
            switch self {
                case .identifier(let value):
                    return value
                case .atIdentifier(let value):
                    return value
                default:
                    return ""
            }
        }
    }
    
    var stringLiteralValue: String {
        get {
            switch self {
                case .stringLiteral(let value):
                    return value
                default:
                    return ""
            }
        }
    }
    
    var numberLiteralValue: String {
        get {
            switch self {
                case .numberLiteral(let value):
                    return value
                default:
                    return ""
            }
        }
    }
}

extension PostgresScannerTokenType: CustomStringConvertible {
    var description: String {
        switch self {
            case .eof:
                return "eof"
            case .comment:
                return "comment"
            case .metaCommand:
                return "metacommand"
            case .newLine:
                return "\n"
            case .lparen:
                return "("
            case .rparen:
                return ")"
            case .lessThan:
                return "<"
            case .greaterThan:
                return ">"
            case .at:
                return "@"
            case .equals:
                return "="
            case .slash:
                return "/"
            case .star:
                return "*"
            case .minus:
                return "-"
            case .plus:
                return "+"
            case .comma:
                return ","
            case .semicolon:
                return ";"
            case .dot:
                return "."
            case .quote:
                return "'"
            case .doubleQuote:
                return "\""
            case .slparen:
                return "["
            case .srparen:
                return "]"
            case .percent:
                return "%"
            case .hash:
                return "#"
            case .ampersand:
                return "&"
            case .underscore:
                return "_"
            case .caret:
                return "_"
            case .tilde:
                return "~"
            case .dollar:
                return "$"
            case .colon:
                return ":"
            case .pipe:
                return "|"
            case .backTick:
                return "`"
            case .questionMark:
                return "?"
            case .bang:
                return "!"
            case .lbrace:
                return "{"
            case .rbrace:
                return "}"
                
            case .stringLiteral(value: let value):
                return value
            case .identifier(value: let value):
                return "id:\(value)"
            case .atIdentifier(value: let value):
                return "@id:\(value)"
            case .numberLiteral(value: let value):
                return value
            case .keyword(value: let value):
                return "kw:\(value)"
        }
    }
}

struct PostgresScannerToken {
    let tokenType: PostgresScannerTokenType
    let location: ScannerLocation
    
    init(tokenType: PostgresScannerTokenType, location: ScannerLocation) {
        self.tokenType = tokenType
        self.location = location
    }
}

public struct ScannerLocation : CustomStringConvertible {
    let inString: String
    var startIndex: String.Index
    var endIndex: String.Index
    
    public var description: String {
        if startIndex > endIndex {
            return "{startIndex > endIndex}"
        }
        return "\(NSRange(startIndex..<endIndex, in: inString))"
    }
    
    var text: String {
        get {
            if startIndex > endIndex {
                return "{startIndex > endIndex}"
            }
            return String(inString[startIndex..<endIndex])
        }
    }

    var lineTextFromRange: String {
        get {
            return String(inString[inString.lineRange(for: startIndex..<endIndex)])
        }
    }
    
    var startColumn: Int {
        get {
            let lineRange = inString.lineRange(for: startIndex..<endIndex)
            let column = inString.distance(from: lineRange.lowerBound, to: startIndex)
            return column
        }
    }
    
    var lineNumber: Int {
        get {
            if inString.startIndex > startIndex {
                return -1
            }
            let s = String(inString[inString.startIndex..<startIndex])
            var lineCount = 0
            s.enumerateLines { (_, _) in
                lineCount += 1
            }
            return lineCount
        }
    }
    
    init(inString: String, startIndex: String.Index, endIndex: String.Index) {
        self.inString = inString
        self.startIndex = startIndex
        self.endIndex = endIndex
    }
    
    init(from location: ScannerLocation) {
        self.inString = location.inString
        self.startIndex = location.startIndex
        self.endIndex = location.endIndex
    }

}


enum ScannerError: Error {
    case unexpectedCharacterError(character: Character)
}

extension ScannerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unexpectedCharacterError(let character):
            return "Unrecognized character \(character)"
        }
    }
}
