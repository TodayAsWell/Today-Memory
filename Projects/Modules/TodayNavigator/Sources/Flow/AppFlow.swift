//
//  AppFlow.swift
//  APPNavigator
//
//  Created by 박준하 on 2023/09/22.
//  Copyright © 2023 APP-iOS. All rights reserved.
//

//import Foundation
//import RxFlow
//import RxCocoa
//import RxSwift
//import Core
//import UIKit
//
//public class AppFlow: Flow {
//    
//    var window: UIWindow
//    
//    public var root: Presentable {
//        return self.window
//    }
//    
//    public init(window: UIWindow) {
//        self.window = window
//    }
//    
//    public func navigate(to step: Step) -> FlowContributors {
//        guard let step = step as? AppStep else { return .none }
//        switch step {
//        case .loginIsRequired:
//            return self.navigateToLogin()
//        case .homeIsRequired:
//            return self.navigateToHome()
//        }
//    }
//}
