import Foundation
import UIKit

class CorrectionPresenter: CorrectionPresenterInterface, CorrectionInteractorOutput {
    var view: CorrectionViewInterface!
    var interactor: CorrectionInteractorInput!
    var router: CorrectionRouterInterface!
    
    func viewDidLoad() {
        view.setupNavigationItem()
        view.setupConstraints()
        view.setupButton()
    }
}
