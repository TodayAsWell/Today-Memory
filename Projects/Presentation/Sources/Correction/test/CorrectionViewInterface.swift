import Foundation

protocol CorrectionViewInterface: AnyObject {
    func layout()
    func setupConstraints()
    func setupButton()
    func setupNavigationItem()
}
