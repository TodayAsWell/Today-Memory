import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import TodayKit

class StyleCollectionViewCell: UICollectionViewCell {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = TodayKitAsset.Colors.eaeafc.color.cgColor
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = TodayKitAsset.Colors.eaeafc.color.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        updateSelectionStyle()
    }
    
    private func updateSelectionStyle() {
        let borderWidth: CGFloat = isSelected ? 4 : 0
        let borderColor: UIColor = isSelected ? TodayKitAsset.Colors.baa7E7.color : TodayKitAsset.Colors.eaeafc.color
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
    }
}
