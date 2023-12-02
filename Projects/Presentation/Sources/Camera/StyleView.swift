//
//  StyleView.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/06/16.
//

import UIKit
import SnapKit
import Then

class StyleView: UIView {
    
    private let centerButton = UIButton(type: .system).then {
        $0.backgroundColor = .red
        $0.layer.borderWidth = 5
        $0.layer.cornerRadius = 40.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(centerButton)
        
        centerButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(100.0)
        }
        
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
