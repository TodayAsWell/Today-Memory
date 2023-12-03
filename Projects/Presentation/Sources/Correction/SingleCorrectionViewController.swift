import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import Core
import TodayKit

class SingleCorrectionViewController: UIViewController, SendDataDelegate, UIGestureRecognizerDelegate, UIViewControllerTransitioningDelegate, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {

    let disposeBag = DisposeBag()
    
    private let controlView = ControlView()
    private let frameView = FrameView()
    private let stickerView = StickerView()
    private var editedFrame: EditedFrame
    
    var delegate: SendDataDelegate?
    
    lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "이전", image: UIImage(systemName: "arrow.uturn.left"), handler: { _ in
                print("이전")
                self.dismiss(animated: true)
            }),
            UIAction(title: "다음", image: UIImage(systemName: "arrow.uturn.right"), handler: { _ in
                print("다음")
            }),
            UIAction(title: "초기화", image: UIImage(systemName: "arrow.clockwise"), handler: { _ in
                print("초기화")
                self.removeAllStickers()
//                self.removeAlltextField()
            }),
            UIAction(title: "설정", image: UIImage(systemName: "gearshape.fill"), handler: { _ in
                print("설정")
                let settingViewController = SettingViewController()
                self.navigationController?.pushViewController(settingViewController, animated: true)
            })
        ]
    }()
    
    lazy var menu: UIMenu = {
        return UIMenu(title: "", options: [], children: menuItems)
    }()
    
    private var mainFrameView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private var userImageView = UIImageView().then {
        $0.image = UIImage(named: "exexImage")
    }
    
    private var exImage = UIImageView().then {
        $0.image = UIImage(named: "ExPolaroid")
    }
    
    private let filterButton = UIButton(type: .system).then {
        $0.setTitle("필터", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let frameButton = UIButton(type: .system).then {
        $0.setTitle("액자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let adjustmentButton = UIButton(type: .system).then {
        $0.setTitle("글자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    private let stickerButton = UIButton(type: .system).then {
        $0.setTitle("스티커", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        $0.layer.cornerRadius = 19
        $0.snp.makeConstraints {
            $0.width.equalTo(75)
            $0.height.equalTo(38)
        }
    }
    
    private let emptyView1 = UIView().then {
        $0.backgroundColor = .white
    }
    
    private let emptyView2 = UIView().then {
        $0.backgroundColor = .white
    }
    
    private var bottomToolBar = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
        $0.backgroundColor = .white
    }
    
//    private var userTextField = UITextField(frame: .zero).then {
//        $0.placeholder = "입력해주세요"
//        $0.borderStyle = .roundedRect
//    }
    
    convenience init(image: UIImage, editedFrame: EditedFrame) {
        self.init(editedFrame: editedFrame)
        userImageView.image = image
    }

    init(editedFrame: EditedFrame) {
        self.editedFrame = editedFrame
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let correctionViewController = segue.destination as? SingleCorrectionViewController {
            correctionViewController.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addTextToExImage))
//        exImage.addGestureRecognizer(tapGestureRecognizer)
        exImage.isUserInteractionEnabled = true
        
        setupNavigationItem()
        layout()
        setupButton()
        setupConstraints()
        observeTextField()
//        userTextField.delegate = self
    }
    
    func layout() {
        view.addSubview(mainFrameView)
        view.addSubview(userImageView)
        view.addSubview(exImage)
//        view.addSubview(userTextField)
        
        mainFrameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(494)
            $0.height.equalTo(648)
        }
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top).offset(30)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.height.equalTo(462.0)
            $0.width.equalTo(443.0)
        }
        
        exImage.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.width.equalTo(504)
            $0.height.equalTo(648)
        }
        
//        userTextField.snp.makeConstraints {
//            $0.centerY.equalTo(userImageView.snp.centerY).offset(300.0)
//            $0.centerX.equalTo(userImageView.snp.centerX)
//            $0.height.equalTo(50.0)
//            $0.width.equalTo(200.0)
//        }
        
        view.addSubview(bottomToolBar)
        view.addSubview(emptyView1)
        view.addSubview(emptyView2)
        
        bottomToolBar.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(100.0)
        }
        
        bottomToolBar.addArrangedSubview(emptyView1)
        bottomToolBar.addArrangedSubview(filterButton)
        bottomToolBar.addArrangedSubview(frameButton)
        bottomToolBar.addArrangedSubview(adjustmentButton)
        bottomToolBar.addArrangedSubview(stickerButton)
        bottomToolBar.addArrangedSubview(emptyView2)
        
        emptyView1.snp.makeConstraints {
            $0.width.equalTo(emptyView2)
        }
        
        emptyView2.snp.makeConstraints {
            $0.width.equalTo(emptyView1)
        }
    }
    
    func setupConstraints() {
        frameView.delegate = self
        stickerView.delegate = self
            
        view.backgroundColor = TodayKitAsset.Colors.f6F6F8.color
    }
    
    func setupButton() {
        filterButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.toggleButton(owner.filterButton)
                owner.applyFilter()
                owner.deselectButtons(except: owner.filterButton)
            })
            .disposed(by: disposeBag)
        
        frameButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.toggleButton(owner.frameButton)
                owner.applyFrame()
                owner.deselectButtons(except: owner.frameButton)
                owner.showFrameViewSelectionView()
            })
            .disposed(by: disposeBag)
        
        adjustmentButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.toggleButton(owner.adjustmentButton)
                owner.adjustPhoto()
                owner.deselectButtons(except: owner.adjustmentButton)
                owner.showFilterSelectionView()
            })
            .disposed(by: disposeBag)
        
        stickerButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.toggleButton(owner.stickerButton)
                owner.applySticker()
                owner.deselectButtons(except: owner.stickerButton)
                owner.showStickerViewSelectionView()
            })
            .disposed(by: disposeBag)
    }
    
    private func observeTextField() {
//        userTextField.rx.text.orEmpty
//            .map { $0.count > 10 }
//            .distinctUntilChanged()
//            .subscribe(onNext: { [weak self] isWarning in
//                self?.showWarning(isWarning)
//            })
//            .disposed(by: disposeBag)
    }
    
    private func showWarning(_ isWarning: Bool) {
        if isWarning {
            print("경고: 텍스트가 10자를 초과하였습니다.")
        } else {
            print("경고 메시지 숨기기")
        }
    }
    
    func setupNavigationItem() {
        title = "보정"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark"))
        navigationItem.rightBarButtonItem?.tintColor = TodayKitAsset.Colors.baa7E7.color
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("네비게이션 버튼이 클릭되었습니다.")
                let editedFrame = EditedFrame(mainFrameView: self.mainFrameView, userImageView: self.userImageView, exImage: self.exImage)
                let finishVC = SingleFinishViewController(editedFrame: editedFrame)
                
                guard let navigationController = self.navigationController else {
                    fatalError("Navigation controller not found.")
                }

                navigationController.pushViewController(finishVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                                menu: menu)
    }
    
    func toggleButton(_ button: UIButton?) {
        button?.isSelected = !(button?.isSelected ?? false)
        button?.tintColor = button?.isSelected == true ? .black : nil
    }
    
    func deselectButtons(except selectedButton: UIButton?) {
        let buttonsToDeselect = [filterButton, frameButton, adjustmentButton, stickerButton].filter { $0 != selectedButton }
        buttonsToDeselect.forEach { $0?.isSelected = false }
        buttonsToDeselect.forEach { $0?.backgroundColor = .clear }
    }
    
    func applyFilter() {
        print("필터 버튼이 탭되었습니다.")
        hideFameViewSelectionView()
        hideStickerSelectionView()
        hideControlSelectionView()
    }
    
    func applyFrame() {
        print("액자 버튼이 탭되었습니다.")
        hideControlSelectionView()
        hideStickerSelectionView()
    }
    
    func adjustPhoto() {
        print("조정 버튼이 탭되었습니다.")
        hideFameViewSelectionView()
        hideStickerSelectionView()
    }
    
    func applySticker() {
        print("스티커 버튼이 탭되었습니다.")
        hideControlSelectionView()
        hideFameViewSelectionView()
    }
    
    private func showFilterSelectionView() {
        controlView.alpha = 0.0
        view.addSubview(controlView)
        view.bringSubviewToFront(bottomToolBar)
        
        controlView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250)
        }
        
        controlView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.controlView.alpha = 1.0
        self.controlView.transform = CGAffineTransform.identity
    }
    
    private func showFrameViewSelectionView() {
        frameView.alpha = 0.0
        view.addSubview(frameView)
        view.bringSubviewToFront(bottomToolBar)
        
        frameView.snp.makeConstraints {
            $0.left.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250.0)
        }
        
        frameView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.frameView.alpha = 1.0
        self.frameView.transform = CGAffineTransform.identity
    }
    
    private func showStickerViewSelectionView() {
        stickerView.alpha = 0.0
        view.addSubview(stickerView)
        view.bringSubviewToFront(stickerView)
        
        stickerView.snp.makeConstraints {
            $0.left.trailing.bottom.equalToSuperview()
            $0.height.equalTo(250.0)
        }
        
        stickerView.transform = CGAffineTransform(translationX: 0, y: 300)
        
        self.stickerView.alpha = 1.0
        self.stickerView.transform = CGAffineTransform.identity
    }
    
    private func hideFameViewSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.frameView.alpha = 0.0
        } completion: { _ in
            self.frameView.removeFromSuperview()
        }
    }
    
    private func hideControlSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.controlView.alpha = 0.0
        } completion: { _ in
            self.controlView.removeFromSuperview()
        }
    }
    
    private func hideStickerSelectionView() {
        UIView.animate(withDuration: 0.3) {
            self.stickerView.alpha = 0.0
        } completion: { _ in
            self.stickerView.removeFromSuperview()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let words = newText.split(separator: " ")

        return words.count <= 10
    }
}

extension SingleCorrectionViewController {
    // > 스티커 삭제 (꾹 눌러서 삭제)
    @objc func longPress(_ gesture : UILongPressGestureRecognizer){
        if gesture.state != .ended { return }
        
        let alert = UIAlertController(title: "해당 스티커를 삭제하시겠습니까?".localized(), message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "삭제".localized(), style: .destructive) {_ in
            gesture.view?.removeFromSuperview()}
        alert.addAction(ok)
        alert.addAction(UIAlertAction(title: "취소".localized(), style: .cancel) { (cancel) in})
        self.present(alert, animated: true, completion: nil)
    }
    
    // 스티커 위치조절
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        guard let gestureView = gesture.view else {
            return
        }
        
        gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y + translation.y)
        gesture.setTranslation(.zero, in: view)
    }

    
    // 스티커 크기 조절
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        guard let gestureView = gesture.view else {
          return
        }
        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y:gesture.scale)
        gesture.scale = 1
    }
    
    // 스티커 회전
    @objc func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        guard let gestureView = gesture.view else { return }
        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }
    
    // 동시에 여러 움직임 인식 가능
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func sendData(image: UIImage) {
        let imageSticker = UIImageView(image: image)
        let stickerSize = CGSize(width: 200, height: 200)
        let stickerOrigin = CGPoint(x: exImage.bounds.midX - stickerSize.width/2, y: exImage.bounds.midY - stickerSize.height/2)
        imageSticker.frame = CGRect(origin: stickerOrigin, size: stickerSize)
        imageSticker.image = image
        imageSticker.isUserInteractionEnabled = true
        imageSticker.contentMode = .scaleAspectFit
            
        self.exImage.addSubview(imageSticker)
        self.exImage.isUserInteractionEnabled = true
        self.exImage.clipsToBounds = true
            
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(_:)))
        let rotateGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(handleRotateGesture(_:)))
        let removeGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        
        [panGesture, pinchGesture, rotateGesture, removeGesture].forEach {
            $0.delegate = self
            imageSticker.addGestureRecognizer($0)
        }
    }

    func removeAllStickers() {
        for view in exImage.subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
    }
}

extension SingleCorrectionViewController: FrameViewDelegate {
    func didSelectFrameImage(image: UIImage) {
        exImage.image = image
    }
}

//extension SingleCorrectionViewController {
//    @objc func addTextToExImage() {
//        let textField = UITextField(frame: CGRect(x: exImage.bounds.midX - 100, y: exImage.bounds.midY - 15, width: 200, height: 30))
//        textField.center = exImage.convert(exImage.center, from: exImage.superview)
//        textField.borderStyle = .roundedRect
//        textField.placeholder = "텍스트를 입력하십시오."
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTextFieldPanGesture(_:)))
//        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handleTextFieldPinchGesture(_:)))
//        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleTextFieldRotateGesture(_:)))
//        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleTextFieldLongPressGesture(_:)))
//
//        [panGesture, pinchGesture, rotateGesture, longPressGesture].forEach {
//            $0.delegate = self
//            textField.addGestureRecognizer($0)
//        }
//
//        exImage.addSubview(textField)
//    }
//
//    @objc func handleTextFieldPanGesture(_ gesture: UIPanGestureRecognizer) {
//        let translation = gesture.translation(in: exImage)
//
//        guard let gestureView = gesture.view else {
//            return
//        }
//
//        let newX = gestureView.center.x + translation.x
//        let newY = gestureView.center.y + translation.y
//
//        let minX = gestureView.frame.width / 2
//        let minY = gestureView.frame.height / 2
//        let maxX = exImage.bounds.width - minX
//        let maxY = exImage.bounds.height - minY
//
//        gestureView.center = CGPoint(x: min(max(minX, newX), maxX), y: min(max(minY, newY), maxY))
//        gesture.setTranslation(.zero, in: exImage)
//
//    }
//
//    @objc func handleTextFieldPinchGesture(_ gesture: UIPinchGestureRecognizer) {
//        guard let gestureView = gesture.view else {
//            return
//        }
//
//        //현재 되지 않음
//        gestureView.transform = gestureView.transform.scaledBy(x: gesture.scale, y: gesture.scale)
//        gesture.scale = 1
//    }
//
//    @objc func handleTextFieldRotateGesture(_ gesture: UIRotationGestureRecognizer) {
//        guard let gestureView = gesture.view else {
//            return
//        }
//
//        gestureView.transform = gestureView.transform.rotated(by: gesture.rotation)
//        gesture.rotation = 0
//    }
//
//    @objc func handleTextFieldLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
//        if gesture.state != .ended {
//            return
//        }
//
//        let alert = UIAlertController(title: "해당 텍스트를 삭제하시겠습니까?", message: "", preferredStyle: .alert)
//        let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
//            gesture.view?.removeFromSuperview()
//        }
//        alert.addAction(ok)
//        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    func removeAlltextField() {
//        for view in exImage.subviews {
//            if view is UIImageView || view is UITextField {
//                view.removeFromSuperview()
//            }
//        }
//    }
//
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//}
