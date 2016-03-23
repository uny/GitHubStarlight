//
//  SearchCommandTests.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import XCTest
@testable import GitHubStarlightKit

final class SearchCommandTests: XCTestCase {
    private let command = SearchCommand(query: "language:swift+stars:>3000")

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatItCreatesNewFIle()  {
        let fileName = self.command.createNewFile()
        let fileExists = NSFileManager.defaultManager().fileExistsAtPath(fileName)
        XCTAssertTrue(fileExists)
    }
}
