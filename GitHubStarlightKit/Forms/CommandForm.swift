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
        let count = arguments.count
        guard count > 1 else { throw Error.InvalidCommand }
        let query = arguments[1]
        let tokens: [String]
        if count > 2 {
            tokens = Array(arguments[2..<count])
        } else {
            tokens = []
        }
        self.command = SearchCommand(query: query, tokens: tokens)
    }
}
