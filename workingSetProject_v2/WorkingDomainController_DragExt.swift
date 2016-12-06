//
//  WorkingDomainController_DragExt.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/26/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

extension WorkingDomainController{
    /*
    func tableView(tableView: NSTableView!, objectValueForTableColumn tableColumn: NSTableColumn!, row: Int) -> AnyObject!
    {
        var newString:String = ""
        if (tableView == sourceTableView)
        {
            newString = sourceDataArray[row]
        }
        else if (tableView == targetTableView)
        {
            newString = targetDataArray[row]
        }
        return newString;
    }
     
    ///////////////
    func tableView(aTableView: NSTableView,
                   writeRowsWithIndexes rowIndexes: NSIndexSet,
                                        toPasteboard pboard: NSPasteboard) -> Bool
    {
        if ((aTableView == sourceTableView) || (aTableView == targetTableView))
        {
            let data:NSData = NSKeyedArchiver.archivedDataWithRootObject(rowIndexes)
            let registeredTypes:[String] = [NSStringPboardType]
            pboard.declareTypes(registeredTypes, owner: self)
            pboard.setData(data, forType: NSStringPboardType)
            return true
            
        }
        else
        {
            return false
        }
    }
    
    
    
    // MAIN EVENT.
    func tableView(tableView: NSTableView, acceptDrop info: NSDraggingInfo, row: Int, dropOperation: NSTableViewDropOperation) -> Bool
    {
        print("Something is happening.")
        var data:NSData = info.draggingPasteboard().dataForType(NSStringPboardType)!
        var rowIndexes:NSIndexSet = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSIndexSet
        
   
            
        if ((info.draggingSource() as! NSTableView == sourceTableView) && (tableView == targetTableView))
        {
            // IN THIS CONDITION, WHEN OPERATION IS CONFIRMED, DATA MODEL CHANGES.
            print("Moving object to target.")
            /*
            var value:String = sourceDataArray[rowIndexes.firstIndex]
            sourceDataArray.removeAtIndex(rowIndexes.firstIndex)
            targetDataArray.append(value)
            sourceTableView.reloadData()
            targetTableView.reloadData()
            */
            return true
        }
            
        else{
            print("Yellow.")
            return false
        }
        
    }
*/
    
    
}
