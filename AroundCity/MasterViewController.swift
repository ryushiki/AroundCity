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
    let cellId = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    func setupTableView() {
        let configureCell = { (cell:UITableViewCell, item: Dictionary<String,String>) in
            let name = item["name"]
            let address = item["address"]
            
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = address
        }
        
//        spotDataSource = ArrayDataSource.init(items: facilities, cellIdentifier: cellId, configureCellBlock: configureCell)
    }


}

