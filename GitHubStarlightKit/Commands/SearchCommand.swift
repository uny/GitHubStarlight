//
//  SearchCommand.swift
//  GitHubStarlight
//
//  Created by Yuki Nagai on 3/24/16.
//  Copyright © 2016 Yuki Nagai. All rights reserved.
//

import Foundation

public class SearchCommand {
    /**
     Repository: found repository
     Bool: finished or not
     */
    private typealias SearchHandler = (Repository, Bool) -> Bool
    
    private let query: String
    private var tokens: [String]
    private let session: NSURLSession
    
    public init(query: String, tokens: [String], session: NSURLSession = NSURLSession.sharedSession()) {
        self.query   = query
        self.tokens  = tokens
        self.session = session
    }
    
    public func execute() throws {
        let fileName = self.createNewFile()
        print("File Name: \(fileName)")
        print("=====================================================")
        self.search { repositoy, finished in
            print("\(repositoy.fullName): \(repositoy.stars)")
            let fileHandle = NSFileHandle(forWritingAtPath: fileName)!
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(repositoy.data)
            fileHandle.closeFile()
            if finished {
                print("===Finished.===")
            }
        }
    }
    
    public func createNewFile() -> String {
        let fileDate = "\(NSDate().timeIntervalSince1970)".stringByReplacingOccurrencesOfString(".", withString: "")
        let fileName = "githubstarlight\(fileDate).md"
        let contents = "# GitHub Search Result\n" + "Search query: \(self.query)\n\n" + "|Name|Stars|Description|\n" + "|:---:|:---:|:---|\n"
        NSFileManager.defaultManager().createFileAtPath(fileName, contents: contents.dataUsingEncoding(NSUTF8StringEncoding), attributes: nil)
        return fileName
    }
    
    public func search(page: Int = 1, handler: (Repository, Bool) -> Void) {
        let url = NSURL(string: "https://api.github.com/search/repositories?sort=stars&order=desc&page=\(page)&q=\(self.query)")!
        let request = NSMutableURLRequest(URL: url)
        if let token = tokens.first {
            request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        let task = self.session.dataTaskWithRequest(request) { data, response, error in
            let headerType = ResponseHeaderType(response as! NSHTTPURLResponse)
            if headerType == .RateLimitExceeded {
                if self.tokens.count > 1 {
                    self.tokens.removeFirst()
                    self.search(page, handler: handler)
                } else {
                    print("===Rate Limit Exceeded.===")
                }
                return
            }
            let items = JSON(data: data!)["items"].arrayValue
            for (index, item) in items.enumerate() {
                let repository = Repository(
                    fullName: item["full_name"].stringValue,
                    url: item["html_url"].stringValue,
                    description: item["description"].stringValue,
                    stars: item["stargazers_count"].intValue)
                let finished = headerType == .Finished && index == items.count - 1
                handler(repository, finished)
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
