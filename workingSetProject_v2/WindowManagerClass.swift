//
//  WindowManagerClass.swift
//  workingSetProject
//
//  Created by Osa on 6/22/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class windowManager{
    
    var nameOfWindow = "Window"
    var windowController: NSWindowController! = nil
    var window: NSWindow! = nil
    func setWindow(){
        let application = NSApplication.sharedApplication()
        application.stopModal()
    }
    
    
    func openWindow( nameOfPath: String, nameOfFile: String){
        let filePath = "\(nameOfPath)\(nameOfFile)"
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: filePath)
    }
    
    
    func createNewFile( nameOfPath: String, nameOfFile: String){
        let filePath = "\(nameOfPath)\(nameOfFile)"
       
        
        do {
            //var deliverablePathString = "/Users/Osa/Desktop/\(nameOfWS)"
            try NSFileManager.defaultManager().createDirectoryAtPath(filePath, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            NSLog("\(error.localizedDescription)")
        } catch {
            print("general error - \(error)")
        }
    }
    
    func changeNameOfFile(nameOfPath: String, nameOfFile: String, newFileName:String){
        let manager = NSFileManager()
        
        let oldFile = nameOfPath+nameOfFile
        let newFile = nameOfPath+newFileName
        
        //let documentDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
       //let originPath = documentDirectory.stringByAppendingPathComponent("/tmp/a.caf")
       //let destinationPath = documentDirectory.stringByAppendingPathComponent("/tmp/xyz.caf")
        
        var moveError: NSError?
        /*
        if try manager.moveItemAtPath(oldFile, toPath: newFile, error: &moveError) {
            print(moveError!.localizedDescription)
        }
        */
    }
    
    
    func setWindow(nameOfStoryboard:String,nameOfWindowController:String){
        let nameOfWindow = nameOfWindowController
        let storyboard = NSStoryboard(name: nameOfStoryboard, bundle: nil)
        windowController = storyboard.instantiateControllerWithIdentifier(nameOfWindow) as! NSWindowController
        window = windowController.window
    }
    
    func get_windowController()->NSWindowController{
        return windowController
    }
    
    func get_window()->NSWindow{
        return window
    }
    
    func runModalWindow(){
        
        let application = NSApplication.sharedApplication()
        
        let session = application.beginModalSessionForWindow(self.window)
        
        for(;;){
            if( application.runModalSession(session) != NSModalResponseContinue){
                break
            }
       
        }
            print("Closing window for modal session, \(nameOfWindow)")
        window.close()
        application.endModalSession(session)
            print("Modal session for \(nameOfWindow) is done.")
    }
    
    
    func stopEvents(){
        let application = NSApplication.sharedApplication()
        application.stopModal()
    }
    
    
    
    
    
    
    
    
    
}
