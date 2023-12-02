import UIKit
import SnapKit
import Then

class MultipleFrameViewController: UIViewController {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: 240, height: 344)
        layout.sectionInset = UIEdgeInsets(top: 4, left: 20, bottom: 4, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "프레임"
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FrameSelectCollectionViewCell.self, forCellWithReuseIdentifier: FrameSelectCollectionViewCell.id)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension MultipleFrameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FrameSelectCollectionViewCell.id, for: indexPath) as! FrameSelectCollectionViewCell
        
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.borderColor = UIColor.EAEAFC.cgColor
        cell.imageView.backgroundColor = .EEEEF0
        switch indexPath.row {
        case 0:
            cell.mainImage.image = UIImage(named: "Base4Frame")
            cell.titleLabel.text = "Write Day"
        case 1:
            cell.mainImage.image = UIImage(named: "Black4Frame")
            cell.titleLabel.text = "Black Day"
        case 2:
            cell.mainImage.image = UIImage(named: "Clover4Frame")
            cell.titleLabel.text = "Clover Day"
        case 3:
            cell.mainImage.image = UIImage(named: "Gradation4Frame")
            cell.titleLabel.text = "Spring Day"
        case 4:
            cell.mainImage.image = UIImage(named: "Ocean4Frame")
            cell.titleLabel.text = "Ocean Day"
        case 5:
            cell.mainImage.image = UIImage(named: "Peach4Image")
            cell.titleLabel.text = "Peach Day"
        case 6:
            cell.mainImage.image = UIImage(named: "Purple4Frame")
            cell.titleLabel.text = "Purple Day"
        case 7:
            cell.mainImage.image = UIImage(named: "Universe4Frame")
            cell.titleLabel.text = "Nature Day"
            
        default:
            cell.imageView.backgroundColor = .EEEEF0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let previousVC = self.navigationController?.viewControllers[0] as? MultipleCorrectionViewController else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! FrameSelectCollectionViewCell
        previousVC.setExImage(image: cell.mainImage.image!)
        navigationController?.popViewController(animated: true)
    }
}
