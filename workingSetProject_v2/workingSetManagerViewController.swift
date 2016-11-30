//
//  ViewController.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/3/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class workingSetManagerViewController: NSViewController {
    
    
    
    
    var iteration = 0
    var windowController : NSWindowController?
    let launchWindowTable = tableViewManager()
    
    /*Variables for Sorting Table View*/
        var sortOrder = Directory.FileOrder.Name
        var sortAscending = true
        var directory:Directory?
        var directoryItems:[Metadata]?
    
    

    /*Variables*/
        var nameOfWS: String! //Selected WS
        var workingSets = [NSManagedObject]() //Stores instances of entity 'Working-Set'
    
    
    
    /*Outlets for Table View*/
        @IBOutlet weak var statusLabel: NSTextField!

    
    /*Outlets for Buttons*/
        @IBOutlet weak var openWDButton: NSButton!
        @IBOutlet weak var associateWDButton: NSButton!
        @IBOutlet weak var deleteWDButton: NSButton!
    
    
    
    /*Function for toggling between off and on state of buttons.*/
    func switchOnOffButtons(openActive:Bool,deleteActive:Bool,associateActive:Bool){
        //openWDButton.enabled = openActive
        //deleteWDButton.enabled = deleteActive
        //associateWDButton.enabled  = associateActive
    }

    
    
    
    
    @IBOutlet weak var tableView: NSTableView!
    
    /*Set-up View*/
    override func viewDidLoad() {
        
        
       
        
        super.viewDidLoad()
        tableView!.setDelegate(self)
        tableView!.setDataSource(self)
        tableView!.target = self
        tableView.doubleAction = "tableViewDoubleClick:"
        //Setting up sorting configuration:
        
        
        
        

        
        let nameDesc = "Name"
        let dateDesc = "Date"
        // 1
        let descriptorName_01 = NSSortDescriptor(key: Directory.FileOrder.Name.rawValue, ascending: true)
        let descriptorName_02 = NSSortDescriptor(key: Directory.FileOrder.Date.rawValue, ascending: true)
        
        // 2
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorName_01;
        tableView.tableColumns[0].sortDescriptorPrototype = descriptorName_02;
        
        switchOnOffButtons(false,deleteActive: false,associateActive: false)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeStatus:",name:"load", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableView:",name:"update", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "launchAssociatedWindow:", name: "associateWindow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AssociateWDButton", name: "AW", object: nil)
        
       NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteWDButton", name: "delWD", object: nil)
        
    }
    
    override func awakeFromNib() {
        
    }
    
    
    func reloadFileList() {
        //directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)   // Calls sorting function. Returns sorted array
        tableView!.reloadData()
    }
    
    
    override var representedObject: AnyObject? {
        didSet {
            if let url = representedObject as? NSURL {
                directory = Directory(folderURL: url)
                reloadFileList()
                
            }
        }
    }

    
    
    func changeStatus(notification: NSNotification){
        self.switchOnOffButtons(true, deleteActive: true, associateActive: true)
    }
    
    func updateTableView(notification: NSNotification){
        self.reloadFileList()
    }
    
    func launchAssociatedWindow(notification: NSNotification){
        print("Launch!")
        // 1 - Setting window object.
        let openWindowObject = windowManager()
        openWindowObject.setWindow("Main",nameOfWindowController: "AWindow")
        // 2 - Setting the values of the window object.
        windowController = openWindowObject.get_windowController()
        let openWindowViewController = windowController!.contentViewController as! WorkingDomainController
        
        
        
        // 3 - Initiate the window.
        windowController!.showWindow(nil)
    }
    
    
    @IBAction func onEnterChangeNameOfWD(sender: NSTextField) {
        print("Name changed.")
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "nameOfWD", idName: nameOfWS, editName: sender.stringValue)
        //NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
        
        singleton.openedWD = sender.stringValue
        NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
        tableView.reloadData()
        
        
    }
    
    
    
    
    
    
    // MARK: - Button Actions
    
    @IBAction func addNewWDButton(sender: AnyObject) {
        print("'Add new button' was pressed.")
        
        
        var iter = 1
        
        var potentialName = "Untitled Working Domain \(iter)"
        
        var ifInDB = singleton.coreDataObject.evaluateIfInDB("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: potentialName)
        print("Evaluated as \(ifInDB)")
        while(ifInDB == true){
            
            iter = iter + 1
            
            potentialName = "Untitled Working Domain \(iter)"
            
            ifInDB = singleton.coreDataObject.evaluateIfInDB("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: potentialName)
            
            
        }
        
        singleton.openedWD = potentialName
        NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
        singleton.coreDataObject.addEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: singleton.openedWD)
        
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "dateLastAccessed", idName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
        
        
        /*
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")

        var ifInDB = singleton.coreDataObject.evaluateIfInDB("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: "Untitled Working Domain")
        print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
        if(ifInDB == true){
            print("Its in the database.")
        }
        else{
            print("Its not in the data base.")
        }
        */
        
        /*
        if(iteration == 0){
            //Determine if there is a copy of WD matching Untitled...
            
            
            
            singleton.openedWD = "Untitled Working Domain"
            NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
            singleton.coreDataObject.addEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: singleton.openedWD)
           
             singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "dateLastAccessed", idName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
            iteration = iteration + 1
        }
        else{
            singleton.openedWD = "Untitled Working Domain \(iteration)"
            NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
            singleton.coreDataObject.addEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: singleton.openedWD)
            
            singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "dateLastAccessed", idName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
            
            //singleton.coreDataObject.editEntityObject(, nameOfKey: , oldName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
            iteration = iteration + 1
        }
        */
        
        
        
        /////////////////////////////////////////
        
        
        reloadFileList()
        
        // Enable buttons.
            switchOnOffButtons(true,deleteActive: true,associateActive: false)
        
       
        
        // 1 - Setting window object.
            let openWindowObject = windowManager()
            openWindowObject.setWindow("Main",nameOfWindowController: "AWindow")
        
        // 2 - Setting the values of the window object.
            windowController = openWindowObject.get_windowController()
            let openWindowViewController = windowController!.contentViewController as! WorkingDomainController
        
        // 3 - Initiate the window.
            windowController!.showWindow(sender)

    }
    
    
    @IBAction func openWDButton(sender: AnyObject) {
        print("'Open button' was pressed.")
        
        singleton.openedWD = nameOfWS
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "dateLastAccessed", idName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
      reloadFileList()
        print( singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD) )
        
        // 1 - Setting window object.
        let openWindowObject = windowManager()
        openWindowObject.setWindow("Main",nameOfWindowController: "AWindow")
        // 2 - Setting the values of the window object.
        windowController = openWindowObject.get_windowController()
        let openWindowViewController = windowController!.contentViewController as! WorkingDomainController
        
        
        // 3 - Initiate the window.
        NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
        windowController!.showWindow(sender)
 
    }

    @IBAction func deleteWDButton(sender: AnyObject) {
        print("Delete.")
        singleton.coreDataObject.deleteEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: nameOfWS)
        reloadFileList()
    }
    
    func AW_notif(){
        print("Associating...")
        nameOfWS = singleton.openedWD
        AssociateWDButton()
    }
    
    
    
  func AssociateWDButton() {
    
        let openedWD = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD)
    
        singleton.coreDataObject.createRelationship(openedWD, objectTwo: singleton.readCard, relationshipType: "associatedCard")
    
    }
}

