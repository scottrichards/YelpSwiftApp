//
//  BusinessTableViewController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/17/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class BusinessTableViewController: UITableViewController, UISearchBarDelegate {
    var loadingMoreView:InfiniteScrollActivityView?
    var businesses : [YelpBusiness]?;   // array of business used to populate table data source
    var userLocation: UserLocation = UserLocation()
    var offset : UInt = 0           // offset for next request from Yelp
    var limit : UInt = 20           // # of records to request from yelp at a time
    var isLoadingData : Bool = false    // true when waiting for data to load
    var filterOn : Bool = false     // true if we are doing filter vs. search term in search bar
    var searchTerm : String = ""    // search term from the search bar
    var searchBar : UISearchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "BusinessCellTableViewCell", bundle:nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: "BusinessCellTableViewCell")
    
        // Add < for the back bar item
        navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        // create the search bar programatically since you won't be
        // able to drag one onto the navigation bar
        searchBar.sizeToFit()
        searchBar.delegate = self
        
        // the UIViewController comes with a navigationItem property
        // this will automatically be initialized for you if when the
        // view controller is added to a navigation controller's stack
        // you just need to set the titleView to be the search bar
        navigationItem.titleView = searchBar
        
        
        isLoadingData = true
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        tableView.addSubview(loadingMoreView!)
        doSearchWithTerm(searchTerm)
    }
    
    // start a search with the search term
    func doSearchWithTerm(searchTerm : String)
    {
        filterOn = false
        offset = 0  // clear out the offset when doing a new search
        loadingMoreView!.startAnimating()
        YelpClient.sharedInstance.searchWithTerm(searchTerm, offset: offset, limit: limit) {
            ( results : [YelpBusiness]?, error : NSError?) in
            self.isLoadingData = false
            self.loadingMoreView!.stopAnimating()
            self.offset += UInt((results?.count)!)
            self.businesses = results
            self.tableView.reloadData()
        }
    }
    
    
    //MARK: - UITableView DataSource
    
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
        return 87.0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let filterViewController:FilterViewController = segue.destinationViewController as? FilterViewController {
            filterViewController.delegate = self
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc : DetailsController = self.storyboard!.instantiateViewControllerWithIdentifier("detailsController") as! DetailsController
        let business = self.businesses![indexPath.row]
        vc.business = business 
        self.showViewController(vc as UIViewController, sender: vc)
    }
    
    // Filter based on specified filter criteria
    func onFiltersDone() {
        print("reDoSearch")
        startLoadingData()
        offset = 0
        filterOn = true
        searchTerm = ""
        searchBar.text = ""
        YelpClient.sharedInstance.searchWithParams(self.getSearchParameters(), offset: offset, limit: limit) {
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
                if (filterOn) {     // if we are filtering
                    YelpClient.sharedInstance.searchWithParams(self.getSearchParameters(), offset: offset, limit: limit) {
                        (results : [YelpBusiness]?, error : NSError?) in
                        self.stopLoadingData()
                        if let resultsArray = results {
                            if let _ = self.businesses {
                                self.businesses! += resultsArray
                            }
                            self.offset += UInt((results?.count)!)
                        }
                        self.tableView.reloadData()
                    }
                } else {
                    YelpClient.sharedInstance.searchWithTerm(searchTerm,offset: offset, limit: limit) {
                        ( results : [YelpBusiness]?, error : NSError?) in
                        self.stopLoadingData()
                        if let resultsArray = results {
                            if let _ = self.businesses {
                                self.businesses! += resultsArray
                            }
                            self.offset += UInt((results?.count)!)
                        }
                        self.tableView.reloadData()
                    }
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
    
    //MARK: - UISearchBar Delegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        if let searchBarText = searchBar.text {
            searchTerm = searchBarText
        }
        doSearchWithTerm(searchTerm)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchTerm = ""
        searchBar.resignFirstResponder()
        doSearchWithTerm(searchTerm)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
    }
}
