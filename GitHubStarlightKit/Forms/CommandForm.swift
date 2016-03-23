//
//  CommandForm.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public struct CommandForm {
    public let command: SearchCommand
    
    public init(_ arguments: [String]) throws {
        guard arguments.count > 1 else { throw Error.CommandError }
        let query = arguments[1]
        self.command = SearchCommand(query: query)
    }
}
