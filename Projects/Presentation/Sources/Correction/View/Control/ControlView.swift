import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class ControlView: UIView {
    
    private var brightnessView: BrightnessView?
    private var prepareView: PrepareView?
    private var correctionView: CorrectionView?
    
    private var currentView: UIView?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var mainTitle = UILabel().then {
        $0.text = "글자"
        $0.textColor = .BAA7E7
        $0.font = .systemFont(ofSize: 20.0, weight: .semibold)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setupCollectionView()
    }
    
    private func setupUI() {
        backgroundColor = .white
        
        addSubview(mainTitle)
        addSubview(collectionView)
        
        mainTitle.snp.makeConstraints {
            $0.top.equalToSuperview().offset(19.0)
            $0.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(mainTitle.snp.bottom).offset(23.0)
            $0.height.equalTo(80)
        }
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")
    }
}

extension ControlView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as! FilterCollectionViewCell
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "글자색"
            cell.imageView.image = UIImage(named: "0")
        case 1:
            cell.titleLabel.text = "배경색"
            cell.imageView.image = UIImage(named: "1")
        case 2:
            cell.titleLabel.text = "크기"
            cell.imageView.image = UIImage(named: "2")
        default:
            cell.titleLabel.text = "없음"
            cell.imageView.backgroundColor = .black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            if let previousView = brightnessView {
                previousView.removeFromSuperview()
            }
            
            let updatedY = frame.origin.y - 140
            brightnessView = BrightnessView(frame: CGRect(x: 0, y: updatedY, width: frame.width, height: 140))
            superview?.addSubview(brightnessView!)
            self.brightnessView?.frame.origin.y += 140
        case 1:
            if let previousView = prepareView {
                previousView.removeFromSuperview()
            }
            
            let updatedY = frame.origin.y - 140
            prepareView = PrepareView(frame: CGRect(x: 0, y: updatedY, width: frame.width, height: 140))
            superview?.addSubview(prepareView!)
            self.prepareView?.frame.origin.y += 140
        case 2:
            if let previousView = correctionView {
                previousView.removeFromSuperview()
            }
            
            let updatedY = frame.origin.y - 140
            correctionView = CorrectionView(frame: CGRect(x: 0, y: updatedY, width: frame.width, height: 140))
            superview?.addSubview(correctionView!)
            self.correctionView?.frame.origin.y += 140
        default:
            print("존재하지 않음")
        }
        
        currentView?.isHidden = true
        

        switch indexPath.row {
        case 0:
            currentView = brightnessView
        case 1:
            currentView = prepareView

        case 2:
            currentView = correctionView
//            correctionView?.removeFromSuperview() 나중에 이런걸로 릭 발생할 수 있음
            //지금은 숨기는 용도로 했지만 나중에는 메모리를 끈어주어야함
        default:
            currentView = nil
        }
        
        currentView?.isHidden = false
        superview?.bringSubviewToFront(currentView!)
        
        print("index \(indexPath.row)")
    }
}
