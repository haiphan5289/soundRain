//
//  HomeTabbar.swift
//  SoundRain
//
//  Created by Phan Hai on 22/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit

enum HomeType: Int, CaseIterable {
    case music
    case postProduct
    
    var text: String {
        switch self {
        case .music:
            return "Nghe nhạc"
        case .postProduct:
            return "Đăng SP"
        }
    }
}

class HomeTabbar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = ""
    }
}
extension HomeTabbar {
    private func visualize() {
        self.view.backgroundColor = .white
        
        let music = MusicVC()
        let postProduct = PostProductVC()
        viewControllers = [music, postProduct]
        HomeType.allCases.forEach { (type) in
            if let controller = viewControllers?[type.rawValue] {
                controller.tabBarItem.title = type.text
            }
        }
    }
}
