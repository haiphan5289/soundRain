//
//  MusicCell.swift
//  SoundRain
//
//  Created by Phan Hai on 23/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit

class MusicCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(model: MusicModel) {
        guard let img = model.img else {
            return
        }
        
        self.img.image = UIImage(named: img)
        self.lbTitle.text = model.title
    }

}
