//  Created by Marcin Krzyzanowski
//  https://github.com/krzyzanowskim/STTextView/blob/main/LICENSE.md

import Foundation
import Cocoa

extension STTextView {

    /// Updates the insertion point’s location and optionally restarts the blinking cursor timer.
    open func updateInsertionPointStateAndRestartTimer() {

        selectionView.subviews.removeAll(where: {
            type(of: $0) == Self.insertionPointClass
        })

        if shouldDrawInsertionPoint {
            for textRange in textLayoutManager.textSelections.flatMap(\.textRanges) {
                textLayoutManager.enumerateTextSegments(in: textRange, type: .selection, options: .rangeNotRequired) { ( _, textSegmentFrame, baselinePosition, textContainer) in
                    let highlightFrame = textSegmentFrame.intersection(frame)
                    guard !highlightFrame.isNull else {
                        return true
                    }

                    let insertionView = (Self.insertionPointClass as STInsertionPoint.Type).init(frame: highlightFrame)
                    assert(insertionView.isFlipped)
                    insertionView.insertionPointColor = insertionPointColor

                    if isFirstResponder {
                        insertionView.enable()
                    } else {
                        insertionView.disable()
                    }

                    selectionView.addSubview(insertionView)

                    return true
                }
            }
        }
    }

}
