//
//  WebApiClient.swift
//  AroundCity
//
//  Created by liuzhihui on 16/8/16.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit
import CoreLocation

typealias SuccessHandler = (status: Int, resultJson: NSDictionary?) -> ()
typealias FailureHandler = (error: NSError!) -> ()

class WebApiClient: NSObject {
    static let webApiClient = WebApiClient()
    
    //private init
    private override init() {}
    
    func fetchOpenData(location: CLLocationCoordinate2D, successHandler:SuccessHandler, failureHandler: FailureHandler) {
        let requestStr = String(format: "https://infra-api.city.kanazawa.ishikawa.jp/v1/facilities/search.json?lang=ja&genre=1&count=15&geocode=%f,%f,50000", location.latitude, location.longitude)
        
        guard let url = NSURL.init(string: requestStr) else {
            return
        }
        
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let dataTask = defaultSession.dataTaskWithURL(url) {
            data, response, error in
            if let error = error {
                failureHandler(error: error)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String:AnyObject] {
                            if let statusCode = json["code"] as? Int {
                                successHandler(status: statusCode , resultJson: json)
                            } else {
                                successHandler(status: -1, resultJson: json)
                            }
                        } else {
                            successHandler(status: -1, resultJson: nil)
                        }
                    } catch let error as NSError {
                        failureHandler(error: error)
                    }
                } else {
                    
                }
            }
        }
        dataTask.resume()
    }
    
}
