//
//  Theme.swift
//
//
//  Created by Manuel M T Chakravarty on 14/05/2021.
//
//  This module defines code highlight themes.

import SwiftUI

/// A code highlighting theme. Different syntactic elements are purely distinguished by colour.
///
/// NB: Themes are `Identifiable`. To ensure that a theme's identity changes when any of its properties is being changed
///     the `id` is updated on setting any property. This makes mutating properties fairly expensive, but it should also
///     not be a particularily frequent operation.
///
public struct Theme: Identifiable {
    public private(set) var id = UUID()

    /// The colour scheme of the theme.
    ///
    public var colourScheme: ColorScheme {
        didSet { id = UUID() }
    }

    /// The name of the font to use.
    ///
    public var fontName: String {
        didSet { id = UUID() }
    }

    /// The point size of the font to use.
    ///
    public var fontSize: CGFloat {
        didSet { id = UUID() }
    }

    /// The default foreground text colour.
    ///
    public var textColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for (all kinds of) comments.
    ///
    public var commentColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for string literals.
    ///
    public var stringColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for character literals.
    ///
    public var characterColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for number literals.
    ///
    public var numberColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for identifiers.
    ///
    public var identifierColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for operators.
    ///
    public var operatorColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for keywords.
    ///
    public var keywordColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for reserved symbols.
    ///
    public var symbolColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for type names (identifiers and operators).
    ///
    public var typeColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for field names.
    ///
    public var fieldColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour for names of alternatives.
    ///
    public var caseColour: OSColor {
        didSet { id = UUID() }
    }

    /// The background colour.
    ///
    public var backgroundColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour of the current line highlight.
    ///
    public var currentLineColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour to use for the selection highlight.
    ///
    public var selectionColour: OSColor {
        didSet { id = UUID() }
    }

    /// The cursor colour.
    ///
    public var cursorColour: OSColor {
        didSet { id = UUID() }
    }

    /// The colour to use if invisibles are drawn.
    ///
    public var invisiblesColour: OSColor {
        didSet { id = UUID() }
    }

    public init(
        colourScheme: ColorScheme,
        fontName: String,
        fontSize: CGFloat,
        textColour: OSColor,
        commentColour: OSColor,
        stringColour: OSColor,
        characterColour: OSColor,
        numberColour: OSColor,
        identifierColour: OSColor,
        operatorColour: OSColor,
        keywordColour: OSColor,
        symbolColour: OSColor,
        typeColour: OSColor,
        fieldColour: OSColor,
        caseColour: OSColor,
        backgroundColour: OSColor,
        currentLineColour: OSColor,
        selectionColour: OSColor,
        cursorColour: OSColor,
        invisiblesColour: OSColor
    ) {
        self.colourScheme = colourScheme
        self.fontName = fontName
        self.fontSize = fontSize
        self.textColour = textColour
        self.commentColour = commentColour
        self.stringColour = stringColour
        self.characterColour = characterColour
        self.numberColour = numberColour
        self.identifierColour = identifierColour
        self.operatorColour = operatorColour
        self.keywordColour = keywordColour
        self.symbolColour = symbolColour
        self.typeColour = typeColour
        self.fieldColour = fieldColour
        self.caseColour = caseColour
        self.backgroundColour = backgroundColour
        self.currentLineColour = currentLineColour
        self.selectionColour = selectionColour
        self.cursorColour = cursorColour
        self.invisiblesColour = invisiblesColour
    }
}

extension Theme: Equatable {

    public static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
}

/// A theme catalog indexing themes by name
///
typealias Themes = [String: Theme]

extension Theme {

    public static var defaultDark: Theme = Theme(
        colourScheme: .dark,
        fontName: "SFMono-Medium",
        fontSize: 13.0,
        textColour: OSColor(red: 0.87, green: 0.87, blue: 0.88, alpha: 1.0),
        commentColour: OSColor(red: 0.51, green: 0.55, blue: 0.59, alpha: 1.0),
        stringColour: OSColor(red: 0.94, green: 0.53, blue: 0.46, alpha: 1.0),
        characterColour: OSColor(
            red: 0.84,
            green: 0.79,
            blue: 0.53,
            alpha: 1.0
        ),
        numberColour: OSColor(red: 0.81, green: 0.74, blue: 0.40, alpha: 1.0),
        identifierColour: OSColor(
            red: 0.41,
            green: 0.72,
            blue: 0.64,
            alpha: 1.0
        ),
        operatorColour: OSColor(red: 0.62, green: 0.94, blue: 0.87, alpha: 1.0),
        keywordColour: OSColor(red: 0.94, green: 0.51, blue: 0.69, alpha: 1.0),
        symbolColour: OSColor(red: 0.72, green: 0.72, blue: 0.73, alpha: 1.0),
        typeColour: OSColor(red: 0.36, green: 0.85, blue: 1.0, alpha: 1.0),
        fieldColour: OSColor(red: 0.63, green: 0.40, blue: 0.90, alpha: 1.0),
        caseColour: OSColor(red: 0.82, green: 0.66, blue: 1.0, alpha: 1.0),
        backgroundColour: OSColor(
            red: 0.16,
            green: 0.16,
            blue: 0.18,
            alpha: 1.0
        ),
        currentLineColour: OSColor(
            red: 0.19,
            green: 0.20,
            blue: 0.22,
            alpha: 1.0
        ),
        selectionColour: OSColor(
            red: 0.40,
            green: 0.44,
            blue: 0.51,
            alpha: 1.0
        ),
        cursorColour: OSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        invisiblesColour: OSColor(
            red: 0.33,
            green: 0.37,
            blue: 0.42,
            alpha: 1.0
        )
    )

    public static var defaultLight: Theme = Theme(
        colourScheme: .light,
        fontName: "SFMono-Medium",
        fontSize: 13.0,
        textColour: OSColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0),
        commentColour: OSColor(red: 0.45, green: 0.50, blue: 0.55, alpha: 1.0),
        stringColour: OSColor(red: 0.76, green: 0.24, blue: 0.16, alpha: 1.0),
        characterColour: OSColor(
            red: 0.14,
            green: 0.19,
            blue: 0.81,
            alpha: 1.0
        ),
        numberColour: OSColor(red: 0.0, green: 0.05, blue: 1.0, alpha: 1.0),
        identifierColour: OSColor(
            red: 0.23,
            green: 0.50,
            blue: 0.54,
            alpha: 1.0
        ),
        operatorColour: OSColor(red: 0.18, green: 0.05, blue: 0.43, alpha: 1.0),
        keywordColour: OSColor(red: 0.63, green: 0.28, blue: 0.62, alpha: 1.0),
        symbolColour: OSColor(red: 0.24, green: 0.13, blue: 0.48, alpha: 1.0),
        typeColour: OSColor(red: 0.04, green: 0.29, blue: 0.46, alpha: 1.0),
        fieldColour: OSColor(red: 0.36, green: 0.15, blue: 0.60, alpha: 1.0),
        caseColour: OSColor(red: 0.18, green: 0.05, blue: 0.43, alpha: 1.0),
        backgroundColour: OSColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
        currentLineColour: OSColor(
            red: 0.93,
            green: 0.96,
            blue: 1.0,
            alpha: 1.0
        ),
        selectionColour: OSColor(
            red: 0.73,
            green: 0.84,
            blue: 0.99,
            alpha: 1.0
        ),
        cursorColour: OSColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),
        invisiblesColour: OSColor(
            red: 0.84,
            green: 0.84,
            blue: 0.84,
            alpha: 1.0
        )
    )
}

extension Theme {

    /// Font object on the basis of the font name and size of the theme.
    ///
    var font: OSFont {
        if fontName.hasPrefix("SFMono-") {

            let weightString = fontName.dropFirst("SFMono-".count)
            let weight: OSFont.Weight
            switch weightString {
            case "UltraLight": weight = .ultraLight
            case "Thin": weight = .thin
            case "Light": weight = .light
            case "Regular": weight = .regular
            case "Medium": weight = .medium
            case "Semibold": weight = .semibold
            case "Bold": weight = .bold
            case "Heavy": weight = .heavy
            case "Black": weight = .black
            default: weight = .regular
            }
            return OSFont.monospacedSystemFont(ofSize: fontSize, weight: weight)

        } else {

            return OSFont(name: fontName, size: fontSize)
                ?? OSFont.monospacedSystemFont(
                    ofSize: fontSize,
                    weight: .regular
                )

        }
    }

    #if os(iOS) || os(visionOS)

        /// Tint colour on the basis of the cursor and selection colour of the theme.
        ///
        var tintColour: UIColor {
            var selectionHue = CGFloat(0.0)
            var selectionSaturation = CGFloat(0.0)
            var selectionBrigthness = CGFloat(0.0)
            var cursorHue = CGFloat(0.0)
            var cursorSaturation = CGFloat(0.0)
            var cursorBrigthness = CGFloat(0.0)

            // TODO: This is awkward...
            selectionColour.getHue(
                &selectionHue,
                saturation: &selectionSaturation,
                brightness: &selectionBrigthness,
                alpha: nil
            )
            cursorColour.getHue(
                &cursorHue,
                saturation: &cursorSaturation,
                brightness: &cursorBrigthness,
                alpha: nil
            )
            return UIColor(
                hue: selectionHue,
                saturation: 1.0,
                brightness: selectionBrigthness,
                alpha: 1.0
            )
        }

    #endif
}
