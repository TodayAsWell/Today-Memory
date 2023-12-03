import Foundation

public extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment:"")
    }
}
