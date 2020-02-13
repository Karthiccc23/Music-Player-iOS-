//
//  ArtistListViewModel.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

class ArtistListViewModel{
    
    //MARK: Variables
    var topTracks:[TrackInfo] = []
    var userInfo:[UserInfo] = []
    var artistInfo:[ArtistInfo] = []
    let operationQueue: OperationQueue = OperationQueue()
    var musicService: MusicServiceProtocol
    
    init(musicService: MusicServiceProtocol  = MusicService()) {
        self.musicService = musicService
        operationQueue.maxConcurrentOperationCount = 1
    }
    
    func fetchPopularFeed(completion: @escaping (_ topTracksInfo: [TrackInfo]?,_ error: Error?) -> Void){
        musicService.getPopularMusic {(arrData, error) in
            if error == nil && arrData != nil {
                completion(arrData!,nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil,error)
            }
        }
    }
    
    func fetchTopArtists(completion: @escaping (_ topTracksInfo: [ArtistInfo]?,_ error: Error?) -> Void){
        self.fetchPopularFeed{ [weak self] (trackInfo,error)  in
            guard let _self = self, let topTracks = trackInfo else {
                completion(nil, error)
                return
                
            }
                _self.topTracks = topTracks
                for topTrack in topTracks {
                    let topTrackInfo:TrackInfo = topTrack
                    let userInfo:UserInfo = topTrackInfo.user
                    if userInfo.permalink.isEmpty {
                        continue
                    }
                    
                    let operation = FetchArtistOperation(userInfo.permalink, service:_self.musicService)
                    operation.completionBlock = {
                        if let info = operation.result {
                            self?.artistInfo.append(info)
                        }
                    }
                    self?.operationQueue.addOperation(operation)
                    
                }
            self?.operationQueue.addOperation {
                DispatchQueue.main.async {
                    completion(self?.artistInfo ?? [], nil)
                }
            }
        }
    }
    
    func fetchArtistInfo(artistId:String,completion: @escaping (_ artistInfo: ArtistInfo?,_ error: Error?) -> Void){
        musicService.getArtistInfo(artistId: artistId){ (arrData, error) in
            if error == nil && arrData != nil {
                let artistInfo:ArtistInfo = arrData!
                completion(artistInfo,nil)
            } else {
                print(error?.localizedDescription ?? "")
                completion(nil,error)
            }
        }
    }
    
    func numberOfTopTracks() ->Int {
        return self.artistInfo.count
    }
    
    func getTopTrackArtistAtIndex(indexPath:IndexPath) -> ArtistInfo {
        return self.artistInfo[indexPath.row]
    }
}

class FetchArtistOperation: Operation {
    private let artistId: String
    private let service:MusicServiceProtocol
    private let semaphore = DispatchSemaphore(value: 0)
    
    private(set) var result:ArtistInfo? = nil
    private(set) var error:Error? = nil
    
    init(_ artistId: String, service:MusicServiceProtocol) {
        self.artistId = artistId
        self.service = service
    }
    
    override func main(){
        guard !isCancelled else{
            return
        }
        service.getArtistInfo(artistId: artistId){ (arrData, error) in
            guard !self.isCancelled else { return }
            if error == nil && arrData != nil {
                self.result = arrData
            } else {
                print(error?.localizedDescription ?? "")
                self.error = error
            }
            self.semaphore.signal()
        }
        semaphore.wait()
    }
}
