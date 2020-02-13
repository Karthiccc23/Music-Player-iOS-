//
//  PopularMusic.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

// MARK: - Track Information
struct TrackInfo: Decodable {
    let id, createdAt, releaseDate: String
    let releaseTimestamp: Int
    let userID, duration, permalink, welcomeDescription: String
    let geo, tags, tagedArtists, bpm: String
    let key, license, version, type: String
    let genre, genreSlush, title: String
    let commentCount,downloadable,playbackCount,downloadCount,resharesCount,favoritingsCount:DynamicJSONProperty
    let uri, permalinkURL: String
    let thumb,artworkURL, artworkURLRetina, backgroundURL: String
    let waveformData: String
    let waveformURL: String
    let user: UserInfo
    let streamURL: String
    let previewURL: String
    let downloadURL: String
    let downloadFilename: String
    let played, favorited, liked, reshared: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case releaseDate = "release_date"
        case releaseTimestamp = "release_timestamp"
        case userID = "user_id"
        case duration, permalink
        case welcomeDescription = "description"
        case geo, tags
        case tagedArtists = "taged_artists"
        case bpm, key, license, version, type, downloadable, genre
        case genreSlush = "genre_slush"
        case title, uri
        case permalinkURL = "permalink_url"
        case thumb
        case artworkURL = "artwork_url"
        case artworkURLRetina = "artwork_url_retina"
        case backgroundURL = "background_url"
        case waveformData = "waveform_data"
        case waveformURL = "waveform_url"
        case user
        case streamURL = "stream_url"
        case previewURL = "preview_url"
        case downloadURL = "download_url"
        case downloadFilename = "download_filename"
        case playbackCount = "playback_count"
        case downloadCount = "download_count"
        case favoritingsCount = "favoritings_count"
        case resharesCount = "reshares_count"
        case commentCount = "comment_count"
        case played, favorited, liked, reshared
    }
}

enum DynamicJSONProperty: Codable {
    case int(Int)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()
        
        // Decode the double
        do {
            let intVal = try container.decode(Int.self)
            self = .int(intVal)
        } catch DecodingError.typeMismatch {
            // Decode the string
            let stringVal = try container.decode(String.self)
            self = .string(stringVal)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
