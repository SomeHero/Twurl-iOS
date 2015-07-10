//
//  TwurlApiManager.swift
//  Twurl-iOS
//
//  Created by James Rhodes on 6/6/15.
//  Copyright (c) 2015 James Rhodes. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TwurlApiManager: NSObject {
    static func getTwurls(category_id: Int?, page_number: Int?, success: (response: JSON!) -> Void, failure: (NSError?) -> Void) {
        var category = ""
        if let v = category_id {
            category = "\(v)"
        }
        var page = ""
        if let v = page_number {
            page = "\(v)"
        }
        
        let params = ["category_id": category, "page_number": page]
        
        Alamofire.request(.GET, "https://twurl.herokuapp.com/api/v1/twurls", parameters: params)
            .responseJSON { (request, response, data, error) in
                if let anError = error {
                    failure(anError)
                }
                else if let data: AnyObject = data {
                    let json = JSON(data)
                    
                    success(response: json)
                }

        }
    }
    static func getCategories(success: (response: JSON!) -> Void, failure: (NSError?) -> Void) {
        Alamofire.request(.GET, "https://twurl.herokuapp.com/api/v1/categories")
            .responseJSON { (request, response, data, error) in
                if let anError = error {
                    failure(anError)
                }
                else if let data: AnyObject = data {
                    let json = JSON(data)
                    
                    success(response: json)
                }
                
        }
    }
}
