import Foundation
import Combine

class SessionManager: ObservableObject {
    @Published var isSessionExpired: Bool = false

    private let sessionTimeout: TimeInterval = 5 * 60
    private var backgroundTimestamp: Date?

    func recordBackgroundTimestamp() {
        backgroundTimestamp = Date()
    }

    func evaluateSessionTimeout() {
        guard let backgroundTimestamp = backgroundTimestamp else {
            return
        }

        let elapsedTime = Date().timeIntervalSince(backgroundTimestamp)

        if elapsedTime > sessionTimeout {
            isSessionExpired = true
        }
    }
}
