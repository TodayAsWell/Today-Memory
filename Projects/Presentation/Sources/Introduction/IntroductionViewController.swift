import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import TodayKit

class IntroductionViewController: UIViewController, UIScrollViewDelegate {
    
    var mainCollectionView: UICollectionView!
    var introductionData: [IntroductionModel] = []
    
    var nextButton = UIButton().then {
        $0.setTitle("계속", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.backgroundColor = TodayKitAsset.Colors.yellow.color
    }
    
    var pageControl = UIPageControl()
    
    var currentPage: Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == introductionData.count - 1 {
                nextButton.setTitle("시작", for: .normal)
            } else {
                nextButton.setTitle("계속", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                if self.currentPage == self.introductionData.count - 1 {
                    print("go to main")
                } else {
                    self.currentPage += 1
                    let indexPath = IndexPath(item: self.currentPage, section: 0)
                    self.mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                }
            })
        
        setUI()
        setCollectionView()
        layout()
        setData()
        
        pageControl.numberOfPages = introductionData.count
        pageControl.currentPage = 0
        pageControl.tintColor = TodayKitAsset.Colors.yellow.color
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = TodayKitAsset.Colors.yellow.color
    }
    
    func layout() {
        view.addSubview(mainCollectionView)
        view.addSubview(pageControl)
        view.addSubview(nextButton)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            mainCollectionView.snp.makeConstraints {
                $0.top.trailing.leading.equalToSuperview()
                $0.height.equalTo(830.0)
                $0.width.equalToSuperview()
            }
            
            pageControl.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(mainCollectionView.snp.bottom).offset(90.0)
                $0.height.equalTo(42.0)
            }
            
            nextButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-90.0)
                $0.height.equalTo(65.0)
                $0.width.equalTo(615.0)
            }
        } else {
            
            mainCollectionView.snp.makeConstraints {
                $0.top.trailing.leading.equalToSuperview()
                $0.height.equalTo(700.0)
                $0.width.equalToSuperview()
            }
            
            pageControl.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.top.equalTo(mainCollectionView.snp.bottom).offset(40.0)
                $0.height.equalTo(42.0)
            }
            
            nextButton.snp.makeConstraints {
                $0.centerX.equalToSuperview()
                $0.bottom.equalToSuperview().offset(-68.0)
                $0.width.equalTo(350.0)
                $0.height.equalTo(60.0)
            }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = pageIndex
    }

    private func scrollToPage(_ pageIndex: Int) {
        guard pageIndex >= 0 && pageIndex < introductionData.count else {
            return
        }
        
        let indexPath = IndexPath(item: pageIndex, section: 0)
        mainCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }

    @objc private func pageControlValueChanged(_ sender: UIPageControl) {
        scrollToPage(sender.currentPage)
    }
}

// MARK: - Custom Functions
extension IntroductionViewController {
    private func setUI() {
        nextButton.layer.cornerRadius = 30
        pageControl.isUserInteractionEnabled = false
    }
    
    private func setCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        mainCollectionView.contentInsetAdjustmentBehavior = .never
        mainCollectionView.isPagingEnabled = true
        layout.scrollDirection = .horizontal
        
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        mainCollectionView.register(IntroductionCollectionViewCell.self, forCellWithReuseIdentifier: IntroductionCollectionViewCell.cellName)
        mainCollectionView.collectionViewLayout = layout
        
        mainCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setData() {
        introductionData.append(contentsOf: [
            IntroductionModel(title: "프리미엄\n필터", image: UIImage(named: "ExampleImage")!),
            IntroductionModel(title: "3D\n필터", image: UIImage(named: "ExampleImage")!),
            IntroductionModel(title: "사진\n보정", image: UIImage(named: "ExampleImage")!)
        ])
        
        mainCollectionView.reloadData()
    }
}

extension IntroductionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introductionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = mainCollectionView.dequeueReusableCell(withReuseIdentifier: IntroductionCollectionViewCell.cellName, for: indexPath) as? IntroductionCollectionViewCell else { return UICollectionViewCell() }
        cell.setSlides(introductionData[indexPath.row])
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        let offset = scrollView.contentOffset.x
        let currentPageFloat = offset / width
        
        if !currentPageFloat.isInfinite && !currentPageFloat.isNaN {
            let newPage = Int(currentPageFloat)
            if newPage != currentPage {
                currentPage = newPage
                pageControl.currentPage = currentPage
            }
        }
    }
}

extension IntroductionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
