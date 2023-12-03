import UIKit
import Then
import SnapKit

class FinishPresenter: FinishPresenterInterface, FinishInteractorOutput {
    var view: FinishViewInterface!
    var interactor: FinishInteractorInput!
    var router: FinishRouterInterface!
    
    func viewDidLoad() {
        view.setupNavigationItem()
        view.layout()
    }
}
