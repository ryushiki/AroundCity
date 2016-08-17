//
//  ArrayDataSource.swift
//  AroundCity
//
//  Created by liuzhihui on 16/8/17.
//  Copyright © 2016年 liuzhihui. All rights reserved.
//

import UIKit

typealias TableViewCellConfigureBlock = (cell:UITableViewCell, item:Dictionary<String,String>) -> ()

class ArrayDataSource: NSObject, UITableViewDataSource {

    var items:[AnyObject]
    var cellIdentifier:String
    var configureCellBlock: TableViewCellConfigureBlock
    
    init(items: [AnyObject], cellIdentifier: String, configureCellBlock: TableViewCellConfigureBlock ) {
        //init method
        self.items = items
        self.cellIdentifier = cellIdentifier
        self.configureCellBlock = configureCellBlock
    }
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> AnyObject {
        return self.items[indexPath.row]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        
        let item = self.itemAtIndexPath(indexPath)
        self.configureCellBlock(cell: cell, item: item as! Dictionary<String, String>)
        return cell
    }
}
