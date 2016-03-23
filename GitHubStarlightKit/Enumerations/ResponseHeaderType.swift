//
//  ResponseHeaderType.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public enum ResponseHeaderType {
    case RateLimitExceeded
    case HasNext
    case Finished
    
    public init(_ response: NSHTTPURLResponse) {
        if let link = response.allHeaderFields["Link"] as? String {
            if (link.componentsSeparatedByString(",").filter { $0.hasSuffix("rel=\"next\"") }.isEmpty) {
                self = .Finished
            } else {
                self = .HasNext
            }
        } else {
            self = .RateLimitExceeded
        }
    }
}
