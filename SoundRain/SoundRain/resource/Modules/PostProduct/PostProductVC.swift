//
//  PostProductVC.swift
//  SoundRain
//
//  Created by Phan Hai on 22/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit

class PostProductVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
    }

}
extension PostProductVC {
    private func visualize() {
        self.view.backgroundColor = .white
        
        let imgBG: UIImageView = UIImageView(frame: .zero)
        imgBG.image = UIImage(named: "img_night")
        imgBG.sizeToFit()
        imgBG.contentMode = .scaleAspectFill
        self.view.addSubview(imgBG)
        imgBG.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
