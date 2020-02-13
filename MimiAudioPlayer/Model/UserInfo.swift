//
//  UserInfo.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

// MARK: - User Information
struct UserInfo: Codable {
    let id, permalink, username, caption: String
    let uri, permalinkURL: String
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, permalink, username, caption, uri
        case permalinkURL = "permalink_url"
        case avatarURL = "avatar_url"
    }
}
