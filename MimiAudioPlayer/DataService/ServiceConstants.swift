//
//  ServiceConstants.swift
//  MimiAudioPlayer
//
//  Created by Karthic Paramasivam on 2/2/20.
//  Copyright © 2020 Karthic. All rights reserved.
//

import Foundation

enum Environment {
    
    case development
    case staging
    case production
    
    func baseURL() -> String {
        return "\(urlProtocol())://\(domain())"
    }
    
    func urlProtocol() -> String {
        switch self {
        case .production:
            return "https"
        default:
            return "https"
        }
    }
    
    func domain() -> String {
        switch self {
        case .development, .staging, .production:
            return "api-v2.hearthis.at/"
        }
    }
    
    func host() -> String {
        return "\(self.domain())"
    }
}


// MARK:- Development environment
#if DEBUG
let environment: Environment = Environment.development
#else
let environment: Environment = Environment.production
#endif

let baseUrl = environment.baseURL()

struct Path {
    var popularFeed: String {return "\(baseUrl)feed/?type=popular&page=1&count=20"}
}
