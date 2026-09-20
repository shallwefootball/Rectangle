/// LastThreeFourthsCalculation.swift

import Foundation

class LastThreeFourthsCalculation: WindowCalculation, OrientationAware {

    override func calculateRect(_ params: RectCalculationParameters) -> RectResult {
        let visibleFrameOfScreen = params.visibleFrameOfScreen

        guard Defaults.subsequentExecutionMode.value != .none,
            let last = params.lastAction, let lastSubAction = last.subAction else {
            return orientationBasedRect(visibleFrameOfScreen)
        }

        if lastSubAction == .rightThreeFourths || lastSubAction == .bottomThreeFourths {
            return WindowCalculationFactory.firstThreeFourthsCalculation.orientationBasedRect(visibleFrameOfScreen)
        }
        
        return orientationBasedRect(visibleFrameOfScreen)
    }
    
    func landscapeRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        if let rect = rectBesideSessionBoard(visibleFrameOfScreen) {
            return RectResult(rect, subAction: .rightThreeFourths)
        }
        var rect = visibleFrameOfScreen
        rect.size.width = floor(visibleFrameOfScreen.width * 7 / 8.0)
        rect.origin.x = visibleFrameOfScreen.minX + visibleFrameOfScreen.width - rect.width
        return RectResult(rect, subAction: .rightThreeFourths)
    }
    
    func portraitRect(_ visibleFrameOfScreen: CGRect) -> RectResult {
        if let rect = rectBesideSessionBoard(visibleFrameOfScreen) {
            return RectResult(rect, subAction: .rightThreeFourths)
        }
        var rect = visibleFrameOfScreen
        rect.size.height = floor(visibleFrameOfScreen.height * 7 / 8.0)
        return RectResult(rect, subAction: .bottomThreeFourths)
    }

    /// Personal patch: when the SessionBoard panel sits on the left side of this
    /// screen, fill the space to its right so the board stays visible.
    private func rectBesideSessionBoard(_ visibleFrameOfScreen: CGRect) -> CGRect? {
        guard let board = sessionBoardFrame(on: visibleFrameOfScreen) else { return nil }
        var rect = visibleFrameOfScreen
        rect.origin.x = board.maxX + sessionBoardGap
        rect.size.width = visibleFrameOfScreen.maxX - rect.origin.x
        return rect.width > visibleFrameOfScreen.width / 2 ? rect : nil
    }
}

/// Personal patch: space kept between the SessionBoard panel and a window placed beside it.
let sessionBoardGap: CGFloat = 8

/// Personal patch: bundle id of the side panel K and M make room for.
/// Override without rebuilding:
///   defaults write com.knollsoft.Rectangle sidePanelBundleId -string "com.example.app"
var sidePanelBundleId: String {
    UserDefaults.standard.string(forKey: "sidePanelBundleId") ?? "com.wecouldbe.nook"
}

/// Personal patch: frame of the side panel when it sits on the left side of
/// this screen, in the same coordinates as `visibleFrameOfScreen`.
func sessionBoardFrame(on visibleFrameOfScreen: CGRect) -> CGRect? {
    guard let app = AccessibilityElement(sidePanelBundleId),
          app.isHidden != true else { return nil }
    return app.windowElements?
        .filter({ $0.isMinimized != true })
        .map({ $0.frame.screenFlipped })
        .first(where: { !$0.isNull
            && visibleFrameOfScreen.contains(CGPoint(x: $0.midX, y: $0.midY))
            && $0.midX < visibleFrameOfScreen.midX })
}
