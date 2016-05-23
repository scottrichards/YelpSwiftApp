//
//  YelpClient.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/20/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import Foundation


class YelpClient : BDBOAuth1RequestOperationManager
{
    enum SortOrder {
        case BestMatched
        case ModeDistance
        case HighestRated
    }
    
    private static var _sharedInstance : YelpClient? = nil
    static var sharedInstance : YelpClient {
        get {
            if let _sharedInstance = _sharedInstance {
                return _sharedInstance
            } else {
                _sharedInstance = YelpClient()
                return _sharedInstance!
            }
        }
    }
    
    struct keys {
        static let kYelpConsumerKey = "cJL5QRpvSjF3k0UNbdhvSg"
        static let kYelpConsumerSecret = "lEaBTbu1MGc9tRUFwE9vqkX6TvU"
        static let kYelpToken = "Tj8hWSjzNc3qw-l-9HP3N3qwYpXbf3Iy"
        static let kYelpTokenSecret = "QMHf7YrrXKmdOTXeowtytqRjS1c"
    }
    
    // initialize with BaseURL pass Token and Keys
    init() {
        let baseURL : NSURL? = NSURL(string: "https://api.yelp.com/v2/")
        super.init(baseURL: baseURL, consumerKey: keys.kYelpConsumerKey, consumerSecret: keys.kYelpConsumerSecret)
        let token : BDBOAuth1Credential = BDBOAuth1Credential(token: keys.kYelpToken, secret: keys.kYelpTokenSecret, expiration: nil)
        self.requestSerializer.saveAccessToken(token)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchWithParams(params : NSDictionary, completionHandler: (businesses : [AnyObject]?,error : NSError?) -> Void) {
        for param in params {
            print("param: \(param)")
        }
        self.GET("search", parameters: params,
                 success: {
                    (operation : AFHTTPRequestOperation, result : AnyObject) in
                    print("success")
                    let businesses : [AnyObject] = result["businesses"] as! [AnyObject]
                    completionHandler(businesses: YelpSwiftBusiness.businessesFromJsonArray(businesses) as [AnyObject], error: nil)
            },
                 
                 failure: {
                    (operation : AFHTTPRequestOperation?, error : NSError) in
                    print("failure")
                    completionHandler(businesses: nil, error: error)
            }
        )
    }
    
    func searchWithTerm(term : String?, completion : (businesses:[AnyObject]?, error : NSError?) -> Void) {
        let params : NSMutableDictionary? = ["ll":"37.774866,-122.394556"]
        if let term = term {
            params?.setObject(term, forKey:"term")
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if (appDelegate.userLocation.foundLocation == true) {
            params?.setObject("\(appDelegate.userLocation.latitude),\(appDelegate.userLocation.longitude)", forKey: "ll")
        }
        self.searchWithParams(params!, completionHandler: completion)
    }
    
//    func searchWithTerm(term : String?, sortMode : SortOrder? = .BestMatched, completion : ([AnyObject]?, error : NSError?)) {
//        
//    }
    
}