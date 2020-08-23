//
//  MusicVC.swift
//  SoundRain
//
//  Created by Phan Hai on 22/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation

class MusicVC: UIViewController {

    var player: AVAudioPlayer?
    private var dataSource: [MusicModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        visualize()
        playSound()
    }

}
extension MusicVC {
    private func visualize() {
        dummyData()
        
        self.view.backgroundColor = .white
        
        let imgBG: UIImageView = UIImageView(frame: .zero)
        imgBG.image = UIImage(named: "img_night")
        imgBG.sizeToFit()
        imgBG.contentMode = .scaleAspectFill
        self.view.addSubview(imgBG)
        imgBG.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: (self.view.bounds.width - 30) / 2, height: 150)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MusicCell.nib, forCellWithReuseIdentifier: MusicCell.identifier)
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(self.view.bounds.height * 2 / 3)
        }
        collectionView.backgroundColor = .clear
        
    }
    private func dummyData() {
        let data1: MusicModel = MusicModel(img: "img_rain_night", title: "Tiếng mưa đêm")
        self.dataSource.append(data1)
    }
    func playSound() {
        guard let url = Bundle.main.url(forResource: "soundRain", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
extension MusicVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.identifier, for: indexPath) as! MusicCell
        cell.updateUI(model: self.dataSource[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MusicDetail(nibName: "MusicDetail", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
