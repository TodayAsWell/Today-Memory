//
//  FrameCollectionViewCell.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit
import SnapKit

class FrameCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionStyle()
        }
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.width.equalTo(84.0)
            $0.height.equalTo(92.0)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.bottom.lessThanOrEqualToSuperview()
        }
        
        updateSelectionStyle()
    }
    private func updateSelectionStyle() {
        let borderWidth: CGFloat = isSelected ? 4 : 0
        let borderColor: UIColor = isSelected ? .BAA7E7 : .clear
        imageView.layer.borderWidth = borderWidth
        imageView.layer.borderColor = borderColor.cgColor
    }
}
