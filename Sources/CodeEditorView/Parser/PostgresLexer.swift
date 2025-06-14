//
//  PostgresLexer.swift
//  SQLParser
//
//  Created by Patrick O'Keeffe on 5/19/21.
//

import Foundation

class PostgresLexer {

    // MARK: - Fields

    private let text: String
    private var currentIndex: String.Index
    private var currentRangeIndex: Int
    private var currentCharacter: Character?
    
    private var keywords: [String: String] = [:]

    private var returnNewLines: Bool
    private var returnWhitespace: Bool = false
    private var returnComments: Bool
    
    init(script: String, keywords: [String: String], returnComments: Bool = false, returnNewLines: Bool = false) {
        self.text = script
        self.keywords = keywords
        self.returnComments = returnComments
        self.returnNewLines = returnNewLines
        currentIndex = text.startIndex
        currentRangeIndex = 0
        currentCharacter = text.isEmpty ? nil : text[text.startIndex]
    }

    // MARK: - Helpers

    private func current(matchesString string: String) -> Bool {
        guard currentCharacter != nil else { return false }

        var peekIndex = currentIndex
        return string.allSatisfy { (m) -> Bool in
            defer {
                if peekIndex < text.endIndex {
                    peekIndex = text.index(after: peekIndex)
                }
            }
            guard let p = peekCharacter(at: peekIndex) else { return false }
            return m == p
        }
    }

    private func next(matchesAny set: [Character]) -> Bool {
        if let p = peek() {
            return set.contains(p)
        }
        return false
    }

    private func afterNext(matchesAny set: [Character]) -> Bool {
        guard currentCharacter != nil else { return false }
        var peekIndex = currentIndex

        //next
        guard peekIndex < text.endIndex else { return false }
        peekIndex = text.index(after: peekIndex)
        //one more
        guard peekIndex < text.endIndex else { return false }
        peekIndex = text.index(after: peekIndex)

        guard let p = peekCharacter(at: peekIndex) else { return false }
        return set.contains(p)
    }

    
    private func skipWhitespace() {
        while let character = currentCharacter, CharacterSet.whitespaces.contains(character.unicodeScalars.first!) || currentCharacter == "\r" {
            advance()
        }
    }

    private func advance() {
        currentIndex = text.index(currentIndex, offsetBy: 1)
        currentRangeIndex += 1
        guard currentIndex < text.endIndex else {
            currentCharacter = nil
            return
        }
        currentCharacter = text[currentIndex]
    }

    private func peek() -> Character? {
        let peekIndex = text.index(currentIndex, offsetBy: 1)

        guard peekIndex < text.endIndex else {
            return nil
        }

        return text[peekIndex]
    }

    private func peekCharacter(at index: String.Index) -> Character? {
        let peekIndex = index
        guard peekIndex < text.endIndex else {
            return nil
        }
        return text[peekIndex]
    }
    
    // MARK: - Parsing helpers

    private func singleLineComment() -> PostgresScannerToken {
        let beginIndex = currentIndex

        while let character = currentCharacter, character != "\n", !character.isNewline {
            advance()
        }
        return PostgresScannerToken(tokenType: .comment, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }
    
    private func multiLineComment() -> PostgresScannerToken {
        let beginIndex = currentIndex
        
        while let character = currentCharacter {
            switch character {
            case "*":
                if current(matchesString: "*/") {
                    advance()
                    advance()
                    return PostgresScannerToken(tokenType: .comment, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
                }
                advance()
                break
            case "\n":
                advance()
                break
            default:
                advance()
            }
        }
        return PostgresScannerToken(tokenType: .comment, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }
    
    private enum NumberState {
        case done
        case whole
        case fractional
        case exponentSign
        case exponent
    }
    
    private func number() -> PostgresScannerToken {
        let beginIndex = currentIndex
        var lexeme = ""
        
        var state: NumberState = .whole
        
        while state != .done {
            if let character = currentCharacter {
                switch state {
                    
                case .whole:
                    switch character {
                    case "0"..."9":
                        lexeme += String(character)
                        advance()
                        
                    case ".":
                        lexeme += String(character)
                        advance()
                        state = .fractional
                        
                    default:
                        state = .done
                    }
                    
                case .fractional:
                    switch character {
                    case "0"..."9":
                        lexeme += String(character)
                        advance()

                    case "e", "E":
                        if next(matchesAny: ["+", "-"]) && afterNext(matchesAny: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"] ) {
                            lexeme += String(character)
                            advance()
                            state = .exponentSign
                        } else {
                            if next(matchesAny: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]) {
                                lexeme += String(character)
                                advance()
                                state = .exponent
                            } else {
                                state = .done
                            }
                        }
                        
                    default:
                        state = .done
                    }
                
                case .exponentSign:
                    switch character {
                    case "+", "-":
                        lexeme += String(character)
                        advance()
                        state = .exponent

                    default:
                        state = .done
                    }
                    
                    
                case .exponent:
                    switch character {
                    case "0"..."9":
                        lexeme += String(character)
                        advance()

                    default:
                        state = .done
                    }

                default:
                    break
                }
            } else {
                state = .done
            }
        }

        return PostgresScannerToken(tokenType: .numberLiteral(value: lexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }

    private func quotedId() -> PostgresScannerToken {
        let beginIndex = currentIndex
        var lexeme = ""
        
        while let character = currentCharacter, character != "]" {
            lexeme += String(character)
            advance()
        }
        if let character = currentCharacter, character == "]" {
            lexeme += String(character)
            advance()

        }

        return PostgresScannerToken(tokenType: .identifier(value: lexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }


    private func id() -> PostgresScannerToken {
        let beginIndex = currentIndex
        var lexeme = ""
        
        while let character = currentCharacter, (CharacterSet.alphanumerics.contains(character.unicodeScalars.first!) || "@_".contains(character)) {
            lexeme += String(character)
            advance()
        }

        if let keyword = keywords[lexeme.lowercased()] {
            return PostgresScannerToken(tokenType: .keyword(value: keyword.lowercased()), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
        }

        return PostgresScannerToken(tokenType: .identifier(value: lexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }

    private func idOrDollarQuotedString() -> PostgresScannerToken {
        let beginIndex = currentIndex
        var lexeme = ""
        
        lexeme += String(currentCharacter!)
        advance()

        outerLoop: while let character = currentCharacter, !(CharacterSet.whitespaces.contains(character.unicodeScalars.first!) || character.isNewline) {
            switch character {
                case "$":
                    lexeme += String(character)
                    advance()
                    break outerLoop

                default:
                    lexeme += String(character)
                    advance()

            }
        }
        
        // if the last character of lexeme is $ - its a string
        if let last = lexeme.last, last == "$" {
            // loop until we find matching lexeme
            var stringLexeme = ""
            
            while let character = currentCharacter {
                if current(matchesString: lexeme) {
                    for _ in 0..<lexeme.count {
                        advance()
                    }
                    return PostgresScannerToken(tokenType: .stringLiteral(value: stringLexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
                } else {
                    stringLexeme += String(character)
                    advance()
                }
            }
        }
        return PostgresScannerToken(tokenType: .identifier(value: lexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }

    
    private func string() -> PostgresScannerToken {
        let beginIndex = currentIndex
        advance()
        var lexeme = ""
        while let character = currentCharacter, !character.isNewline {
            if character == "'" {
                if let p = peek() {
                    if p == "'" {
                        lexeme += String(character)
                        advance()
                        advance()
                    } else {
                        advance()
                        break
                    }
                } else {
                    lexeme += String(character)
                    advance()
                }
            } else {
                lexeme += String(character)
                advance()
            }
        }
        return PostgresScannerToken(tokenType: .stringLiteral(value: lexeme), location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }
    
    private func metaCommand() -> PostgresScannerToken {
        let beginIndex = currentIndex
        
        while let character = currentCharacter, character != "\n", !character.isNewline {
            advance()
        }
        return PostgresScannerToken(tokenType: .metaCommand, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
    }
    
    // MARK: - Public methods
    
    func allTokens() throws -> [PostgresScannerToken]  {
        var tokens: [PostgresScannerToken] = []
            
        var tk = try getNextToken()
        while tk.tokenType != .eof {
            tokens.append(tk)
            tk = try getNextToken()
        }
        tokens.append(tk)
        return tokens
    }

    func getNextToken() throws -> PostgresScannerToken {

        while let currentCharacter = currentCharacter {

            // handle whitespace
            if CharacterSet.whitespaces.contains(currentCharacter.unicodeScalars.first!) || currentCharacter == "\r" {
                skipWhitespace()
                continue
            }

            //handle newline
            if currentCharacter.isNewline {
                let beginIndex = currentIndex
                advance()
                
                if returnNewLines {
                    return PostgresScannerToken(tokenType: .newLine, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
                }
                continue
            }
            
            if currentCharacter == "\\" {
                return metaCommand()
            }
            
            //handle string literal
            if currentCharacter == "'" {
                return string()
            }
            
            //handle number literal
            if CharacterSet.decimalDigits.contains(currentCharacter.unicodeScalars.first!) {
                return number()
            }

            //handle identifier or keyword
            if CharacterSet.alphanumerics.contains(currentCharacter.unicodeScalars.first!) || currentCharacter == "@" {
                return id()
            }
            
            // handle identifier or dollar quoted string
            if currentCharacter == "$" {
                return idOrDollarQuotedString()
            }

            if currentCharacter == "." {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .dot, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "\"" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .doubleQuote, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == ";" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .semicolon, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "," {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .comma, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "+" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .plus, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if current(matchesString: "--") {
                let result = singleLineComment()
                if returnComments {
                    return result
                }
                continue
            }
            
            if currentCharacter == "-" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .minus, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "*" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .star, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if current(matchesString: "/*") {
                let result = multiLineComment()
                if returnComments {
                    return result
                }
                continue
            }
            
            if currentCharacter == "/" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .slash, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "=" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .equals, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == ">" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .greaterThan, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "<" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .lessThan, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "(" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .lparen, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == ")" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .rparen, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }
            
            if currentCharacter == "[" {
                return quotedId()
            }

            if currentCharacter == "%" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .percent, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "#" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .hash, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "&" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .ampersand, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "_" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .underscore, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "^" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .caret, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "~" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .tilde, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == ":" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .colon, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "|" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .pipe, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "`" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .backTick, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "?" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .questionMark, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "!" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .bang, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "{" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .lbrace, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            if currentCharacter == "}" {
                let beginIndex = currentIndex
                advance()
                return PostgresScannerToken(tokenType: .rbrace, location: ScannerLocation(inString: text, startIndex: beginIndex, endIndex: currentIndex))
            }

            throw ScannerError.unexpectedCharacterError(character: currentCharacter)
        }
        return PostgresScannerToken(tokenType: .eof, location: ScannerLocation(inString: text, startIndex: currentIndex, endIndex: currentIndex))
    }
}


