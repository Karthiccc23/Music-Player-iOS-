//
//  TracksViewController.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/3/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView

class TracksViewController: UIViewController,NVActivityIndicatorViewable {
    
    //MARK: Outlets
    @IBOutlet weak var tracksTableView: UITableView!
    
    //MARK: Variables
    var artistInfo:ArtistInfo?
    private var tracksViewModel = TracksViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard self.artistInfo != nil else {
            return
        }
        getTrackInfo()
    }
    
    func getTrackInfo(){
//        startAnimating(type: .audioEqualizer)
        self.tracksViewModel.fetchTracksFromArtist(artistId: artistInfo!.permalink){ (tracksInfo,error) in
//            self.stopAnimating()
            if error == nil && tracksInfo != nil {
                DispatchQueue.main.async {
                    self.tracksTableView.reloadData()
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension TracksViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracksViewModel.numberOfTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TracksTableViewCell") as! TracksTableViewCell
        let trackInfo = self.tracksViewModel.getTrackAtIndex(indexPath: indexPath)
        cell.trackId.text = String(indexPath.row + 1)
        cell.trackName.text = trackInfo.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if tracksViewModel.numberOfTracks() > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = ""
            noDataLabel.textColor     = UIColor.black
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackInfo = tracksViewModel.getTrackAtIndex(indexPath: indexPath)
        if let footerVC = self.parent?.parent as? MusicPlayerViewController {
            footerVC.trackInfo = trackInfo
            footerVC.setBorderForMusicPlayer()
            footerVC.updateMusicPlayer()
        }
    }
}

class TracksTableViewCell:UITableViewCell{
    @IBOutlet weak var trackId: UILabel!
    @IBOutlet weak var trackName: UILabel!
}
