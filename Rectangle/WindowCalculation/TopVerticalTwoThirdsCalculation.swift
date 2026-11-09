/// TopVerticalTwoThirdsCalculation.swift

import Foundation

class TopVerticalTwoThirdsCalculation: WindowCalculation {
    
    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        guard Defaults.subsequentExecutionMode.value != .none,
              let last = params.lastAction, let lastSubAction = last.subAction else {
            return calculateTopTwoThirds(visibleFrameOfScreen)
        }

        if lastSubAction == .topTwoThirds {
            return WindowCalculationFactory.bottomVerticalTwoThirdsCalculation.calculateRect(params)
        }
        
        return calculateTopTwoThirds(visibleFrameOfScreen)
    }
    
    /// Personal patch: take 5/6 of the height instead of 2/3, so a window fills
    /// the screen except for a strip left free at the bottom.
    func calculateTopTwoThirds(_ visibleFrameOfScreen: CGRect) -> RectResult {
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height * 5 / 6.0)
        rect.origin.y = visibleFrameOfScreen.origin.y + visibleFrameOfScreen.height - rect.height
        return RectResult(rect, subAction: .topTwoThirds)
    }
}
