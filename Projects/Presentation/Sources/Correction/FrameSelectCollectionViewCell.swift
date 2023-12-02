//
//  FrameCollectionViewCell.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/07/11.
//

import UIKit
import SnapKit
import Then

class FrameSelectCollectionViewCell: UICollectionViewCell {
    
    static var id: String = "FrameSelectCollectionViewCell"
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let mainImage = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    let titleLabel = UILabel().then {
        $0.text = "asdf"
        $0.font = .systemFont(ofSize: 20.0, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
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
        contentView.addSubview(titleLabel)
        contentView.addSubview(mainImage)
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(344.0)
            $0.width.equalTo(240.0)
        }
        
        mainImage.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(90.0)
            $0.height.equalTo(220.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(20.0)
        }
    }
}
