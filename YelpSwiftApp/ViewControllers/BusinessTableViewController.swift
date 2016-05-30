//
//  BusinessTableViewController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/17/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController {
    var loadingMoreView:InfiniteScrollActivityView?
    var businesses : [YelpBusiness]?;
    var userLocation: UserLocation = UserLocation()
    var offset : UInt = 0
    var limit : UInt = 10
    var isLoadingData : Bool = false
    var searchTerm : String = "Restaurants"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "BusinessCellTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "BusinessCellTableViewCell")
        isLoadingData = true
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.startAnimating()
        
        tableView.addSubview(loadingMoreView!)
        
        YelpClient.sharedInstance.searchWithTerm(searchTerm,offset: offset, limit: limit) {
            ( results : [YelpBusiness]?, error : NSError?) in
            self.isLoadingData = false
            self.loadingMoreView!.stopAnimating()
            self.offset += UInt((results?.count)!)
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
                dequeuedCell.business = businesses![row]
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
 //       navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let business = self.businesses![indexPath.row]
        vc.business = business 
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    func onFiltersDone() {
        print("reDoSearch")
        startLoadingData()
        YelpClient.sharedInstance.searchWithParams(self.getSearchParameters()) {
            (results : [YelpBusiness]?, error : NSError?) in
            self.stopLoadingData()
            self.businesses = results
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Loading progress indicator 
    
    // updates the loading status and displays the progress indicator while data is being retrieved
    func startLoadingData()
    {
        isLoadingData = true
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
    }
    
    // clears the loading status and hides the progress indicator while data is being retrieved
    func stopLoadingData()
    {
        self.isLoadingData = false
        self.loadingMoreView!.stopAnimating()
    }
    
    //MARK: - Scroll Delegate
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isLoadingData) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if (scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                startLoadingData()
                YelpClient.sharedInstance.searchWithTerm(searchTerm,offset: offset, limit: limit) {
                    ( results : [YelpBusiness]?, error : NSError?) in
                    self.stopLoadingData()
                    self.offset += UInt((results?.count)!)
                    if let resultsArray = results {
                        if let _ = self.businesses {
                            self.businesses! += resultsArray
                        }
                    }
                    self.tableView.reloadData()
                }
            }
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
