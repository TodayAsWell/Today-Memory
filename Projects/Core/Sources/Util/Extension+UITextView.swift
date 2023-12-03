import UIKit

public extension UITextView {
    @discardableResult
    func setTypoStyle(_ typo: UIFont) -> Self {
        self.font = typo
        return self
    }
}

