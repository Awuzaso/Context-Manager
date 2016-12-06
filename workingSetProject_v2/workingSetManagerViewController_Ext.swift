//
//  View_Controller_Extension.swift
//  workingSetProject
//
//  Created by Osa on 6/23/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa


extension workingSetManagerViewController : NSTableViewDataSource {
    
    
    /*This function is called everytime there is a change in the table view.*/
    func updateStatus() {
        let index = tableView!.selectedRow
        
        // 1 - Get collection of objects from object graph.
        workingSets = singleton.coreDataObject.getDataObjects("WorkingDomain")
        
        // 2 - Set the current selection of working set from table view.
        let item = workingSets[tableView!.selectedRow]
        
        
        
        nameOfWS =  launchWindowTable.getItemSelected_String(tableView, managedObjectArray: workingSets, objectAttr: "nameOfWD")
        
        // 3 - When a working set is seleted from the table view, launch window buttons are then made available to be pressed.
        switchOnOffButtons(true,deleteActive: true,associateActive: false)
    }
    
    
    func tableViewDoubleClick(sender: AnyObject) {
        
        if(nameOfWS != nil){
            singleton.openedWD = nameOfWS
            NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
            self.openWDButton(self)
            nameOfWS = nil
        }
        else{
            print("Nothing is selected.")
            //openWDButton.enabled = false
        }
        
    }
    
    
    // Fine as is.
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        //1
        //let managedContext = appDelegate.managedObjectContext
        let managedContext = singleton.coreDataObject.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            workingSets = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return workingSets.count ?? 0
    }
    
    // Function sets the sorting schema, then calls on "reloadFileList()" to actually change table view.
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        print("Starting sort.")
    }

    
    
}

extension workingSetManagerViewController : NSTableViewDelegate {
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        
        updateStatus()
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        
        var text:String = ""
        var cellIdentifier: String = ""
        
        
        // 1 - Get Managed Object Context
        let managedContext = singleton.coreDataObject.managedObjectContext
        
        // 2 - Establish Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        
        // 3 - Attempt Fetch Request
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            workingSets = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        // 4 - Value to Fill Table as per Row
        var value = workingSets[row].valueForKey("nameOfWD") as? String
        var date = workingSets[row].valueForKey("dateLastAccessed") as? String
        // 5 Assign Value in Event that there is no Retrieved Value
        if(value == nil){
            value = "Unnamed"
        }
        
        // 6 - Specifying table column
        if tableColumn == tableView.tableColumns[0] {
            text = value!
            cellIdentifier = "NameCellID"
        } else if tableColumn == tableView.tableColumns[1] {
            text = date!
            cellIdentifier = "DateCellID"
        }
        
        // 7 - Fill cell content.
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        // 8
        return nil
    }
}


