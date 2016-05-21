//
//  YelpSwiftClient.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/20/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import Foundation


class YelpSwiftClient : BDBOAuth1RequestOperationManager
{
    private static var _sharedInstance : YelpSwiftClient? = nil
    static var sharedInstance : YelpSwiftClient {
        get {
            if let _sharedInstance = _sharedInstance {
                return _sharedInstance
            } else {
                _sharedInstance = YelpSwiftClient()
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
                    completionHandler(businesses: YelpBusiness.businessesFromJsonArray(businesses), error: nil)
            },
                 
                 failure: {
                    (operation : AFHTTPRequestOperation?, error : NSError) in
                    print("failure")
                    completionHandler(businesses: nil, error: error)
            }
        )
//        self GET:@"search"
//        parameters:params
//        success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            
//            NSArray *businesses = responseObject[@"businesses"];
//            completion([YelpBusiness businessesFromJsonArray:businesses], nil);
//            
//        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
//            completion(nil, error);
//        }];

  //      completionHandler()
    }
}