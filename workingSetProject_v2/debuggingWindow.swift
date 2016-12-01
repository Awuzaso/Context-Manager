//
//  debuggingWindow.swift
//  workingSetProject_v2
//
//  Created by Osa on 8/14/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class debuggingWindow: NSViewController {

    
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
    
    
    @IBOutlet weak var scannerStatus: NSTextField!
    
    
    /*Outlets for Buttons*/
    @IBOutlet weak var openWDButton: NSButton!
    @IBOutlet weak var associateWDButton: NSButton!
    @IBOutlet weak var deleteWDButton: NSButton!
    
    
    @IBOutlet weak var textField: NSTextField!
    
    
    
    
    
    
    func setNoteTable(){
        
        if(nameOfWS != nil){
        
            let wd = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: nameOfWS)
            
            
            
            let noteOfWD = wd.valueForKey("noteForWD")
            
            if( noteOfWD == nil ){
                textField.stringValue = "Type your notes here."
            }
            else{
                textField.stringValue = noteOfWD as! String
            }
        }
        else{
            textField.stringValue = "Type your notes here."
        }
        
    }

    
    
    /*Function for toggling between off and on state of buttons.*/
    func switchOnOffButtons(openActive:Bool,deleteActive:Bool,associateActive:Bool){
        //openWDButton.enabled = openActive
        //deleteWDButton.enabled = deleteActive
        //associateWDButton.enabled  = associateActive
    }
    
    func setStatusLabel(){
        statusLabel.textColor = NSColor.grayColor()
        statusLabel.stringValue = "No Context is Selected"
    }
    
    
    func setScannerStatus(){
        scannerStatus.textColor = NSColor.grayColor()
        scannerStatus.stringValue = "Scanner is disconnected."
    }
    
   

    
    func scannerStatSet(notification: NSNotification){
        let arrayObject = notification .object as! [AnyObject]
        let recievedValue = arrayObject[0] as! Bool
        
        if(recievedValue == true){
            scannerStatus.textColor = NSColor.greenColor()
            scannerStatus.stringValue = "Scanner is connected."
        }
        else{
            scannerStatus.textColor = NSColor.redColor()
            scannerStatus.stringValue = "Scanner is disconnected."
        }
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
        
        setStatusLabel()
        setScannerStatus()
        
        setNoteTable()
        
        
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scannerStatSet:", name: "scanSet", object: nil)
        
        
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
        
        if(nameOfWS != nil){
            singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "nameOfWD", idName: nameOfWS, editName: sender.stringValue)
            //NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
            
            singleton.openedWD = sender.stringValue
            //NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
            
            
            singleton.coreDataObject.editEntityObject("WorkingDomain", nameOfKey: "nameOfWD", oldName: nameOfWS, editName: sender.stringValue)
            
            statusLabel.stringValue = "Context's name, " + nameOfWS + ", was changed to " + sender.stringValue
            
            nameOfWS = sender.stringValue
            
            
            tableView.reloadData()
        }
        
    }
    
    
    @IBAction func switchBetweenContextFunc(sender: AnyObject) {
        
        if(nameOfWS != nil){
            statusLabel.stringValue = "The context was switched to " + nameOfWS
        }
        
        
        
    }
    
    @IBAction func onEnterTextFieldButton(sender: NSTextField) {
        if(nameOfWS != nil){
        print("Note saved!")
        
        statusLabel.stringValue = "Annotation for " + nameOfWS + " was saved."
        
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "noteForWD", idName: nameOfWS, editName: sender.stringValue)
        }
        
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
//        
//        // Enable buttons.
//        switchOnOffButtons(true,deleteActive: true,associateActive: false)
//        
//        
//        
//        // 1 - Setting window object.
//        let openWindowObject = windowManager()
//        openWindowObject.setWindow("Main",nameOfWindowController: "AWindow")
//        
//        // 2 - Setting the values of the window object.
//        windowController = openWindowObject.get_windowController()
//        let openWindowViewController = windowController!.contentViewController as! WorkingDomainController
//        
//        // 3 - Initiate the window.
//        windowController!.showWindow(sender)
        
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
        
        if(nameOfWS != nil){
            print("Delete.")
            statusLabel.stringValue = nameOfWS + " was deleted."
        
            singleton.coreDataObject.deleteEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: nameOfWS)
            reloadFileList()
            
            nameOfWS = nil
            
            setNoteTable()
        }
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

extension debuggingWindow : NSTableViewDataSource {
    
    
    /*This function is called everytime there is a change in the table view.*/
    func updateStatus() {
        let index = tableView!.selectedRow
        
        // 1 - Get collection of objects from object graph.
        workingSets = singleton.coreDataObject.getDataObjects("WorkingDomain")
        
        // 2 - Set the current selection of working set from table view.
        let item = workingSets[tableView!.selectedRow]
        
        
        
        nameOfWS =  launchWindowTable.getItemSelected_String(tableView, managedObjectArray: workingSets, objectAttr: "nameOfWD")
        
        statusLabel.stringValue = nameOfWS + " is selected."
        
        setNoteTable()
        
        // 3 - When a working set is seleted from the table view, launch window buttons are then made available to be pressed.
        switchOnOffButtons(true,deleteActive: true,associateActive: false)
    }
    
    
    func tableViewDoubleClick(sender: AnyObject) {
        
        if(nameOfWS != nil){
            singleton.openedWD = nameOfWS
            NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
            
            //self.openWDButton(self)    <----- THIS IS WHERE WE PUT THE CODE TO OPEN THE CONTEXT CONTENT
            
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

extension debuggingWindow : NSTableViewDelegate {
    
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
            //text = date!
            text = ""
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



///////////////////////////



//class debuggingWindow: NSViewController




