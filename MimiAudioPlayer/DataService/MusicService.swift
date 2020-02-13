//
//  MusicService.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation


// Music API Services
protocol MusicServiceProtocol {
    func getPopularMusic(completion: @escaping (_ arrPopularMusic: [TrackInfo]?, _ error: Error?) -> Void)
    
    func getArtistInfo(artistId:String,completion: @escaping (_ arrArtistInfo: ArtistInfo?, _ error: Error?) -> Void)
    
    func getTracksfromArtist(artistId:String,completion: @escaping (_ arrArtistInfo: [TrackInfo]?, _ error: Error?) -> Void)
    
    func getWaveformData(cMimiWaveformUrl:String, completion: @escaping (Any?, Error?) -> Void)
}


class MusicService:MusicServiceProtocol {
    let cMimiApiUrl = Environment.development.baseURL()
    let cMimiPopularFeedApiUrl = Path().popularFeed
    func getPopularMusic(completion: @escaping ([TrackInfo]?, Error?) -> Void) {
        guard let url = URL(string: cMimiPopularFeedApiUrl) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                completion(nil, err)
            }
            if let dataResponse = data {
                do{
                    let decoder = JSONDecoder()
                    let arr = try decoder.decode([TrackInfo].self, from:
                        dataResponse)
                    completion(arr, nil)
                } catch let parsingError {
                    print("Error", parsingError)
                    completion(nil, parsingError)
                }
            }
        }
        task.resume()
    }
    
    func getArtistInfo(artistId:String,completion: @escaping (ArtistInfo?, Error?) -> Void) {
        guard let url = URL(string: cMimiApiUrl+artistId) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                completion(nil, err)
            }
            if let dataResponse = data {
                do{
                    let decoder = JSONDecoder()
                    let arr = try decoder.decode(ArtistInfo.self, from:
                        dataResponse)
                    completion(arr, nil)
                } catch let parsingError {
                    print("Error", parsingError)
                    completion(nil, parsingError)
                }
            }
        }
        task.resume()
    }
    
    func getTracksfromArtist(artistId:String,completion: @escaping ([TrackInfo]?, Error?) -> Void) {
        guard let url = URL(string: cMimiApiUrl+artistId+"/?type=tracks&page=1&count=20") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let err = error {
                completion(nil, err)
            }
            if let dataResponse = data {
                do{
                    let decoder = JSONDecoder()
                    let arr = try decoder.decode([TrackInfo].self, from:
                        dataResponse)
                    completion(arr, nil)
                } catch let parsingError {
                    print("Error", parsingError)
                    completion(nil, parsingError)
                }
            }
        }
        task.resume()
    }
    
    func getWaveformData(cMimiWaveformUrl:String, completion: @escaping (Any?, Error?) -> Void) {
        guard let url = URL(string: cMimiWaveformUrl) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data else {
                    completion(nil, error)
                return
            }
                do{
                    print("DATA")
                    print(dataResponse)
                    let byteArray = try JSONSerialization.jsonObject(with: dataResponse, options: [])
                    completion(byteArray, nil)
                
                } catch let parsingError {
                    print("Error", parsingError)
                    completion(nil, parsingError)
                }
        }
        task.resume()
    }
}
