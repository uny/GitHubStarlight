//
//  Repository.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public struct Repository {
    public let fullName:    String
    public let url:         String
    public let description: String
    public let stars:       Int
    
    public init(fullName: String, url: String, description: String, stars: Int) {
        self.fullName    = fullName
        self.url         = url
        self.description = description
        self.stars       = stars
    }
    
    public var data: NSData {
        let string = "|[\(fullName)](\(url))|\(description)|\(stars)|\n"
        return string.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
