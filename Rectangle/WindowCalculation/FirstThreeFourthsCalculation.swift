/// FirstThreeFourthsCalculation.swift

import Foundation

class FirstThreeFourthsCalculation: WindowCalculation, OrientationAware {
    /// Personal patch: two thirds of the width at full height, pinned just right of
    /// the SessionBoard panel (plain left two thirds when the board isn't on this screen).
    /// landscapeRect/portraitRect are left as-is because other calculations call them.
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width * 2 / 3.0)
        if let board = sessionBoardFrame(on: visibleFrameOfScreen) {
            rect.origin.x = board.maxX + sessionBoardGap
            rect.size.width = min(rect.width, visibleFrameOfScreen.maxX - rect.origin.x)
        }
        return RectResult(rect, subAction: .leftThreeFourths)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width * 3 / 4.0)
        return RectResult(rect, subAction: .leftThreeFourths)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height * 3 / 4.0)
        rect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.height - rect.height
        return RectResult(rect, subAction: .topThreeFourths)
    }
    
}

