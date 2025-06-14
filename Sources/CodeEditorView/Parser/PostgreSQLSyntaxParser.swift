//
//  PostgreSQLSyntaxParser.swift
//  TestSTTextView
//
//  Created by Patrick O'Keeffe on 6/11/25.
//

import Foundation

public struct PostgreSQLToken {
    let type: PostgresScannerTokenType
    let range: NSRange
    
    init(type: PostgresScannerTokenType, range: NSRange) {
        self.type = type
        self.range = range
    }
}
