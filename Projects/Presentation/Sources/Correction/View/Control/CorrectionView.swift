//
//  CorrectionView.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/21.
//

import UIKit

class CorrectionView: BaseCorrectionView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        titleLabel.text = "보정"
    }
}
