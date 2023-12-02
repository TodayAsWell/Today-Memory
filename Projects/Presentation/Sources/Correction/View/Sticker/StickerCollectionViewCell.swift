import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SnapKit

class StickerCollectionViewCell: UICollectionViewCell {
    
    static var id: String = "StickerCollectionViewCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.borderWidth = 0
    }
    
    func setupCell(sticker: UIImage) {
        setupUI()
        imageView.image = sticker
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(100.0)
        }
    }
}
