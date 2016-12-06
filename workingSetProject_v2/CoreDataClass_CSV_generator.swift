////
////  CoreDataClass_CSV_generator.swift
////  workingSetProject_v2
////
////  Created by Osa on 8/5/16.
////  Copyright © 2016 Osa. All rights reserved.
////
//
//
//import Cocoa
//import CoreData
//
//extension dataCore{
//
//    
//    
//    
//    func getExportString_WorkDom(nameOfEntity: String)->String{
//        var stringValue = "dateCreated, dateLastAccessed, nameOfWD, tagID, timesAccessed, timesAssociated \n"
//    
//        var dateCreated = ""
//        var dateLastAccessed: String!
//        var nameOfWD = ""
//        var tagID: String!
//        var timesAccessed: String!
//        var timesAssociated: String!
//        
//        
//        let result = getDataObjects("WorkingDomain")
//        
//        
//        for index in result{
//            
//            
//            dateCreated = "\(index.valueForKey("dateCreated") )"
//            
//            dateLastAccessed = "\(index.valueForKey("dateLastAccessed") )"
//            
//            nameOfWD = "\( index.valueForKey("nameOfWD") as! String)"
//            
//            tagID = "\(index.valueForKey("tagID") )"
//            
//            timesAccessed = "\(index.valueForKey("timesAccessed") )"
//            
//            timesAssociated = "\(index.valueForKey("timesAssociated") )"
//            
//            
//            stringValue = stringValue + ", " + dateCreated +  ", " + nameOfWD + ", " + tagID + ", " + timesAccessed + ", " + timesAssociated + "\n"
//
//        }
//        
//        
//     
//        
//        
//    
//        
//        
//        
//        return stringValue
//    }
//    
//    
//    func getExportString_File()->String{
//        var stringValue = ""
//        
//        return stringValue
//    }
//
//    
//    func getExportString_UserAttr()->String{
//        var stringValue = ""
//        
//        return stringValue
//    }
//
//    
//    
//    func getExportString_Card()->String{
//        var stringValue = ""
//        
//        return stringValue
//    }
//
//    
//    
//    
//    
//    
//    func getListOfAttributes(object:AnyObject)->[String]{
//        
//        
//       
//        
//        let listOfKeys = object.attributeKeys
//        
//        return listOfKeys
//    
//    }
//    
//    
//    
//    
//    func exportDatabase() {
//        
//        var exportString = getExportString_WorkDom("")
//        print(exportString)
//        saveAndExport(exportString)
//        
//    }
//    
//    
//    
//
//    func saveAndExport(exportString: String) {
//        
//        let exportFilePath = "/Users/Osa/Desktop/" + "export.csv"
//        
//        let exportFileURL = NSURL(fileURLWithPath: exportFilePath)
//        
//        NSFileManager.defaultManager().createFileAtPath(exportFilePath, contents: NSData(), attributes: nil)
//        
//        var fileHandleError: NSError? = nil
//        
//        var fileHandle: NSFileHandle? = nil
//        
//        do {
//            fileHandle = try NSFileHandle(forWritingToURL: exportFileURL)
//        } catch {
//            print( "Error with fileHandle")
//        }
//        
//        if fileHandle != nil {
//            
//            fileHandle!.seekToEndOfFile()
//            
//            let csvData = exportString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
//            
//            fileHandle!.writeData(csvData!)
//            
//            fileHandle!.closeFile()
//            
//        }
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//}
