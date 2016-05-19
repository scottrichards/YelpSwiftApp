//
//  FilterViewController.swift
//  YelpSwiftApp
//
//  Created by Scott Richards on 5/18/16.
//  Copyright © 2016 Baby Center. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {

    var model : YelpFilters?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = YelpFilters.init(instance: YelpFilters.instance)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.model!.filters.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = self.model!.filters[section] as Filter
        if !filter.opened {
            if filter.type == FilterType.Single {
                return 1
            } else if filter.numItemsVisible > 0 && filter.numItemsVisible < filter.options.count {
                return filter.numItemsVisible! + 1
            }
        }
        return filter.options.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = self.model!.filters[section]
        let label = filter.label
        
        // Add the number of selected options for multiple-select filters with hidden options
        if filter.type == .Multiple && filter.numItemsVisible > 0 && filter.numItemsVisible < filter.options.count && !filter.opened {
            let selectedOptions = filter.selectedOptions
            return "\(label) (\(selectedOptions.count) selected)"
        }
        
        return label
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        
        let filter = self.model!.filters[indexPath.section] as Filter
        switch filter.type {
        case .Single:
            if filter.opened {
                let option = filter.options[indexPath.row]
                cell.textLabel!.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel!.text = filter.options[filter.selectedIndex].label
                cell.accessoryView = UIImageView(image: UIImage(named: "Dropdown"))
            }
        case .Multiple:
            if filter.opened || indexPath.row < filter.numItemsVisible {
                let option = filter.options[indexPath.row]
                cell.textLabel!.text = option.label
                if option.selected {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Check"))
                } else {
                    cell.accessoryView = UIImageView(image: UIImage(named: "Uncheck"))
                }
            } else {
                cell.textLabel!.text = "See All"
                cell.textLabel!.textAlignment = NSTextAlignment.Center
                cell.textLabel!.textColor = .darkGrayColor()
            }
        default:
            let option = filter.options[indexPath.row]
            cell.textLabel!.text = option.label
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            let switchView = UISwitch(frame: CGRectZero)
            switchView.on = option.selected
            switchView.onTintColor = UIColor(red: 73.0/255.0, green: 134.0/255.0, blue: 231.0/255.0, alpha: 1.0)
            switchView.addTarget(self, action: #selector(FilterViewController.handleSwitchValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
            cell.accessoryView = switchView
        }
        
        return cell
    }

 
    func handleSwitchValueChanged(switchView: UISwitch) -> Void {
        let cell = switchView.superview as! UITableViewCell
        if let indexPath = self.tableView.indexPathForCell(cell) {
            let filter = self.model!.filters[indexPath.section] as Filter
            let option = filter.options[indexPath.row]
            option.selected = switchView.on
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let filter = self.model!.filters[indexPath.section]
        switch filter.type {
        case .Single:
            if filter.opened {
                let previousIndex = filter.selectedIndex
                if previousIndex != indexPath.row {
                    filter.selectedIndex = indexPath.row
                    let previousIndexPath = NSIndexPath(forRow: previousIndex, inSection: indexPath.section)
                    self.tableView.reloadRowsAtIndexPaths([indexPath, previousIndexPath], withRowAnimation: .Automatic)
                }
            }
            
            let opened = filter.opened;
            filter.opened = !opened;
            
            if opened {
                let time = dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC)))
                dispatch_after(time, dispatch_get_main_queue(), {
                    self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
                })
            } else {
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            }
        case .Multiple:
            if !filter.opened && indexPath.row == filter.numItemsVisible {
                filter.opened = true
                self.tableView.reloadSections(NSMutableIndexSet(index: indexPath.section), withRowAnimation: .Automatic)
            } else {
                let option = filter.options[indexPath.row]
                option.selected = !option.selected
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        default:
            break
        }
    }

}
