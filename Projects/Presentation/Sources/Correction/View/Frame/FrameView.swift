import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

protocol FrameViewDelegate: AnyObject {
    func didSelectFrameImage(image: UIImage)
}

class FrameView: UIView {
    
    weak var delegate: FrameViewDelegate?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 7
        layout.itemSize = CGSize(width: 100, height: 220)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
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
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(20)
            $0.height.equalTo(220)
        }
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FrameCollectionViewCell.self, forCellWithReuseIdentifier: "FrameCollectionViewCell")
    }
}

extension FrameView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCollectionViewCell", for: indexPath) as! FrameCollectionViewCell
        
        cell.imageView.image = UIImage(named: "FameImage")
        cell.titleLabel.text = "Flower"
        
        
        switch indexPath.row {
        case 1:
            cell.imageView.image = UIImage(named: "EXBlackDesignFrame")
            cell.titleLabel.text = "balckPainting"
        case 2:
            cell.imageView.image = UIImage(named: "11")
            cell.titleLabel.text = "Spring"
        case 3:
            cell.imageView.image = UIImage(named: "14")
            cell.titleLabel.text = "Flower"
        case 4:
            cell.imageView.image = UIImage(named: "15")
            cell.titleLabel.text = "Flower"
        case 5:
            cell.imageView.image = UIImage(named: "16")
            cell.titleLabel.text = "Cool"
        case 6:
            cell.imageView.image = UIImage(named: "17")
            cell.titleLabel.text = "balckPainting"
        default:
            cell.imageView.image = UIImage(named: "EXBlackDesignFrame")
            cell.titleLabel.text = "balckPainting"
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index \(indexPath.row)")
        var selectedImage = UIImage(named: "ExPolaroid")
        
        switch indexPath.row {
        case 0:
            selectedImage = UIImage(named: "ExPolaroid")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 1:
            selectedImage = UIImage(named: "blackDesignFrame")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 2:
            selectedImage = UIImage(named: "100")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 3:
            selectedImage = UIImage(named: "104")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 4:
            selectedImage = UIImage(named: "105")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 5:
            selectedImage = UIImage(named: "106")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 6:
            selectedImage = UIImage(named: "107")
            delegate?.didSelectFrameImage(image: selectedImage!)
        case 7:
            selectedImage = UIImage(named: "108")
            delegate?.didSelectFrameImage(image: selectedImage!)
            
        default:
            selectedImage = UIImage(named: "ExPolaroid")
            delegate?.didSelectFrameImage(image: selectedImage!)
        }
    }
}
