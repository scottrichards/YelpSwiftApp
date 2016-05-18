//
//  YelpClient.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/18/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import Foundation

// The output below is limited by 1 KB.
// Please Sign Up (Free!) to remove this limitation.

// You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
let kYelpConsumerKey: String = "cJL5QRpvSjF3k0UNbdhvSg"

let kYelpConsumerSecret: String = "lEaBTbu1MGc9tRUFwE9vqkX6TvU"

let kYelpToken: String = "Tj8hWSjzNc3qw-l-9HP3N3qwYpXbf3Iy"

let kYelpTokenSecret: String = "QMHf7YrrXKmdOTXeowtytqRjS1c"

class YelpClient : BDBOAuth1RequestOperationManager {
    // Singleton
    class SomeManager {
        static let sharedInstance = YelpClient()
    }
    
//    convenience override init() {
//        var baseURL: NSURL = NSURL(string: "https://api.yelp.com/v2/")!
//        super.init(baseURL: baseURL, consumerKey: kYelpConsumerKey, consumerSecret: kYelpConsumerSecret)
//        var token: BDBOAuth1Credential = BDBOAuth1Credential.credentialWithToken(kYelpToken, secret: kYelpTokenSecret, expiration: nil)
//    }
}