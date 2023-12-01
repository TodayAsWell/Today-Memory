import Foundation

class SettingPresenter: SettingPresenterInterface, SettingInteractorOutput {
    var view: SettingViewInterface!
    var interactor: SettingInteractorInput!
    var router: SettingRouterInterface!
    
    func viewDidLoad() {
        view.setupNavigationItem()
        view.setupTableView()
        view.setupConstraints()
    }
}
