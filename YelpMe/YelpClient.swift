//
//  YelpClient.swift
//  YelpMe
//
//  Created by Kevin Farst on 2/9/15.
//  Copyright (c) 2015 Kevin Farst. All rights reserved.
//

import Foundation

class YelpClient: BDBOAuth1RequestOperationManager {
    var accessToken: String!
    var accessSecret: String!
    
    let baseUrl = NSURL(string: "http://api.yelp.com/v2/")
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(consumerKey: String!, consumerSecret secret: String!, accessToken: String!, accessSecret: String!) {
        self.accessToken = accessToken
        self.accessSecret = accessSecret
        
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: secret);
        
        var token = BDBOAuth1Credential(token: accessToken, secret: accessSecret, expiration: nil)
       
        self.requestSerializer.saveAccessToken(token)
    }
    
    func getCommaSeparatedString(arr: [String]) -> String {
        var str : String = ""
        for (idx, item) in enumerate(arr) {
            str += "\(item)"
            if idx < arr.count-1 {
                str += ","
            }
        }
        return str
    }
    
    func search(term: String, categories: [String], dealsFilter: Bool, radiusFilter: Int, sortByFilter: Int, offset: Int, limit: Int, success: (AFHTTPRequestOperation!, AnyObject!) -> Void, failure: (AFHTTPRequestOperation!, NSError!) -> Void) -> AFHTTPRequestOperation! {
        // For additional parameters, see http://www.yelp.com/developers/documentation/v2/search_api
        var categoriesString = getCommaSeparatedString(categories)
        
        NSLog(categoriesString)
        
        var parameters = ["term": term, "location": "San Francisco", "category_filter" : categoriesString, "deals_filter": dealsFilter, "sort": sortByFilter, "offset": offset, "limit": limit] as NSMutableDictionary
        
        if (radiusFilter > 0) {
            parameters["radius_filter"] = radiusFilter
        }
        return self.GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}