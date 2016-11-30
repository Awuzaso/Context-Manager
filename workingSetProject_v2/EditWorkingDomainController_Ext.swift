//
//  EditWorkingDomainController_Ext.swift
//  workingSetProject_v2
//
//  Created by Osa on 8/4/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa


extension EditWorkingDomainController: NSTableViewDataSource{
    
    
    
    
    func init_cardAssociatedList(){
    
        var workingDomain:[NSManagedObject]!
        
        let fetchedWD:NSManagedObject!
        
    // 1 - Get Managed Object Context
        let managedContext = singleton.coreDataObject.managedObjectContext
    // 2 - Establish Fetch Request
        let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
    // 3 - Specify Predicate
        let predicate = NSPredicate(format: "%K == %@","nameOfWD",singleton.openedWD)
        fetchRequest.predicate = predicate
        
    // 4 - Attempt fetch request.
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            workingDomain = results as! [NSManagedObject] //Remove this immediately.
            
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    
    // 5 - Create array of objects from mutable set.
        let specificWorkingDomain = workingDomain[0]
        
        let associatedCardsOfWD = specificWorkingDomain.mutableSetValueForKey("associatedCards")
        
        var iterator = 0
        
        for i in associatedCardsOfWD{
            
            cardsAssociated.append(i as! NSManagedObject)
            //cardsAssociated[i] = i as! NSManagedObject
          
            
            //print( "Card number, \(iterator)\n" )
            //print(cardsAssociated[iterator].valueForKey("rfidValue") as! String)
            
            iterator = iterator + 1
        }

        
        //print("Number of items: \(cardsAssociated.count)")
    }
    
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        /*
        let fetchedWD:NSManagedObject!
        
        //Here we will specify the contents for associated files of WD.
        
        // 1 - Get Managed Object Context
            let managedContext = singleton.coreDataObject.managedObjectContext
        
        // 2 - Establish Fetch Request
            let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
        
        // 3 - Specify Predicate
        //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
        
        
            let predicate = NSPredicate(format: "%K == %@","nameOfWD",singleton.openedWD)
        
        
            fetchRequest.predicate = predicate
        
        // 3 - Attempt Fetch Request
            do {
                let results =
                    try managedContext.executeFetchRequest(fetchRequest)
                cardsAssociated = results as! [NSManagedObject]
                
                
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        
        */
        
        
        
        //let spec = cardsAssociated[0]
        
        
        
       //print( "/////////////////////////////////")
       //print( cardsAssociated.count)
        // print( "/////////////////////////////////")
       
        //let list = spec.mutableSetValueForKey("associatedCards")
       
        return cardsAssociated.count ?? 0   //list.count ?? 0
    }
    
    
    
    func tableViewDoubleClick(sender: AnyObject) {
        
        
        print( "Double click in working domain, \(singleton.openedWD)" )
        ///*
        if(nameOfCard != nil){
            //singleton.openedWD = nameOfWS
           // NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
            //self.openWDButton(self)
            print( "The card, \(nameOfCard) was selected" )
        }
        else{
            print("The value: \(tableView.selectedColumn)")
            if (tableView.selectedColumn == 0){
                print("Column 1 is selected.")
            }
            else if (tableView.selectedColumn == 1){
                print("Column 2 is selected.")
            }
            else if (tableView.selectedColumn == 2){
                print("Column 3 is selected.")
            }
            else if (tableView.selectedColumn == 3){
                print("Column 4 is selected.")
            }
            
            
            print("Nothing is selected.")
            //openWDButton.enabled = false
        }
        //*/
    }

    

    
    func updateStatus(){
        //print("Update")
        ///*
         
         let index = tableView!.selectedRow
        
         // 1 - Get collection of objects from object graph.
        
        
        
        
        
        
        
        
         
         // 2 - Set the current selection of working set from table view.
        if( tableView!.selectedRow != -1 ){
         let item = cardsAssociated[tableView!.selectedRow]
        
         nameOfCard =  launchWindowTable.getItemSelected_String(tableView, managedObjectArray: cardsAssociated, objectAttr: "rfidValue")
        }
        
         // 3 - When a working set is seleted from the table view, launch window buttons are then made available to be pressed.
         //switchOnOffButtons(true,deleteActive: true,associateActive: false)

         
         //*/
        
    }
    
    
    
    
}


extension EditWorkingDomainController: NSTableViewDelegate{
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        //print( "Selection is made" )
        updateStatus()
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var isEmpty:Bool!
        
       
        
        if(cardsAssociated.count == 0){
            //print( "There is nothing inside." )
            isEmpty = true
        }
        else{
            // print( "There is something." )
            isEmpty = false
        }

        
        if( isEmpty == false){
            
            var associatedObjects : [String] = []
            var associatedCardName : [String] = []
            var associatedCardOwner : [String] = []
            var associatedDate : [String] = []
       
        var text:String = "text"
        var cellIdentifier: String = ""
        
            var item:String!
            var cardName:String!
            var cardOwner:String!
            var dateLastAccessed:String!
            
            //print( cardsAssociated.count )
            /*
            for i in cardsAssociated{
                //print( i )
                item = i.valueForKey("rfidValue") as! String
                cardName = i.valueForKey("cardName") as! String
                cardOwner = i.valueForKey("cardOwner") as! String
                dateLastAccessed = i.valueForKey("dateLastAccessed") as! String
            }
            */
            item = cardsAssociated[row].valueForKey("rfidValue") as! String
            cardName = cardsAssociated[row].valueForKey("cardName") as! String
            cardOwner = cardsAssociated[row].valueForKey("cardOwner") as! String
            dateLastAccessed = cardsAssociated[row].valueForKey("dateLastAccessed") as! String
            
            // 2
            if tableColumn == tableView.tableColumns[0] {
                
                text =  item //"thing" //cardsAssociated[row].valueForKey("rfidValue") as! String
                cellIdentifier = "rfidCellID"
            } else if tableColumn == tableView.tableColumns[1] {
                text = cardName
                cellIdentifier = "nameCellID"
            }
            else if tableColumn == tableView.tableColumns[2] {
                text = cardOwner
                cellIdentifier = "ownerCellID"
            }
            else if tableColumn == tableView.tableColumns[3] {
                text = dateLastAccessed
                cellIdentifier = "dateCellID"
            }
            
            // 3
            if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
                print( text )
                cell.textField?.stringValue = text
                return cell
            }
        }
 
        
        return nil
    }
  
    
}