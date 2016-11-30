//
//  Edit_User_Settings_Window.swift
//  workingSetProject
//
//  Created by Osa on 6/22/16.
//  Copyright © 2016 Osa. All rights reserved.
//


import Cocoa

class Edit_User_Settings_Window: NSViewController {
 
    let serialPortManager = ORSSerialPortManager.sharedSerialPortManager()
    
    var selectedIndex:Int!
    var port:String!
    var portPath:String!
    var dataCore = singleton.coreDataObject
    
 
    @IBOutlet weak var Serial_Port_Label: NSPopUpButton!
    
    
    func setDefaultPref(){
        // - 1 Initialize values to set "userPrefObject".
            port = Serial_Port_Label.itemTitleAtIndex(0)
            portPath = "/dev/cu."+port
        
        // - 2 Set to objects.
            singleton.userPrefObject.set_serialPort(&dataCore, portPath: portPath)
        
        
        // - 3 Reset serial port and commit changes.
            singleton.serialPortObject = SerialPortManager(pathName: portPath ,in_nameOfStoryBoard: "Main" ,in_nameOfWinUnAssoc:"UAWindow",  in_nameOfWinAssoc: "AWindow")
            NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
    }
    
    
    
    func set_ChosenPref(){
        
        selectedIndex = Serial_Port_Label.indexOfSelectedItem
        
        port = Serial_Port_Label.itemTitleAtIndex(selectedIndex)
        
        portPath = "/dev/cu."+port
        
        singleton.userPrefObject.set_serialPort(&dataCore, portPath: portPath)
        
        
        singleton.serialPortObject = SerialPortManager(pathName: portPath ,in_nameOfStoryBoard: "Main" ,in_nameOfWinUnAssoc:"UAWindow",  in_nameOfWinAssoc: "AWindow")
        NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setDefaultPref()
    }
    
    @IBAction func OK_Button(sender: AnyObject) {
        
        set_ChosenPref()
        singleton.openWindowObject.stopEvents()
        
    }
    
    
    
    @IBAction func Cancel_Button(sender: AnyObject) {
         singleton.openWindowObject.stopEvents()
    }
    
    
    
    
}
