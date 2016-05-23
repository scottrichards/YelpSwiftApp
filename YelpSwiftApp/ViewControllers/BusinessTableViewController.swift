//
//  BusinessTableViewController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/17/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController {

    var businesses : NSArray?;
    var userLocation: UserLocation = UserLocation()
    var offset : UInt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "BusinessCellTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "BusinessCellTableViewCell")
        YelpClient.sharedInstance.searchWithTerm("Restaurants") {
            ( results : [AnyObject]?, error : NSError?) in
            self.businesses = results
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (businesses == nil) {
            return 0
        } else {
            return (businesses?.count)!
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "BusinessCellTableViewCell"
        var cell: UITableViewCell?
        let row = indexPath.row
        if let dequeuedCell : BusinessCellTableViewCell = tableView.dequeueReusableCellWithIdentifier(identifier) as? BusinessCellTableViewCell {
            if (businesses?.count > row) {
                dequeuedCell.business = businesses![row] as? YelpSwiftBusiness
            }
            cell = dequeuedCell
        }
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let filterViewController:FilterViewController = segue.destinationViewController as? FilterViewController {
            filterViewController.delegate = self
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc : DetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("detailsController") as! DetailsController
        let business = self.businesses![indexPath.row]
        vc.business = business as? YelpSwiftBusiness
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    func onFiltersDone() {
        print("reDoSearch")
        YelpClient.sharedInstance.searchWithParams(self.getSearchParameters()) {
            (results : [AnyObject]?, error : NSError?) in
            print("result")
            self.businesses = results
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Business Logic
    
    func getSearchParameters() -> Dictionary<String, String> {
        let userLocation = (UIApplication.sharedApplication().delegate as! AppDelegate).userLocation
        var parameters = [
            "ll": "\(userLocation.latitude),\(userLocation.longitude)"
        ]
        
        for (key, value) in YelpFilters.instance.parameters {
            parameters[key] = value
        }
        return parameters
    }
}
