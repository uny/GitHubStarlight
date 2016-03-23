//
//  SearchCommand.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public struct SearchCommand {
    private let query: String
    private let session: NSURLSession
    
    public init(query: String, session: NSURLSession = NSURLSession.sharedSession()) {
        self.query   = query
        self.session = session
    }
    
    public func execute() {
        let fileName = self.createNewFile()
        self.search { repositoy in
            let fileHandle = NSFileHandle(forWritingAtPath: fileName)!
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(repositoy.data)
            fileHandle.closeFile()
        }
    }
    
    public func createNewFile() -> String {
        let fileDate = "\(NSDate().timeIntervalSince1970)".stringByReplacingOccurrencesOfString(".", withString: "")
        let fileName = "githubstarlight\(fileDate).md"
        let contents = "# GitHub Search Result\n" + "Search query: \(self.query)\n\n" + "|Name|Stars|Description|\n" + "|:---:|:---:|:---|\n"
        NSFileManager.defaultManager().createFileAtPath(fileName, contents: contents.dataUsingEncoding(NSUTF8StringEncoding), attributes: nil)
        return fileName
    }
    
    public func search(page: Int = 1, handler: (repository: Repository) -> Void) {
        let url = NSURL(string: "https://api.github.com/search/repositories?sort=stars&order=desc&page=\(page)&q=\(self.query)")!
        let request = NSMutableURLRequest(URL: url)
        if let token = NSProcessInfo.processInfo().environment["GITHUB_TOKEN"] {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = self.session.dataTaskWithRequest(request) { data, response, error in
            let json = JSON(data: data!)
            for item in json["items"].arrayValue {
                let repository = Repository(
                    fullName: item["full_name"].stringValue,
                    url: item["url"].stringValue,
                    description: item["description"].stringValue,
                    stars: item["stargazers_count"].intValue)
                handler(repository: repository)
            }
            if self.hasNext(response as! NSHTTPURLResponse) {
                self.search(page + 1, handler: handler)
            }
        }
        task.resume()
    }
    
    public func hasNext(response: NSHTTPURLResponse) -> Bool {
        let link = response.allHeaderFields["Link"] as! String
        let isEmpty = link.componentsSeparatedByString(",").filter { $0.hasSuffix("rel=\"next\"") }.isEmpty
        return !isEmpty
    }
}
