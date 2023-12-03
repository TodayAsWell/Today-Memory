import UIKit
import CoreImage
import SnapKit
import Then

class VVViewController: UIViewController {
    var imageView: UIImageView!
    var brightnessSlider: UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupImageView()
        setupSlider()
    }

    private func setupImageView() {
        imageView = UIImageView().then {
            $0.image = UIImage(named: "dagImage")
            $0.contentMode = .scaleAspectFit
        }
        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(view.bounds.width - 40)
        }
    }

    private func setupSlider() {
        brightnessSlider = UISlider().then {
            $0.minimumValue = -1
            $0.maximumValue = 1
            $0.value = 0
            $0.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        }
        view.addSubview(brightnessSlider)

        brightnessSlider.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
        }
    }

    @objc func sliderValueChanged(_ sender: UISlider) {
        let ciImage = CIImage(image: imageView.image!)
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(sender.value, forKey: kCIInputBrightnessKey)
        
        if let outputImage = filter.outputImage {
            let context = CIContext(options: nil)
            if let renderedImage = context.createCGImage(outputImage, from: outputImage.extent) {
                let brightenedImage = UIImage(cgImage: renderedImage)
                imageView.image = brightenedImage
            }
        }
    }
}
