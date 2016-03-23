//
//  main.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation
import GitHubStarlightKit

func main(arguments: [String]) {
    print(arguments)
    do {
        try CommandForm(arguments).command.execute()
    } catch let error {
        print(error)
    }
    NSRunLoop.mainRunLoop().run()
}
main(Process.arguments)
