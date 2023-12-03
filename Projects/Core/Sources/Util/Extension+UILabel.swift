import UIKit

public extension UILabel {
    @discardableResult
    func setTypoStyle(_ typo: UIFont) -> Self {
        self.font = typo
        return self
    }
}
