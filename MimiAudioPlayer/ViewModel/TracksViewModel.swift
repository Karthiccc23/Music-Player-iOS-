//
//  TracksViewModel.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/3/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

class TracksViewModel{
    var tracksInfo:[TrackInfo] = []
    var musicService: MusicServiceProtocol
    var trackInfo:TrackInfo?
    
    init(musicService: MusicServiceProtocol  = MusicService()) {
        self.musicService = musicService
    }
    
    func fetchTracksFromArtist(artistId:String,completion: @escaping (_ tracksInfo: [TrackInfo]?,_ error: Error?) -> Void){
        musicService.getTracksfromArtist(artistId: artistId){[weak self] (arrData, error) in
            if error == nil && arrData != nil {
                self?.tracksInfo = arrData!
                completion(self?.tracksInfo,nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil,error)
            }
        }
    }
    
    func numberOfTracks() ->Int {
        return self.tracksInfo.count
    }
    
    func getTrackAtIndex(indexPath:IndexPath) -> TrackInfo {
        return self.tracksInfo[indexPath.row]
    }
    
    func getWaveformUrl(waveFormDataUrl:String, completion: @escaping (Any?, Error?) -> Void){
        musicService.getWaveformData(cMimiWaveformUrl: waveFormDataUrl, completion: completion)
    }
}
