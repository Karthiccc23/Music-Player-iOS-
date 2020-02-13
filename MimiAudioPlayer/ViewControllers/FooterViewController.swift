//
//  FooterViewController.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/3/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MusicPlayerViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var footerHeight: NSLayoutConstraint!
    @IBOutlet weak var footerStack: UIStackView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var trackStartTime: UILabel!
    @IBOutlet weak var trackEndTime: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var waveFormImageView: UIImageView!
    
    //MARK: Variables
    var trackInfo:TrackInfo?
    var trackUrl:String = ""
    private var trackViewModel = TracksViewModel()
    var timer:Timer!
    var player : AVPlayer?
    var playingTrack:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        playAudioInBackground()
        configurePausePlayBtn()
    }
    
    func setBorderForMusicPlayer(){
        footerView.layer.shadowOpacity = 0.7
        footerView.layer.shadowOffset = CGSize(width: 3, height: 3)
        footerView.layer.shadowRadius = 15.0
        footerView.layer.shadowColor = UIColor.black.cgColor
    }
    
    func configurePausePlayBtn(){
        playBtn.setImage(UIImage(named: "Pause"), for: .selected)
        playBtn.setImage(UIImage(named: "Play"), for: .normal)
    }
    
    func updateMusicPlayer(){
        updateTrackTitle()
        updateTrackEndTime()
        playTrack()
        bottomContraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    func playAudioInBackground(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }
    
    func updateTrackEndTime(){
        if let duration = trackInfo?.duration{
            let endTime = Int(duration)
            trackEndTime.text = endTime?.stringValue
        }
    }
    func updateTrackTitle(){
        guard let track = trackInfo else {
            trackTitle.text = ""
            return
        }
        trackTitle.text = track.title
    }
    
    func playTrack(){
        guard let track = trackInfo else {
            return
        }
        if !track.streamURL.isEmpty{
            self.trackUrl = track.streamURL
            loadTrack(trackURL: self.trackUrl)
        }
    }
    
    func drawWaveForm(){
        guard let url = trackInfo?.waveformData else { return }
        trackViewModel.getWaveformUrl(waveFormDataUrl: url){ array, error in
            DispatchQueue.main.async{
            if let nsArray = array as? NSArray {
               // Draw Image here.
                    let renderer = UIGraphicsImageRenderer(size: CGSize(width: nsArray.count, height: 255))
                    let img = renderer.image{ ctx in
                        ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
                        ctx.cgContext.setLineWidth(1.0)
                    
                        for (index, elem) in nsArray.enumerated() {
                            let value = elem as? Int ?? 0
                            ctx.cgContext.move(to: CGPoint(x: index, y: 255))
                            ctx.cgContext.addLine(to: CGPoint(x: index, y: 255 - value))
                        }
                        ctx.cgContext.strokePath()
                    }
                    self.waveFormImageView.image = img
                }
            }
        }
    }
    
    func loadTrack(trackURL: String) {
        guard let url = URL.init(string: trackURL) else { return }
        let playerItem = AVPlayerItem.init(url: url)
        player = AVPlayer.init(playerItem: playerItem)
        player?.play()
        playingTrack = true
        playBtn.isSelected = true
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        drawWaveForm()
    }
    
    @IBAction func pausePlay(_ sender: Any) {
        if playBtn.isSelected && playingTrack{
            player?.pause()
            playingTrack = false
            playBtn.isSelected = false
        }else{
            player?.play()
            playingTrack = true
            playBtn.isSelected = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        }
    }
    
    @objc func updateTime() {
        trackStartTime.text = player?.currentTime().stringValue
    }
}
