//
//  WorkingDomainController_Ext.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/9/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa


extension WorkingDomainController : NSTableViewDataSource {

    /*This function is called everytime there is a change in the table view.*/
    func updateStatus() {
        // 1 - Get collection of objects from object graph.
        //workingSets = singleton.coreDataObject.getDataObjects("WorkingDomain")
        
        // 2 - Set the current selection of working set from table view.
        //let item = workingSets[tableView!.selectedRow]
        
        if(tableViewWD.selectedRow != -1){
            selectedFile =  getItemSelected_String(tableViewWD)
            directoryPath = singleton.coreDataObject.getValueOfEntityObject("File", idKey: "nameOfFile", nameOfKey: "nameOfPath", nameOfObject: selectedFile)
            let fileURL = NSURL(fileURLWithPath: directoryPath)
            pathControl.URL = fileURL
        }
        
        
        
        
        
        // 3 - Change the status label beneath the table view dynamically as selection changes.
        //statusLabel.stringValue = "Directory Path"
        
        // 4 - When a working set is seleted from the table view, launch window buttons are then made available to be pressed.
        //switchOnOffButtons(true)
    }
    
    func getItemSelected_String(tableView :NSTableView)->String{
        
        
        let fetchedWD:NSManagedObject!
        
        
        //Here we will specify the contents for associated files of WD.
        
        // 1 - Get Managed Object Context
        let managedContext = singleton.coreDataObject.managedObjectContext
        
        // 2 - Establish Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        
        // 3 - Specify Predicate
        //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
        
        
        let predicate = NSPredicate(format: "%K == %@","nameOfWD",loadedWDName)
        
        
        fetchRequest.predicate = predicate
        
        // 3 - Attempt Fetch Request
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            contentsOfWD = results as! [NSManagedObject]
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        ///*
        let spec = contentsOfWD[0]
        let list = spec.mutableSetValueForKey("associatedFiles")
        
        var associatedObjects : [String] = []
        
        
        
      
            
            for i in list{
                let item = i.valueForKey("nameOfFile") as! String
                
                
                associatedObjects.append(item)
            }
        
        
        
        let item = associatedObjects[tableView.selectedRow]
        
        
        
        return item
        
    }
    
  
    
    
    
    
    
    
    // Fine as is.
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        ///*
        let fetchedWD:NSManagedObject!
        
        
        //Here we will specify the contents for associated files of WD.
        
        // 1 - Get Managed Object Context
        let managedContext = singleton.coreDataObject.managedObjectContext
        
        // 2 - Establish Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        
        // 3 - Specify Predicate
        //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
        
        
        let predicate = NSPredicate(format: "%K == %@","nameOfWD",loadedWDName)
        
        
        fetchRequest.predicate = predicate
        
        // 3 - Attempt Fetch Request
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            contentsOfWD = results as! [NSManagedObject]
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
    
        
        let spec = contentsOfWD[0]
        let list = spec.mutableSetValueForKey("associatedFiles")
        
        //print("Count of items is: \(list.count)")
        //*/
        
        
        
        /*
        //1
        let managedContext = singleton.coreDataObject.managedObjectContext
        //2
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        //3
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            contentsOfWD = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        */
        
        
        
        //return contentsOfWD.count ?? 0
        return list.count ?? 0
    }
    
    func tableViewDoubleClick(sender: AnyObject) {
        if(selectedFile != nil){
        print("Double click for \(selectedFile)")
        
        
         let openWindowObject = windowManager()
        
        let filePath:String!
        
        
        filePath = singleton.coreDataObject.getValueOfEntityObject("File", idKey: "nameOfFile", nameOfKey: "nameOfPath", nameOfObject: selectedFile)
        print (filePath)
        
       NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: filePath)
        }
        
        
    }
    
    /*
    // May need to change.
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        print("Sorting.")
        // 1
        guard let sortDescriptor = tableView.sortDescriptors.first else {
            return
        }
        if let order = Directory.FileOrder(rawValue: sortDescriptor.key! ) {
            // 2
            sortOrder = order
            sortAscending = sortDescriptor.ascending
            reloadFileList()
        }
    }
     */
    
}




extension WorkingDomainController : NSTableViewDelegate {
    
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        updateStatus()
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        print( row)
        
        
        var text:String = ""
        var cellIdentifier: String = ""
        
        
        
        
        let fetchedWD:NSManagedObject!
        
        
        //Here we will specify the contents for associated files of WD.
        
        // 1 - Get Managed Object Context
        let managedContext = singleton.coreDataObject.managedObjectContext
        
        // 2 - Establish Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        
        // 3 - Specify Predicate
        //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
        
        
        let predicate = NSPredicate(format: "%K == %@","nameOfWD",loadedWDName)

        
        fetchRequest.predicate = predicate

        // 3 - Attempt Fetch Request
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            contentsOfWD = results as! [NSManagedObject]
         
      
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
 
        fetchedWD = contentsOfWD[0]
        
        
        ///*
        let spec = contentsOfWD[0]
        let list = spec.mutableSetValueForKey("associatedFiles")
        
        
        print( list.count )
        
        
        var associatedObjects : [String] = []
        
        
        var isEmpty:Bool!
        
        if(list.count == 0){
            isEmpty = true
        }
        else{
            isEmpty = false
        }
        //*/
        
        
        
        
        ///*
        
        if( isEmpty == false){
        
            for i in list{
                let item = i.valueForKey("nameOfFile") as! String
                print( item )
                
                associatedObjects.append(item)
            }
            
            
             var value = associatedObjects[row]
            
            
            
            
            // 6 - Specifying table column
            if tableColumn == tableView.tableColumns[0] {
               
                text = value //value!
                cellIdentifier = "NameCellID"
            } /*else if tableColumn == tableView.tableColumns[1] {
                text = "Value"
                cellIdentifier = "DateCellID"
            }*/
            
            // 7 - Fill cell content.
            if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
                cell.textField?.stringValue = text
                return cell
            }
        }
        
        //*/
        // 8
        return nil
        
        
    }
}