//
//  dropView.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/12/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class dropViewForContext: NSView {
    
    
    var filePath: String?
    var fileName: String?
    //let expectedExt = "jpg"
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.wantsLayer = true
        
        //self.layer?.backgroundColor = NSColor.grayColor().CGColor
        
        registerForDraggedTypes([NSFilenamesPboardType, NSURLPboardType])
    }
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
    }
    
    func notify(){
        //NSNotificationCenter.defaultCenter().postNotificationName("updateWD", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("updateCM", object: nil)
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                //Swift.print(path)
                let ext = NSURL(fileURLWithPath: path).pathExtension
                //if ext == expectedExt {
                //self.layer?.backgroundColor = NSColor.blueColor().CGColor
                return NSDragOperation.Copy
                //}
            }
        }
        return NSDragOperation.None
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        self.layer?.backgroundColor = NSColor.redColor().CGColor
    }
    
    override func draggingEnded(sender: NSDraggingInfo?) {
        //self.layer?.backgroundColor = NSColor.grayColor().CGColor
        
        
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        self.layer?.backgroundColor = NSColor.greenColor().CGColor

        if let pasteboard = sender.draggingPasteboard().propertyListForType("NSFilenamesPboardType") as? NSArray {
            if let path = pasteboard[0] as? String {
                
                
                
                // RETRIEVED THE VALUE FROM THE DROPPED FILE.
                
                
                
                self.filePath = path
                self.fileName = NSURL(fileURLWithPath: path).lastPathComponent!
                //GET YOUR FILE PATH !!
                
                
                Swift.print("filePath: \(filePath)")
                
                Swift.print("fileName: \(fileName))")
                
                singleton.coreDataObject.addEntityObject("File", nameOfKey: "nameOfFile", nameOfObject: fileName!)
                
                singleton.coreDataObject.setValueOfEntityObject("File", idKey: "nameOfFile", nameOfKey: "nameOfPath", idName: fileName!, editName: filePath!)
                
                //Swift.print( singleton.coreDataObject.getDataObjects( "File" )  )
                
                
                
                //singleton.coreDataObject.editEntityObject("File", nameOfKey: "nameOfFile", oldName: fileName!, editName: filePath!)
                
                
                // Create a relationship.
                
                let workDomain = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD)
                let file = singleton.coreDataObject.getEntityObject("File", idKey: "nameOfFile", idName: fileName!)
                
                
                //singleton.coreDataObject.createRelationship(workDomain, objectTwo: file, relationshipType: "associatedFiles")
                
                let files = workDomain.mutableSetValueForKey("associatedFiles")
                
                files.addObject(file)
                
                Swift.print ( workDomain )
                
                singleton.coreDataObject.saveManagedContext()
                
                
                // Tell tableview of domain controller to reload.
                
                
                
                
                //Swift.print( singleton.coreDataObject.getDataObjects("File") )
                
                // Should post a notification to send file name and file path.
                
                self.notify()
                
                let myDict: [String:AnyObject] = [  "myText": "\(fileName!)"]
                
                NSNotificationCenter.defaultCenter().postNotificationName("updateContentStat", object: myDict)
                
                
                return true
            }
        }
        return false
    }
    
    
}
