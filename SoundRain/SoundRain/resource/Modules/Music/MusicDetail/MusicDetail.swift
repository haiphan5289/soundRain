//
//  MusicDetail.swift
//  SoundRain
//
//  Created by Phan Hai on 23/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit

final class MusicDetail: UIViewController {

    var data: MusicModel?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
         let navigationBar = navigationController?.navigationBar
          navigationBar?.layoutIfNeeded()
          navigationBar?.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black,
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold) ]
         navigationBar?.barTintColor = .clear
        navigationBar?.shadowImage = UIImage()
    }
}
