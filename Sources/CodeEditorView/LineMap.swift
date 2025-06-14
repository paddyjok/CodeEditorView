//
//  LineMap.swift
//
//
//  Created by Manuel M T Chakravarty on 29/09/2020.
//

import Foundation

/// Keeps track of the character ranges and parametric `LineInfo` for all lines in a string.
///
struct LineMap<LineInfo> {

    /// The character range of the line in the underlying string together with additional information if available.
    ///
    typealias OneLine = (range: NSRange, info: LineInfo?)

    /// One entry per line of the underlying string.
    ///
    var lines: [OneLine] = []

    /// MARK: -
    /// MARK: Initialisation

    /// Direct initialisation for testing.
    ///
    init(lines: [OneLine]) { self.lines = lines }

    /// Initialise a line map with the string to be mapped.
    ///
    init(string: String) { lines.append(contentsOf: linesOf(string: string)) }

    // MARK: -
    // MARK: Queries

    /// Safe lookup of the information pertaining to a given line.
    ///
    /// - Parameter line: The zero-based line number to look up.
    /// - Returns: The description of the given line if it is within the valid range of the line map.
    ///
    func lookup(line: Int) -> OneLine? {
        return (line >= 0 && line < lines.count) ? lines[line] : nil
    }

    /// Return the character range covered by the given range of lines. Safely handles out of bounds situations.
    ///
    /// NB: Line numbers are zero-based.
    ///
    func charRangeOf(lines: Range<Int>) -> NSRange {
        let startRange = lookup(line: lines.first ?? 0)?.range ?? .zero
        let endRange = lookup(line: lines.last ?? 0)?.range ?? .zero
        return NSRange(
            location: startRange.location,
            length: endRange.max - startRange.location
        )
    }

    /// Determine the zero-based line number of the line containing the characters at the given string index. (Safe to be
    /// called with an out of bounds index.)
    ///
    /// - Parameter index: The string index of the characters whose line we want to determine.
    /// - Returns: The zero-based line number containing the indexed character if the index is within the bounds of the
    ///     string.
    ///
    /// - Complexity: This functions asymptotic complexity is logarithmic in the number of lines contained in the line map.
    ///
    func lineContaining(index: Int) -> Int? {
        var lineRange = 0..<lines.count

        while lineRange.count > 1 {

            let middle = lineRange.startIndex + lineRange.count / 2
            if index < lines[middle].range.location {

                lineRange = lineRange.startIndex..<middle

            } else {

                lineRange = middle..<lineRange.endIndex

            }
        }
        if lineRange.count == 0
            || !lines[lineRange.startIndex].range.contains(index)
        {

            return nil

        } else {

            return lineRange.startIndex

        }
    }

    /// Determine the zero-based line number that contains the cursor position specified by the given string index. (Safe
    /// to be called with an out of bounds index.)
    ///
    /// Corresponds to `lineContaining(index:)`, but also handles the index just after the last valid string index — i.e.,
    /// the end-of-string insertion point.
    ///
    /// - Parameter index: The string index of the cursor position whose line we want to determine.
    /// - Returns: The zero-based line number containing the given cursor poisition if the index is within the bounds of
    ///     the string or just beyond.
    ///
    /// - Complexity: This functions asymptotic complexity is logarithmic in the number of lines contained in the line
    ///               map.
    ///
    func lineOf(index: Int) -> Int? {
        if let lastLine = lines.last, lastLine.range.max == index {
            return lines.count - 1
        } else {
            return lineContaining(index: index)
        }
    }

    /// Determine the zero-based line that contains the cursor position specified by the given string index together with
    /// the line position. (Safe to be called with an out of bounds index.)
    ///
    /// - Parameter index: The string index of the cursor position whose line we want to determine.
    /// - Returns: The zero-based line containing the given cursor poisition together with line position if the index is
    ///     within the bounds of the string or just beyond.
    ///
    /// - Complexity: This functions asymptotic complexity is logarithmic in the number of lines contained in the line
    ///               map.
    ///
    func lineAndPositionOf(index: Int) -> (line: Int, position: Int)? {
        guard let line = lineOf(index: index),
            let range = lookup(line: line)?.range
        else { return nil }

        return (line: line, position: index - range.location)
    }

    /// Given a character range, return the smallest zero-based line range that includes the characters. Deal with out of
    /// bounds conditions by clipping to the front and end of the line range, respectively.
    ///
    /// - Parameter range: The character range for which we want to know the line range.
    /// - Returns: The smallest range of lines that includes all characters in the given character range. The start value
    ///     of that range is greater or equal 0.
    ///
    /// There are two special cases:
    /// - If (1) the range is empty, (2) its location (= insertion) at the end of the string, and (3) the text ends on a
    ///   trailing empty line, the result is the trailing line on its own.
    /// - If the character range is of length zero, we return the line of the start location. We do that also if the start
    ///   location is just behind the last character of the text.
    ///
    func linesContaining(range: NSRange) -> Range<Int> {
        let start = range.location < 0 ? 0 : range.location
        let end = range.length <= 0 ? start : range.max - 1
        let startLine = lineOf(index: start)
        let endLine = lineContaining(index: end)
        let lastLine = lines.count - 1
        let lastLineRange = lines[lastLine].range

        if let startLine = startLine {

            if range.length < 0 {
                return startLine..<startLine
            } else if range == lastLineRange {
                return Range<Int>(lastLine...lastLine)
            } else {
                return Range<Int>(startLine...(endLine ?? lastLine))
            }

        } else {

            if range.location < 0 {
                return 0..<0
            } else {
                return lastLine..<lastLine
            }

        }
    }

    /// Given a character range, return the smallest zero-based line range that includes the characters plus maybe a
    /// trailing empty line. Deal with out of bounds conditions by clipping to the front and end of the line range,
    /// respectively.
    ///
    /// - Parameter range: The character range for which we want to know the line range.
    /// - Returns: The smallest range of lines that includes all characters in the given character range. The start value
    ///     of that range is greater or equal 0.
    ///
    /// There are two special cases:
    /// - If the character range extends until the end of the text and the last line is a trailing empty line, that
    ///   trailing empty line is also included in the result. This behaviour distinguished the present function from
    ///   `linesContaining(range:)`, on which it is based.
    /// - If the character range is of length zero, we return the line of the start location. We do that also if the start
    ///   location is just behind the last character of the text.
    ///
    func linesOf(range: NSRange) -> Range<Int> {
        let lastLine = lines.count - 1
        let lastLineRange = lines[lastLine].range

        if range.max == lastLineRange.location && lastLineRange.length == 0 {

            // Range reaches to the end of text => extend 'endLine' to 'lastLine'
            return Range<Int>(
                linesContaining(range: range).startIndex...lastLine
            )

        } else {

            return linesContaining(range: range)

        }
    }

    /// Compute the lines affected by an editing activity.
    ///
    /// - Parameters:
    ///   - editedRange: The character range that was affected by editing (after the edit).
    ///   - delta: The length increase of the edited string (negative if it got shorter).
    /// - Returns: The zero-based range of lines (of the original string) that is affected by the editing action.
    ///
    func linesAffected(by editedRange: NSRange, changeInLength delta: Int) -> Range<Int> {

        if let shiftedRange = editedRange.shifted(endBy: -delta) {

            // To compute the line range, we extend the character range by one extra character. This is crucial as, if the
            // edited range ends on a newline, this may insert a new line break, which means, line *after* the new line break
            // also belongs to the affected lines.
            let oldStringRange = NSRange(
                location: 0,
                length: (lines.last?.range ?? .zero).max
            )
            return linesOf(
                range: extend(range: shiftedRange, clippingTo: oldStringRange)
            )

        } else {
            return 0..<0
        }
    }

    // MARK: -
    // MARK: Editing

    /// Set the info field for the given line (starting from 0).
    ///
    /// - Parameters:
    ///   - line: The zero-based line whose info field ought to be set.
    ///   - info: The new info value for that line.
    ///
    ///   NB: Ignores lines that do not exist.
    ///
    mutating func setInfoOf(line: Int, to info: LineInfo?) {
        guard line < lines.count else { return }

        lines[line] = (range: lines[line].range, info: info)
    }

    /// Update the line map given the specified editing activity of the underlying string. It resets the info field for
    /// each affected line.
    ///
    /// - Parameters:
    ///   - string: The string after editing.
    ///   - editedRange: The character range that was affected by editing (after the edit).
    ///   - delta: The length increase of the edited string (negative if it got shorter).
    ///
    /// NB: The line after the `editedRange` will be updated (and info fields be invalidated) if the `editedRange` ends on
    ///     a newline.
    ///
    mutating func updateAfterEditing(
        string: String,
        range editedRange: NSRange,
        changeInLength delta: Int
    ) {

        // To compute line ranges, we extend all character ranges by one extra character. This is crucial as, if the
        // edited range ends on a newline, this may insert a new line break, which means, we also need to update the line
        // *after* the new line break.
        //
        let nsString = string as NSString
        let newStringRange = NSRange(location: 0, length: nsString.length)
        let oldLinesRange = linesAffected(
            by: editedRange,
            changeInLength: delta
        )
        let extendedEditedRange = extend(
            range: editedRange,
            clippingTo: newStringRange
        )
        let newLinesRange = nsString.lineRange(for: extendedEditedRange)
        let newLinesString = nsString.substring(with: newLinesRange)
        let newLines = linesOf(string: newLinesString).map {
            shift(line: $0, by: newLinesRange.location)
        }

        // If the newly inserted text ends on a new line, we need to remove the empty trailing line in the new lines array
        // unless the range of those new lines extends until the end of the string.
        let dropEmptyNewLine =
            newLines.last?.range.length == 0
            && oldLinesRange.last != lines.count - 1
        let adjustedNewLines = dropEmptyNewLine ? newLines.dropLast() : newLines

        lines.replaceSubrange(oldLinesRange, with: adjustedNewLines)

        // All ranges after the edited range of lines need to be adjusted.
        //
        for i in oldLinesRange.startIndex.advanced(
            by: adjustedNewLines.count
        )..<lines.count {
            lines[i] = shift(line: lines[i], by: delta)
        }
    }

    // MARK: -
    // MARK: Helpers

    /// Shift the range of `line` by `delta`.
    ///
    private func shift(line: OneLine, by delta: Int) -> OneLine {
        return (
            range: NSRange(
                location: line.range.location + delta,
                length: line.range.length
            ), info: line.info
        )
    }

    /// Extract the corresponding array of line ranges out of the given string.
    ///
    private func linesOf(string: String) -> [OneLine] {
        let nsString = string as NSString

        var resultingLines: [OneLine] = []

        // Enumerate all lines in `nsString`, adding them to the `resultingLines`.
        //
        var currentIndex = 0
        while currentIndex < nsString.length {

            let currentRange = nsString.lineRange(
                for: NSRange(location: currentIndex, length: 0)
            )
            resultingLines.append((range: currentRange, info: nil))
            currentIndex = currentRange.max

        }

        // Check if there is an empty last line (due to a linebreak being at the end of the text), and if so, add that
        // extra empty line to the `resultingLines` as well.
        //
        let lastRange = nsString.lineRange(
            for: NSRange(location: nsString.length, length: 0)
        )
        if lastRange.length == 0 {
            resultingLines.append((range: lastRange, info: nil))
        }

        return resultingLines
    }

    /// Extend the `range` by one character, clipped by the `stringRange`, but such that a zero length range after the
    /// end of the string is preserved.
    ///
    private func extend(range: NSRange, clippingTo stringRange: NSRange)
        -> NSRange
    {
        return
            range.location == stringRange.max
            ? NSRange(location: range.location, length: 0)
            : NSIntersectionRange(
                NSRange(location: range.location, length: range.length + 1),
                stringRange
            )
    }
}
