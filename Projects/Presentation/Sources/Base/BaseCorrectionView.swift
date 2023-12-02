import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

public class BaseCorrectionView: UIView {
    public var titleLabel = UILabel().then {
        $0.text = ""
        $0.font = .systemFont(ofSize: 20.0, weight: .semibold)
        $0.textColor = .black
    }
    
    public let slider = UISlider().then {
        $0.minimumValue = 0
        $0.maximumValue = 100
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        self.addSubview(titleLabel)
        self.addSubview(slider)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30.0)
            $0.leading.equalToSuperview().offset(60.0)
        }
        
        slider.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(96.44)
            $0.trailing.equalToSuperview().offset(-96.44)
            $0.top.equalTo(titleLabel.snp.bottom).offset(30.0)
        }
        
    }
}
