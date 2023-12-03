//
//  EditedFrame.swift
//  Presentation
//
//  Created by 박준하 on 12/1/23.
//  Copyright © 2023 Today-iOS. All rights reserved.
//

import Foundation
import UIKit

struct EditedFrame {
    var mainFrameView: UIView?
    var userImageView: UIImageView?
    var exImage: UIImageView?

    init(userImageView: UIImageView) {
        self.userImageView = userImageView
    }

    init(mainFrameView: UIView, userImageView: UIImageView, exImage: UIImageView) {
        self.mainFrameView = mainFrameView
        self.userImageView = userImageView
        self.exImage = exImage
    }
}
