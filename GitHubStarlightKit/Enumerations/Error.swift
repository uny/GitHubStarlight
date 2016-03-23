//
//  Error.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public enum Error: ErrorType {
    case CommandError
    
    public var message: String {
        return ""
    }
}
