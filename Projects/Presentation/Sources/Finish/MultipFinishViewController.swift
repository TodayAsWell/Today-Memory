import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import TodayKit

class MultipFinishViewController: UIViewController, FinishViewInterface {
    
    private var disposeBag = DisposeBag()
    
    private var downloadWidth: Double = 100.0
    
    private var mainFrameView: UIView
    private var userImageView1: UIImageView
    private var userImageView2 = UIImageView()
    private var userImageView3 = UIImageView()
    private var userImageView4 = UIImageView()
    private var exImage: UIImageView
    
    private var editedFrame: EditedFrame
    
    init(images: [UIImage?], editedFrame: EditedFrame) {
        self.editedFrame = editedFrame
        self.mainFrameView = editedFrame.mainFrameView!
        self.userImageView1 = editedFrame.userImageView!
        self.exImage = editedFrame.exImage!
        super.init(nibName: nil, bundle: nil)

        if let image1 = images[0] {
            userImageView1.image = image1
        }
        if let image2 = images[1] {
            userImageView2.image = image2
        }
        if let image3 = images[2] {
            userImageView3.image = image3
        }
        if let image4 = images[3] {
            userImageView4.image = image4
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var downloadButton = UIButton().then {
        $0.setImage(UIImage(named: "DownloadImage"), for: .normal)
        $0.backgroundColor = .white
        $0.layer.borderWidth = 2
        $0.layer.borderColor = TodayKitAsset.Colors.gray2.color.cgColor
        $0.layer.cornerRadius = 50.0
        $0.isEnabled = true
    }
    
    private func saveImageToGallery() {
        let screenBounds = UIScreen.main.bounds
        let adjustedWidth = screenBounds.width
        let adjustedHeight = screenBounds.height
        let rendererSize = CGSize(width: adjustedWidth, height: adjustedHeight)

        let canvasRenderer = UIGraphicsImageRenderer(size: rendererSize)

        let imageToCombine = canvasRenderer.image { rendererContext in
            UIGraphicsBeginImageContextWithOptions(rendererSize, false, 0.0)

            let context = rendererContext.cgContext
            
            context.setFillColor(UIColor.white.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: adjustedWidth, height: adjustedHeight))

            func renderView(_ view: UIView) {
                let rect = view.convert(view.bounds, to: nil)
                context.translateBy(x: rect.origin.x, y: rect.origin.y)
                view.layer.render(in: context)
                context.translateBy(x: -rect.origin.x, y: -rect.origin.y)
            }
            
            renderView(mainFrameView)
            renderView(userImageView1)
            renderView(userImageView2)
            renderView(userImageView3)
            renderView(userImageView4)
            renderView(exImage)

            UIGraphicsEndImageContext()
        }
        
        UIImageWriteToSavedPhotosAlbum(imageToCombine, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        print("Save image to gallery")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter.viewDidLoad()
        
        downloadButton.rx.tap
            .subscribe(with: self, onNext: { [weak self] _,_   in
                guard let self = self else { return }
                self.saveImageToGallery()
            })
            .disposed(by: disposeBag)
        setupNavigationItem()
        layout()
        
        let backButton = UIBarButtonItem(title: "처음으로", style: .plain, target: self, action: #selector(backToMainCamera))
        navigationItem.rightBarButtonItem = backButton
    }

    func setupNavigationItem() {
        title = "저장 완료!"
        view.backgroundColor = TodayKitAsset.Colors.f6F6F8.color
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "처음으로", style: .plain, target: self, action: #selector(backToMainCamera))
    }
    
    @objc func backToMainCamera() {
        navigationController?.popToRootViewController(animated: true)
    }

    func layout() {
        view.addSubview(mainFrameView)
        view.addSubview(userImageView1)
        view.addSubview(userImageView2)
        view.addSubview(userImageView3)
        view.addSubview(userImageView4)
        view.addSubview(exImage)
        view.addSubview(downloadButton)
    
        downloadButton.imageView?.contentMode = .scaleAspectFit
        downloadButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        mainFrameView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(250.0)
            $0.height.equalTo(700.0)
        }
        
        userImageView1.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top).offset(12)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.width.equalTo(215.0)
            $0.height.equalTo(148.0)
        }
        
        userImageView2.snp.makeConstraints {
            $0.top.equalTo(userImageView1.snp.bottom).offset(10.0)
            $0.centerX.equalTo(userImageView1.snp.centerX)
            $0.width.equalTo(215.0)
            $0.height.equalTo(148.0)
        }
        
        userImageView3.snp.makeConstraints {
            $0.top.equalTo(userImageView2.snp.bottom).offset(2.0)
            $0.centerX.equalTo(userImageView2.snp.centerX)
            $0.width.equalTo(215.0)
            $0.height.equalTo(148.0)
        }
        
        userImageView4.snp.makeConstraints {
            $0.top.equalTo(userImageView3.snp.bottom).offset(3.0)
            $0.centerX.equalTo(userImageView3.snp.centerX)
            $0.width.equalTo(215.0)
            $0.height.equalTo(148.0)
        }
        
        exImage.snp.makeConstraints {
            $0.top.equalTo(mainFrameView.snp.top)
            $0.centerX.equalTo(mainFrameView.snp.centerX)
            $0.width.equalTo(245)
            $0.height.equalTo(700)
        }
        
        downloadButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(64.0)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100.0)
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: "Failed to save image to gallery: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("실패")
        } else {
            let alert = UIAlertController(title: "Success", message: "Image saved to gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            print("성공")
        }
    }
}
