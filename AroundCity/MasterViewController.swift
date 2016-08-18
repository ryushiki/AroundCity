//
//  MasterViewController.swift
//  AroundCity
//
//  Created by liuzhihui on 16/8/14.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var facilities = [AnyObject]()
    var spotDataSource:ArrayDataSource?
    let cellId = "Cell"
    
    var locationService = LocationService.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationService.addObserver(self, forKeyPath: "nowLoc", options: .New, context: nil)
        locationService.startUpdateLocaton()
        
        self.setupTableView()
        
    }

    func setupTableView() {
        let configureCell = { (cell:UITableViewCell, item: NSDictionary) in
            let name = item.objectForKey("name")
            let address = item.objectForKey("addresss")
            
            cell.textLabel?.text = name as? String
            cell.detailTextLabel?.text = address as? String
        }
        
        spotDataSource = ArrayDataSource.init(items: facilities, cellIdentifier: cellId, configureCellBlock: configureCell)
        self.tableView.dataSource = spotDataSource
      
    }


    //MARK: - KVO observer
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "nowLoc" {
            WebApiClient.sharedInstance.fetchOpenData(locationService.nowLoc!.coordinate, successHandler: { (status, resultJson) in
                
                self.facilities = resultJson?.objectForKey("facilities") as! [AnyObject]
                self.spotDataSource?.items = self.facilities
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
                }
                }, failureHandler: { (error) in
                    
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "showDetail" {
//            let indexPath = self.tableView.indexPathForSelectedRow
//            
//            let item = facilities[indexPath!.row]
//            if let vc = segue.destinationViewController as? DetailViewController {
//                vc.setDetailItem(item, locationItems: locationItems)
//            }
//        }
    }
}

