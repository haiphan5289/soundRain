//
//  MusicDetail.swift
//  SoundRain
//
//  Created by Phan Hai on 23/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class MusicDetail: UIViewController {
    
    var data: MusicModel?
    var player: AVAudioPlayer?
    @IBOutlet weak var lbStart: UILabel!
    @IBOutlet weak var lbEnd: UILabel!
    @IBOutlet weak var btPause: UIButton!
    @IBOutlet weak var btReplay: UIButton!
    @IBOutlet weak var slideMusic: UISlider!
    private var timer: Observable<Int>?
    private let disposeBag = DisposeBag()
    private var isReplay: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound()
        setupRX()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //         let navigationBar = navigationController?.navigationBar
        //          navigationBar?.layoutIfNeeded()
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,
                                                                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold) ]
        //         navigationBar?.barTintColor = .clear
        //        navigationBar?.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        title = "Tiêng mưa"
    }
}
extension MusicDetail {
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
            player.delegate = self
            
            slideMusic.minimumValue = 0
            slideMusic.maximumValue = Float(player.duration)
            timer = Observable<Int>.interval(RxTimeInterval.milliseconds(1000), scheduler: MainScheduler.asyncInstance)
            
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func setupRX() {
        timer?.bind(onNext: { [weak self] (value) in
            guard let wSelf = self, var current = wSelf.player?.currentTime else {
                return
            }
             wSelf.slideMusic.value = Float(CGFloat(current))
//            guard current == wSelf.player?.duration  else {
//                wSelf.slideMusic.value = Float(CGFloat(current))
//                return
//            }
//            print("\(wSelf.slideMusic.value) ===== \(current) ====== \(wSelf.slideMusic.maximumValue)")
//
//            guard !wSelf.isReplay else {
//                wSelf.player?.pause()
//                return
//            }
//
//            wSelf.slideMusic.value = 0
//            current = 0
//            wSelf.player?.play()
        }).disposed(by: disposeBag)
        
//        NotificationCenter.default.rx.notification(NSNotification.Name.AVPlayerItemDidPlayToEndTime).bind { (isNo) in
//            print(isNo)
//        }.disposed(by: disposeBag)
        
        
//        NotificationCenter.default.addObserver(self, selector: Selector(("playerDidFinishPlaying:")),
//               name: NSNotification.Name.AVAudio, object: player?.currentTime)
//
//        func playerDidFinishPlaying(note: NSNotification) {
//            print("Video Finished")
//        }
        
        slideMusic.rx.value.bind { [weak self](value) in
            guard let wSelf = self else {
                return
            }
            wSelf.player?.pause()
            wSelf.player?.currentTime = TimeInterval(value)
            wSelf.player?.play()
        }.disposed(by: disposeBag)
        
        self.btPause.rx.tap.bind(onNext: weakify { wSelf in
            if wSelf.btPause.isSelected {
                wSelf.btPause.isSelected = false
                wSelf.player?.play()
            } else {
                wSelf.btPause.isSelected = true
                wSelf.player?.pause()
            }
        }).disposed(by: disposeBag)
        
        btReplay.rx.tap.bind(onNext: weakify { wSelf in
            if wSelf.btReplay.isSelected {
                wSelf.btReplay.isSelected = false
            } else {
                wSelf.btReplay.isSelected = true
                wSelf.isReplay = true
            }
        }).disposed(by: disposeBag)
    }
}
extension MusicDetail: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if isReplay {
            self.player?.pause()
            self.player?.play()
        }
    }
}
