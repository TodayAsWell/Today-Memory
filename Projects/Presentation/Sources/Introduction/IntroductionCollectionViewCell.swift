import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class IntroductionCollectionViewCell: UICollectionViewCell {
    static let cellName = "IntroductionCollectionViewCell"
    
    private lazy var mainImage = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    
    private lazy var mainTitle = UILabel().then {
        $0.text = "프리미엄 필터"
        $0.font = .systemFont(ofSize: 64, weight: .semibold)
        $0.numberOfLines = 2
        $0.textColor = .black
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSlides(_ data: IntroductionModel) {
        mainTitle.text = data.title
        mainImage.image = data.image
    }
    
    private func layout() {
        
        contentView.addSubview(mainImage)
        contentView.addSubview(mainTitle)
        
        mainImage.snp.makeConstraints {
            $0.top.trailing.leading.equalToSuperview()
            $0.height.equalTo(700.0)
            $0.width.equalToSuperview()
        }
        
        mainTitle.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(20.0)
            $0.leading.equalToSuperview().offset(40.0)
        }
    }

}
