import UIKit
import RxCocoa
import RxSwift
import XCameraKit

open class BaseViewController<T>: UIViewController {
    public let viewModel: T
    public var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds

    public init(_ viewModel: T) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .systemBackground
        self.navigationItem.backButtonTitle = ""
        attribute()
        layout()
    }

    open func attribute() { }

    open func layout() { }

    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
