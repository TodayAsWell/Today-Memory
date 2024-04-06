import UIKit
import PhotosUI
import RxCocoa
import RxSwift
import SnapKit
import Then
import CoreMotion
import AVFoundation
import XCameraKit
import TodayKit

var takenImage = UIImage()

public class MainCameraViewController: UIViewController, UINavigationControllerDelegate {
    
    let disposeBag = DisposeBag()
    
    private var cameraView: XCamera!
    
    var isOn = false
    var gridOn = false
    var touchShootOn = false
    
    var soundID:SystemSoundID = 0
    var soundURL: URL?
    
    var captureCount = 0
    
    var motionManager: CMMotionManager!
    var currentAngleH: Float = 0.0
    var currentAngleY: Float = 0.0
    var isSkyShot = false
    
    var audioPlayer: AVAudioPlayer?

    let soundFileName = "Sounds"
    
    private var timer: Timer?
    private var timerCount: Int = 5
    
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    lazy var menuItems: [UIAction] = {
        return [
            UIAction(title: "그리드", image: UIImage(systemName: "arrow.uturn.left"), handler: { _ in
                print("그리드 추가")
            }),
            UIAction(title: "화면 터치 촬영", image: UIImage(systemName: "hand.point.up.left.fill"), handler: { _ in
                self.ellipsisButtonTap()
            }),
            UIAction(title: "5초 타이머", image: UIImage(systemName: "arrow.clockwise"), handler: { _ in
                self.startTimer()
            }),
            
            UIAction(title: "5초씩 4장 촬영", image: UIImage(systemName: "arrow.clockwise"), handler: { _ in
                self.startTimer1()
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
    
    private let filterSelectionView = FilterSelectionView()
    private let styleSelectionView = StyleSelectionView()
    
    var appliedStyleImageView: UIImageView?
    
    
    private let stackView = UIStackView().then {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            $0.axis = .horizontal
            $0.spacing = 80.0
            $0.alignment = .center
        } else {
            $0.axis = .horizontal
            $0.spacing = 40.0
            $0.alignment = .center
        }
        
    }
    
    private lazy var underWarningTitle = UILabel().then {
        $0.text = "화면을 띄워주세요!"
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
    }
    
    private let centerButton = UIButton(type: .system).then {
        let image = UIImage(named: "centerButton")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        //        $0.layer.cornerRadius = 45.0
        //        $0.layer.borderWidth = 2
        //        $0.layer.borderColor = UIColor.white.cgColor
    }
    
    let correctionButton = UIButton(type: .system).then {
        let image = UIImage(named: "correctionImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let styleButton = UIButton(type: .system).then {
        let image = UIImage(named: "StyleImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let effectButton = UIButton(type: .system).then {
        let image = UIImage(named: "EffectImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    let filterButton = UIButton(type: .system).then {
        let image = UIImage(named: "FilterImage")
        $0.setBackgroundImage(image, for: UIControl.State.normal)
        $0.layer.cornerRadius = 8.0
    }
    
    private let toggleButtonStackView = UIStackView().then {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .center
        } else {
            $0.axis = .horizontal
            $0.spacing = 20.0
            $0.alignment = .center
        }
    }
    
    private let pictureToggleButton = UIButton().then {
        $0.setTitle("사진", for: .normal)
        $0.setTitleColor(TodayKitAsset.Colors.white.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = TodayKitAsset.Colors.baa7E7.color
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }
    
    private let videoToggleButton = UIButton().then {
        $0.setTitle("동영상", for: .normal)
        $0.setTitleColor(TodayKitAsset.Colors.gray4.color, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15.0, weight: .bold)
        $0.backgroundColor = TodayKitAsset.Colors.white.color
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        $0.layer.cornerRadius = 19.0
    }
    
    private let navCenterButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "aspectRatioButton"), for: .normal)
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        cameraView = XCamera(frame: CGRect(x: 0, y: 0, width: 350, height: 480))
        configureNavigationItems()
        configureStackView()
        bindAction()
        layout()
        
        cameraView.setAspectRatio(.full)
        cameraView.setBackgroundColor(.white)
        cameraView.setFlashMode(.off)
        cameraView.setCameraPosition(.back)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        cameraView.addGestureRecognizer(pinchGesture)
        
        cameraView.startRunning()
        
        filterSelectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 270)
        styleSelectionView.frame = CGRect(x: 0, y: view.frame.height, width: view.frame.width, height: 270)
        
        setupUI()
        configureDeviceMotion()
        
//        self.navigationItem.titleView = navCenterButton
//        navCenterButton.addTarget(self, action: #selector(navCenterButtonTapped), for: .touchUpInside)
        
        styleSelectionView.delegate = self
    }
    
//    @objc func navCenterButtonTapped() {
//        print("네비게이션 가운데 버튼이 눌렸습니다.")
//        let imageToPrint = UIImage(named: "ExPolaroidx")!
//        self.cameraView.printImageAsPDF(image: imageToPrint)
//    }
    
    func configureDeviceMotion() {
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdates(using: .xArbitraryZVertical, to: .main, withHandler: { (motion, error) in
            guard let deviceMotion = motion else { return }
            
            let attitude = deviceMotion.attitude
            let x = attitude.roll * (180 / .pi)
            let roundedX = Float(round(x * 100)) / 100.0
            let currentAngleY = attitude.pitch * (180 / .pi)
            
            self.currentAngleH = roundedX * 90
            
            if (-90 < self.currentAngleH && self.currentAngleH < 90
                 && -15 < currentAngleY && currentAngleY < 15) {
                
                self.view.subviews.forEach { subview in
                    if subview != self.centerButton && subview != self.cameraView {
                        if self.view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) == nil {
                            let startColor = UIColor(red: 151 / 255, green: 149 / 255, blue: 240 / 255, alpha: 1.0).cgColor
                            let endColor = UIColor(red: 210 / 255, green: 179 / 255, blue: 224 / 255, alpha: 1.0).cgColor
                            
                            let gradientLayer = CAGradientLayer()
                            
                            gradientLayer.frame = self.view.bounds
                            
                            gradientLayer.colors = [startColor, endColor]
                            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
                            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
                            
                            self.view.layer.insertSublayer(gradientLayer, at: 0)
                        }
                        
                        self.navigationItem.rightBarButtonItem?.tintColor = .white
                        self.navigationItem.leftBarButtonItem?.tintColor = .white
                        
                        self.styleButton.isHidden = true
                        self.correctionButton.isHidden = true
                        self.effectButton.isHidden = true
                        self.filterButton.isHidden = true
                        self.toggleButtonStackView.isHidden = true
                        
                        self.centerButton.setBackgroundImage(UIImage(named: "180Button"), for: UIControl.State.normal)
                        
                        self.view.addSubview(self.underWarningTitle)
                        
                        self.underWarningTitle.snp.makeConstraints {
                            $0.top.equalTo(self.centerButton.snp.top).offset(-40.0)
                            $0.centerX.equalToSuperview()
                        }
                    }
                }
            } else {
                
                self.view.subviews.forEach { subview in
                    if subview != self.centerButton && subview != self.cameraView {
                        
                        if let gradientLayer = self.view.layer.sublayers?.first(where: { $0 is CAGradientLayer }) {
                            gradientLayer.removeFromSuperlayer()
                        }
                        
                        self.navigationItem.rightBarButtonItem?.tintColor = .black
                        self.navigationItem.leftBarButtonItem?.tintColor = .black
                        
                        self.view.backgroundColor = .white
                        
                        self.styleButton.isHidden = false
                        self.correctionButton.isHidden = false
                        self.effectButton.isHidden = false
                        self.filterButton.isHidden = false
                        self.toggleButtonStackView.isHidden = false
                        
                        self.underWarningTitle.removeFromSuperview()
                        
                        self.centerButton.setBackgroundImage(UIImage(named: "centerButton"), for: UIControl.State.normal)
                    }
                }
            }
        })
    }
    
    @objc func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        
        let zoomFactor = cameraView.handleZoomGesture(pinchGesture: gesture)
        print("Zoom factor: \(zoomFactor)")
    }
    
    @objc func timerDidFire() {
        if timerCount > 0 {
            DispatchQueue.main.async {
                self.showTimerCount(self.timerCount)
            }
            timerCount -= 1
        } else {
            stopTimer()
            capturePhotoWithTimer()
            hideTimerCount()
        }
    }

    func startTimer() {
        stopTimer()
        timerCount = 5
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire), userInfo: nil, repeats: true)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerCount = 5
    }

    func showTimerCount(_ count: Int) {
        let countLabel = UILabel()
        countLabel.text = "\(count)"
        countLabel.font = UIFont.systemFont(ofSize: 100, weight: .bold)
        countLabel.textColor = .white
        countLabel.textAlignment = .center
        countLabel.alpha = 0.8
        countLabel.tag = 1001

        if let existingLabel = cameraView.viewWithTag(1001) as? UILabel {
            existingLabel.removeFromSuperview()
        }
        cameraView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: cameraView.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: cameraView.centerYAnchor)
        ])
    }
    
    func hideTimerCount() {
        if let existingLabel = cameraView.viewWithTag(1001) as? UILabel {
            existingLabel.removeFromSuperview()
        }
    }


    func capturePhotoWithTimer() {
        cameraView.capturePhoto { result in
            switch result {
            case .success(let image):
                print("사진 저장")
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            case .failure(let error):
                print("저장 실패 \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.hideTimerCount()
        }
    }
    
    @objc func timerDidFire1() {
        if timerCount > 0 {
            DispatchQueue.main.async {
                self.showTimerCount(self.timerCount)
            }
            timerCount -= 1
        } else {
            captureCount += 1
            if captureCount <= 4 {
                capturePhotoWithTimer()
            } else {
                stopTimer()
                hideTimerCount()
            }
            timerCount = 5
        }
    }

    func startTimer1() {
        stopTimer()
        timerCount = 5
        captureCount = 0
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerDidFire1), userInfo: nil, repeats: true)
    }

    func capturePhotoWithTimer1() {
        cameraView.capturePhoto { result in
            switch result {
            case .success(let image):
                print("사진 저장")
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            case .failure(let error):
                print("저장 실패 \(error)")
            }
        }
        
        DispatchQueue.main.async {
            self.hideTimerCount()
        }
    }
    
    public func configureNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.triangle.2.circlepath"), style: .plain, target: self, action: #selector(backButtonTap(_:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                                                menu: menu)
    }
    
    private func configureButtonContainer(button: UIButton, label: UILabel, text: String) -> UIStackView {
        let buttonContainer = UIStackView()
        buttonContainer.axis = .vertical
        buttonContainer.alignment = .center
        buttonContainer.spacing = 0.0
        button.layer.cornerRadius = 8.0
        button.snp.makeConstraints {
            $0.width.height.equalTo(48)
        }
        
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .center
        
        buttonContainer.addArrangedSubview(button)
        buttonContainer.addArrangedSubview(label)
        
        return buttonContainer
    }
    
    
    private func configureStackView() {
        
        let correctionButton = correctionButton
        let correctionLabel = UILabel()
        
        let correctionLabelButtonContainer = configureButtonContainer(button: correctionButton, label: correctionLabel, text: "보정")
        
        let styleButton = styleButton
        let styleLabel = UILabel()
        
        let styleLabelButtonContainer = configureButtonContainer(button: styleButton, label: styleLabel, text: "스타일")
        
        
        let effectButton = effectButton
        let effectLabel = UILabel()
        
        let effectLabelButtonContainer = configureButtonContainer(button: effectButton, label: effectLabel, text: "효과")
        
        let filterButton = filterButton
        let filterLabel = UILabel()
        
        let filterButtonContainer = configureButtonContainer(button: filterButton, label: filterLabel, text: "필터")
        
        
        stackView.addArrangedSubview(correctionLabelButtonContainer)
        stackView.addArrangedSubview(styleLabelButtonContainer)
        stackView.addArrangedSubview(centerButton)
        stackView.addArrangedSubview(effectLabelButtonContainer)
        stackView.addArrangedSubview(filterButtonContainer)
        stackView.insertArrangedSubview(centerButton, at: 2)
        
        stackView.arrangedSubviews.forEach { arrangedSubview in
            guard let buttonContainer = arrangedSubview as? UIStackView else { return }
            buttonContainer.alignment = .center
            buttonContainer.distribution = .fill
        }
    }
    
    private func setupUI() {
        view.addSubview(filterSelectionView)
        view.addSubview(styleSelectionView)
        
        correctionButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                
                let actionSheet = UIAlertController(title: "보정 모드", message: "아래 모드 중 선택해주세요", preferredStyle: .actionSheet)

                if let popoverController = actionSheet.popoverPresentationController {
                    popoverController.sourceView = self.view
                    popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                    popoverController.permittedArrowDirections = []
                }

                actionSheet.addAction(UIAlertAction(title: "인생 네컷", style: .default, handler: {(ACTION:UIAlertAction) in
                    print("인생 네컷")
                    
                    var config = PHPickerConfiguration(photoLibrary: .shared())
                    config.filter = PHPickerFilter.any(of: [.images])
                    config.selectionLimit = 4
                    config.selection = .ordered
                    config.preferredAssetRepresentationMode = .current
                    config.preselectedAssetIdentifiers = self.selectedAssetIdentifiers
                    
                    let imagePicker = PHPickerViewController(configuration: config)
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true)
                }))

                actionSheet.addAction(UIAlertAction(title: "단일 폴라로이드", style: .default, handler: {(ACTION:UIAlertAction) in
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    picker.delegate = self
                    self.present(picker, animated: false)
                }))
                
                actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))

                self.present(actionSheet, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        filterButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
//                owner.showFilterSelectionView()
                let alert = UIAlertController(title: "죄송합니다", message: "아직 개발이 완성되지 않았습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        filterSelectionView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.hideFilterSelectionView()
            })
            .disposed(by: disposeBag)
        
        styleButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.showStyleSelectionView()
            })
            .disposed(by: disposeBag)
        
        styleSelectionView.closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _  in
                owner.hideStyleSelectionView()
            })
            .disposed(by: disposeBag)
        
        effectButton.rx
            .tap.subscribe(with: self, onNext: { owner, _ in
                let alert = UIAlertController(title: "죄송합니다", message: "아직 개발이 완성되지 않았습니다.", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(okAction)
                
                self.present(alert, animated: true, completion: nil)

            })
    }
    
    private func layout() {
        [
            cameraView,
            stackView,
            toggleButtonStackView
        ].forEach { view.addSubview($0) }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            cameraView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(53.0)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(744.0)
            }
            
            stackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-36)
                $0.left.greaterThanOrEqualToSuperview().offset(20)
                $0.right.lessThanOrEqualToSuperview().offset(-20)
                $0.left.equalTo(centerButton.snp.left).offset(-40).priority(.high)
                $0.right.equalTo(centerButton.snp.right).offset(40).priority(.high)
            }
            
            centerButton.snp.makeConstraints {
                $0.width.height.equalTo(80)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.width.equalTo(148)
                $0.height.equalTo(76)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(stackView.snp.top).offset(-10.0)
            }
            
            [pictureToggleButton, videoToggleButton].forEach { button in
                toggleButtonStackView.addArrangedSubview(button)
                button.snp.makeConstraints {
                    $0.width.equalTo(54)
                    $0.height.equalTo(38)
                }
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            
            pictureToggleButton.snp.makeConstraints {
                $0.width.equalTo(videoToggleButton.snp.width)
            }
            
            videoToggleButton.snp.makeConstraints {
                $0.width.equalTo(pictureToggleButton.snp.width)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
            
            
        } else {
            cameraView.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide).offset(90.0)
                $0.centerX.equalToSuperview()
                $0.width.equalToSuperview()
                $0.height.equalTo(430.0)
            }
            
            stackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-86)
                $0.left.greaterThanOrEqualToSuperview().offset(20)
                $0.right.lessThanOrEqualToSuperview().offset(-20)
                $0.left.equalTo(centerButton.snp.left).offset(-20).priority(.high)
                $0.right.equalTo(centerButton.snp.right).offset(20).priority(.high)
            }
            
            centerButton.snp.makeConstraints {
                $0.width.height.equalTo(80)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.width.equalTo(148)
                $0.height.equalTo(76)
                $0.centerX.equalToSuperview()
                $0.bottom.equalTo(stackView.snp.top).offset(-20.0)
            }
            
            [pictureToggleButton, videoToggleButton].forEach { button in
                toggleButtonStackView.addArrangedSubview(button)
                button.snp.makeConstraints {
                    $0.width.equalTo(74)
                    $0.height.equalTo(38)
                }
                button.setContentCompressionResistancePriority(.required, for: .horizontal)
            }
            
            pictureToggleButton.snp.makeConstraints {
                $0.width.equalTo(videoToggleButton.snp.width)
            }
            
            videoToggleButton.snp.makeConstraints {
                $0.width.equalTo(pictureToggleButton.snp.width)
            }
            
            toggleButtonStackView.snp.makeConstraints {
                $0.centerX.equalToSuperview()
            }
        }
    }
    
    private func bindAction() {
        centerButton.rx.tap
            .bind {
                print("centerButton tapped")
                self.cameraView.capturePhoto { result in
                    switch result {
                    case .success(let image):
                        print("사진 저장")
                        self.playMusic()
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        break
                    case .failure(let error):
                        print("저장 실패 \(error)")
                        break
                    }
                }
            }
    }
    
    private func playMusic() {
        let url = Bundle.main.url(forResource: soundFileName, withExtension: "mp3")
        if let url = url {
            do {
                print("사진이 찍힘")
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func backButtonTap(_ sender: Any) {
        print("backButton tapped")
        
        isOn.toggle()
        
        if isOn {
            cameraView.setCameraPosition(.back)
            print("back")
        } else {
            cameraView.setCameraPosition(.front)
            print("front")
        }
    }
    
    private func ellipsisButtonTap() {
        print("ellipsisButton tapped")
        
        touchShootOn.toggle()
        
        if touchShootOn {
            cameraView.addTapGesture(allow: true)
            print("실행")
        } else {
            cameraView.addTapGesture(allow: false)
            print("실행하지 않음")
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        
        pictureToggleButton.isSelected = (sender == pictureToggleButton)
        videoToggleButton.isSelected = (sender == videoToggleButton)
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
            
            let button1TitleColor: UIColor = self.pictureToggleButton.isSelected ? TodayKitAsset.Colors.white.color : TodayKitAsset.Colors.gray4.color
            let button2TitleColor: UIColor = self.videoToggleButton.isSelected ? TodayKitAsset.Colors.white.color : TodayKitAsset.Colors.gray4.color
            self.pictureToggleButton.setTitleColor(button1TitleColor, for: .normal)
            self.videoToggleButton.setTitleColor(button2TitleColor, for: .normal)
            
            self.pictureToggleButton.backgroundColor = self.pictureToggleButton.isSelected ? TodayKitAsset.Colors.baa7E7.color : TodayKitAsset.Colors.white.color
            self.videoToggleButton.backgroundColor = self.videoToggleButton.isSelected ? TodayKitAsset.Colors.baa7E7.color : TodayKitAsset.Colors.white.color
        }
    }
    
    private func showFilterSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterSelectionView.frame.origin.y = self.view.frame.height - self.filterSelectionView.frame.height
        }
    }
    
    private func showStyleSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.styleSelectionView.frame.origin.y = self.view.frame.height - self.styleSelectionView.frame.height
        }
    }
    
    private func hideFilterSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.filterSelectionView.frame.origin.y = self.view.frame.height
        }
    }
    
    private func hideStyleSelectionView() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.styleSelectionView.frame.origin.y = self.view.frame.height
            
        }
    }
    
    func applyStyle(imageName: String) {
        if let imageView = appliedStyleImageView {
            imageView.removeFromSuperview()
        }
        
        guard let image = UIImage(named: imageName) else { return }
        let resizedImage = resizeImage(image: image, targetSize: cameraView.bounds.size)
        
        let imageView = UIImageView(image: resizedImage)
        imageView.frame = cameraView.bounds
        imageView.tag = 1000
        cameraView.addSubview(imageView)
        cameraView.bringSubviewToFront(imageView)
        appliedStyleImageView = imageView
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

extension MainCameraViewController: UIImagePickerControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("이미지 선택하지않고 취소한 경우")
        
        self.dismiss(animated: false) { () in
            let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            self.present(alert, animated: false)
        }
    }
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("이미지 선택")
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            picker.dismiss(animated: false) { () in
                let userImageView = UIImageView(image: img)
                let editedFrame = EditedFrame(userImageView: userImageView)
                
                let vc = SingleCorrectionViewController(image: img, editedFrame: editedFrame)
                let navController = UINavigationController(rootViewController: vc)
                navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        } else {
            print("이미지를 선택하지 않음")
            picker.dismiss(animated: true, completion: nil)
        }
    }
}

extension MainCameraViewController: StyleSelectionViewDelegate {
    func didSelectStyleAt(index: Int) {
        
        switch index {
        case 0:
            applyStyle(imageName: "thoughtImage")
        case 1:
            applyStyle(imageName: "worryImage")
        case 2:
            applyStyle(imageName: "workImage")
        case 3:
            applyStyle(imageName: "CatchImage")
        case 4:
            applyStyle(imageName: "LeanImage")
        default:
            print("없음")
        }
    }
}

extension MainCameraViewController: PHPickerViewControllerDelegate {
    
    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        guard !selections.isEmpty else {
            print("이미지가 없음")
            return
        }
        
        var selectedImages = [UIImage]()
        var imageViews = [UIImageView]()
        let dispatchGroup = DispatchGroup()
        
        for assetIdentifier in selectedAssetIdentifiers {
            dispatchGroup.enter()
            
            let provider = selections[assetIdentifier]?.itemProvider
            
            provider?.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let error = error {
                    print("Error loading image: \(error)")
                }
                
                if let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    selectedImages.append(image)
                    let imageView = UIImageView(image: image)
                    imageViews.append(imageView)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            let editedFrame = EditedFrame(userImageView: imageViews.first!)
            let multipleCorrectionVC = MultipleCorrectionViewController(images: selectedImages, editedFrame: editedFrame)
            let navController = UINavigationController(rootViewController: multipleCorrectionVC)
            navController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.present(navController, animated: true, completion: nil)
            
        }
    }
}
