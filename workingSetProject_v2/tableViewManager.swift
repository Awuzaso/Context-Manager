//
//  tableViewManagerClass.swift
//  workingSetProject
//
//  Created by Osa on 6/23/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa


class tableViewManager{
    //var tableView: NSTableView!
    
    var managedObject = [NSManagedObject]()
    
    
    
    // var tableView: NSTableView!
    
    /*func set_TableView(nameOfTableView: NSTableView){
    tableView = nameOfTableView
    }
    */
    
    /*func get_itemsSelected()-> Int{
    let itemsSelected = tableView.selectedRowIndexes.count
    return itemsSelected
    }
    */
    
    func printMessage(){
        print("Hello!")
    }
    
    /*
    func get_itemsSelected()->Int{
    return self.selectedRowIndexes.count
    }
    */
    
    
    func set_ManagedObject(var incomingManagedObject :Array <NSManagedObject>){
        managedObject = incomingManagedObject
        
    }
    
    func getStatusOfItemsSelected(tableView:NSTableView,itemCount:Int)->String{
        
        let text:String
        // 1
        let itemsSelected = tableView.selectedRowIndexes.count
        
        // 2
        if ( itemCount == 0 ) {
            text = ""
        }
        else if( itemsSelected == 0 ) {
            text =   "\(itemCount) items"
        }
        else
        {
            text = "\(itemsSelected) of \(itemCount) selected"
        }
        
        
        // 3
        return text
        
    }
    
    func getItemSelected(tableView :NSTableView,managedObjectArray :Array <NSManagedObject>,objectAttr:String)->NSManagedObject{
        let item = managedObjectArray[tableView.selectedRow]
        return item
    }
    
    func getItemSelected_String(tableView :NSTableView,managedObjectArray :Array <NSManagedObject>,objectAttr:String)->String{
        let item = managedObjectArray[tableView.selectedRow]
        let selectedObject = item.valueForKey(objectAttr) as? String
        return selectedObject!
    }
    
    
    
    
    
    
    
    
}