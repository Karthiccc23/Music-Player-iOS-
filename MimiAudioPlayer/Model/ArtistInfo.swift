//
//  Artist.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

// MARK: - Artist Information
struct ArtistInfo: Codable {
    let id, permalink, username, caption: String
    let uri, permalinkURL: String
    let thumbURL, avatarURL, backgroundURL: String
    let artistDescription, geo: String
    let trackCount, playlistCount, likesCount, followersCount: Int
    let followingCount: Int
    let following, premium: Bool
    let allowPush: Int
    
    enum CodingKeys: String, CodingKey {
        case id, permalink, username, caption, uri
        case permalinkURL = "permalink_url"
        case thumbURL = "thumb_url"
        case avatarURL = "avatar_url"
        case backgroundURL = "background_url"
        case artistDescription = "description"
        case geo
        case trackCount = "track_count"
        case playlistCount = "playlist_count"
        case likesCount = "likes_count"
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case following, premium
        case allowPush = "allow_push"
    }
}
