import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

class ViewController: UIViewController {

    let disposeBag = DisposeBag()

    // 필터, 액자, 조정, 스티커 툴바 버튼
    let filterButton = UIButton(type: .system)
    let frameButton = UIButton(type: .system)
    let adjustmentButton = UIButton(type: .system)
    let stickerButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        // 툴바 버튼 초기화
        filterButton.setTitle("필터", for: .normal)
        frameButton.setTitle("액자", for: .normal)
        adjustmentButton.setTitle("조정", for: .normal)
        stickerButton.setTitle("스티커", for: .normal)

        // 툴바 버튼 레이아웃 설정
        let stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
        }
        view.addSubview(stackView)

        stackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
        }

        stackView.addArrangedSubview(filterButton)
        stackView.addArrangedSubview(frameButton)
        stackView.addArrangedSubview(adjustmentButton)
        stackView.addArrangedSubview(stickerButton)

        // 필터 버튼 탭 이벤트
        filterButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.filterButton)
                self?.applyFilter()
                self?.deselectButtons(except: self?.filterButton)
            })
            .disposed(by: disposeBag)

        // 액자 버튼 탭 이벤트
        frameButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.frameButton)
                self?.applyFrame()
                self?.deselectButtons(except: self?.frameButton)
            })
            .disposed(by: disposeBag)

        // 조정 버튼 탭 이벤트
        adjustmentButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.adjustmentButton)
                self?.adjustPhoto()
                self?.deselectButtons(except: self?.adjustmentButton)
            })
            .disposed(by: disposeBag)

        // 스티커 버튼 탭 이벤트
        stickerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.toggleButton(self?.stickerButton)
                self?.applySticker()
                self?.deselectButtons(except: self?.stickerButton)
            })
            .disposed(by: disposeBag)
    }

    func toggleButton(_ button: UIButton?) {
        button?.isSelected = !(button?.isSelected ?? false)
        button?.backgroundColor = button?.isSelected == true ? .yellow : nil
    }

    func deselectButtons(except selectedButton: UIButton?) {
        let buttonsToDeselect = [filterButton, frameButton, adjustmentButton, stickerButton].filter { $0 != selectedButton }
        buttonsToDeselect.forEach { $0?.isSelected = false }
        buttonsToDeselect.forEach { $0?.backgroundColor = nil }
    }

    func applyFilter() {
        // 필터 기능을 구현하는 코드 작성
        // 필터 적용 로직 추가
        print("필터 버튼이 탭되었습니다.")
    }

    func applyFrame() {
        // 액자 기능을 구현하는 코드 작성
        // 액자 적용 로직 추가
        print("액자 버튼이 탭되었습니다.")
    }

    func adjustPhoto() {
        // 조정 기능을 구현하는 코드 작성
        // 사진 조정 로직 추가
        print("조정 버튼이 탭되었습니다.")
    }

    func applySticker() {
        // 스티커 기능을 구현하는 코드 작성
        // 스티커 적용 로직 추가
        print("스티커 버튼이 탭되었습니다.")
    }
}
