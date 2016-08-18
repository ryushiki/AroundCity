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
    static let sharedInstance = WebApiClient()
    
    //private init
    private override init() {}
    
    func fetchOpenData(location: CLLocationCoordinate2D, successHandler:SuccessHandler, failureHandler: FailureHandler) {
        let requestStr = String(format: "https://infra-api.city.kanazawa.ishikawa.jp/v1/facilities/search.json?lang=ja&genre=1&count=15&geocode=%f,%f,50000", location.latitude, location.longitude)
        
        let url = NSURL.init(string: requestStr)
        let request = NSMutableURLRequest.init(URL: url!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let defaultSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        let dataTask = defaultSession.dataTaskWithRequest(request) {
            data, response, error in
            if let error = error {
                failureHandler(error: error)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? [String:AnyObject] {
                            successHandler(status: httpResponse.statusCode , resultJson: json)
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
