//
//  ArtistListViewController.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView


class ArtistListViewController: UIViewController,NVActivityIndicatorViewable {
    
    //Mark: Outlets
    @IBOutlet weak var artistTableView: UITableView!
    
    //Mark: Variables
    private var artistListViewModel = ArtistListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTopArtists()
    }
    
    // MARK: - Fetch Top Artists
    @objc func getTopArtists() {
        startAnimating(type: .audioEqualizer)
        self.artistListViewModel.fetchTopArtists{ (artistInfo,error) in
            self.stopAnimating()
            if error == nil && artistInfo != nil {
                DispatchQueue.main.async {
                    self.artistTableView.reloadData()
                }
            } else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
}

extension ArtistListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistListViewModel.numberOfTopTracks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell") as! ArtistTableViewCell
        let artistInfo = self.artistListViewModel.getTopTrackArtistAtIndex(indexPath: indexPath)
        
        cell.artistImage.downloaded(from: artistInfo.avatarURL)
        cell.artistName.text = artistInfo.permalink
        cell.likesCount.text = String(artistInfo.likesCount)
        cell.artistTracks.text = String(artistInfo.trackCount)
        cell.followersCount.text = String(artistInfo.followersCount)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if artistListViewModel.numberOfTopTracks() > 0 {
            tableView.separatorStyle = .singleLine
            numOfSections            = 1
            tableView.backgroundView = nil
        }
        else{
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = ""
            noDataLabel.textColor     = UIColor.black
            noDataLabel.numberOfLines = 2
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "TracksViewController") as! TracksViewController
        vc.artistInfo = self.artistListViewModel.getTopTrackArtistAtIndex(indexPath: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}


class ArtistTableViewCell:UITableViewCell {
    @IBOutlet weak var artistImage: UIImageView!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var artistTracks: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
}
