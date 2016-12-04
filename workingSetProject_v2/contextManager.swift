//
//  debuggingWindow.swift
//  workingSetProject_v2
//
//  Created by Osa on 8/14/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class contextManager: NSViewController {

    
    var iteration = 0
    var windowController : NSWindowController?
    let launchWindowTable = tableViewManager()
    
    /*Variables for Sorting Table View*/
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true
    var directory:Directory?
    var directoryItems:[Metadata]?
    
    
    
    /*Variables*/
    var currentContext: String! //Selected WS
    var workingSets = [NSManagedObject]() //Stores instances of entity 'Working-Set'
    var contentsOfWD = [NSManagedObject]() //Stores instances of entity 'Working-Set'
    var directoryPath:String!
    var selectedFile:String!
    
    
    
    /*Outlets for Context View (Left-hand side tableview.)*/
    @IBOutlet weak var tableView: NSTableView!
    
    /*Outlet for tableview for content. (Left-hand side tableview.)*/
    @IBOutlet weak var tableViewWD: NSTableView!
   
    
    
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var pathControl: NSPathControl!

    
    @IBOutlet weak var scannerStatus: NSTextField!
    
    
    
    
    @IBOutlet weak var textField: NSTextField!
    
    
    func setupTableView(){
        tableViewWD!.setDelegate(self)
        tableViewWD!.setDataSource(self)
        tableViewWD!.target = self
        tableViewWD.doubleAction = "tableViewDoubleClick:"
    }
    
    func setNoteTable(){
        
        if(currentContext != nil){
        
            let wd = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: currentContext)
            
            
            
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

    
    func openPath(){
        
        let tval = pathControl.clickedPathComponentCell()?.URL?.filePathURL
        
        let nval = (tval?.relativePath)! as String
        
        //print( nval )
        
        
        let value = (pathControl.clickedPathComponentCell()?.URL?.relativeString)! as String
        //print( value )
        let openWindowObject = windowManager()
        
        let filePath:String!
        
        
        filePath = value
        
        
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: nval)
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
    
    
    func updateAddedContentToContext(notification: NSNotification){
        //let arrayObject = notification .object as! [AnyObject]
        //let recievedValue = arrayObject[0] as! String
        
        
        if let myDict = notification.object as? [String:AnyObject] {
            
            if let myText = myDict["myText"] as? String {
                statusLabel.stringValue = myText + " was added to " + currentContext

            }
        }
    }
    
    
    /*Set-up View*/
    override func viewDidLoad() {
        
        
        
        
        super.viewDidLoad()
        tableView!.setDelegate(self)
        tableView!.setDataSource(self)
        tableView!.target = self
        //tableView.doubleAction = "tableViewDoubleClick:"
        //Setting up sorting configuration:
        
        setStatusLabel()
        setScannerStatus()
        
        setNoteTable()
        pathControl.doubleAction = "openPath"
//        
        let registeredTypes:[String] = [NSStringPboardType]
        tableViewWD.registerForDraggedTypes(registeredTypes)
        NSLog(tableViewWD.registeredDraggedTypes.description)
//
               //print("Working.")

        
        
        
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateTableViewWD",name:"updateCM", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "launchAssociatedWindow:", name: "associateWindow", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "AssociateWDButton", name: "AW", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deleteWDButton", name: "delWD", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "scannerStatSet:", name: "scanSet", object: nil)
        //updateAddedContentToContext
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateAddedContentToContext:", name: "updateContentStat", object: nil)
        
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "aCardWasRead:", name: "cardRead", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchBetweenContextFunc", name: "switch", object: nil)
        
        
        
        setupTableView()
        
        
        let options = CGWindowListOption(arrayLiteral: CGWindowListOption.ExcludeDesktopElements, CGWindowListOption.OptionOnScreenOnly)
        
        let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        
        let infoList = windowListInfo as NSArray? as? [[String: AnyObject]]
        
        
        
        print(infoList)
        
        
        //tableViewWD.hidden = true

    }
    
    override func awakeFromNib() {
        
    }
    
    
    
    
    func updateTableViewWD(){
        //print("Update.")
    self.reloadFileListWD()
    self.tableViewWD!.reloadData()
    }
    
    func reloadFileListWD() {
        //directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
        tableViewWD!.reloadData()
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
                reloadFileListWD()
            }
            
        }
    }
    
    func aCardWasRead(notification: NSNotification){
        
        statusLabel.stringValue = "A unassociated card was read."
        
    }
    
    func changeStatus(notification: NSNotification){
        self.switchOnOffButtons(true, deleteActive: true, associateActive: true)
    }
    
    func updateTableView(notification: NSNotification){
        self.reloadFileList()
    }
    
//    func launchAssociatedWindow(notification: NSNotification){
//       // print("Launch!")
//        // 1 - Setting window object.
//        let openWindowObject = windowManager()
//        openWindowObject.setWindow("Main",nameOfWindowController: "AWindow")
//        // 2 - Setting the values of the window object.
//        windowController = openWindowObject.get_windowController()
//        let openWindowViewController = windowController!.contentViewController as! WorkingDomainController
//        
//        
//        
//        // 3 - Initiate the window.
//        windowController!.showWindow(nil)
//    }
    
    
    @IBAction func onEnterChangeNameOfWD(sender: NSTextField) {
       // print("Name changed.")
        
        if(currentContext != nil){
            singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "nameOfWD", idName: currentContext, editName: sender.stringValue)
            //NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
            
            singleton.openedWD = sender.stringValue
            //NSNotificationCenter.defaultCenter().postNotificationName("saver", object: nil)
            
            
            singleton.coreDataObject.editEntityObject("WorkingDomain", nameOfKey: "nameOfWD", oldName: currentContext, editName: sender.stringValue)
            
            statusLabel.stringValue = "Context's name, " + currentContext + ", was changed to " + sender.stringValue
            
            currentContext = sender.stringValue
            singleton.openedWD = currentContext
            
            tableView.reloadData()
        }
        
    }
    
    
    @IBAction func connectToScanner(sender: AnyObject) {
        singleton.serialPortObject.openSerialPort()
        
    }
    
    
    @IBAction func switchBetweenContextFunc(sender: AnyObject) {
        
        if(currentContext != nil){
            
            //singleton.coreDataObject.getEntityObject("File", idKey: selectedFile , idName: currentContext)
            
            
            
            updateStatusWD()
            
            
            
            NSWorkspace.sharedWorkspace().openFile("/Users/osazuwaokundaye/Downloads/ICIDS2016-Draft3-2.doc", withApplication: "/Applications/Preview.app")
            
            statusLabel.stringValue = "The context was switched to " + currentContext
        }
        
        
        
    }
    
    @IBAction func onEnterTextFieldButton(sender: NSTextField) {
        if(currentContext != nil){
        //print("Note saved!")
        
        statusLabel.stringValue = "Annotation for " + currentContext + " was saved."
        
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "noteForWD", idName: currentContext, editName: sender.stringValue)
        }
        
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func addNewWDButton(sender: AnyObject) {
       // print("'Add new button' was pressed.")
        
        
        var iter = 1
        
        var potentialName = "Untitled Working Domain \(iter)"
        
        var ifInDB = singleton.coreDataObject.evaluateIfInDB("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: potentialName)
        //print("Evaluated as \(ifInDB)")
        while(ifInDB == true){
            
            iter = iter + 1
            
            potentialName = "Untitled Working Domain \(iter)"
            
            ifInDB = singleton.coreDataObject.evaluateIfInDB("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: potentialName)
            
            
        }
        
        singleton.openedWD = potentialName
        statusLabel.stringValue = potentialName + " ,context was added."
        NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
        singleton.coreDataObject.addEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: singleton.openedWD)
        
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "dateLastAccessed", idName: singleton.openedWD, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
        
        
        
        
        
        reloadFileList()
    }
    
    func rmvFile(){
        singleton.coreDataObject.deleteEntityObject("File", nameOfKey: "nameOfFile", nameOfObject: selectedFile)
        
        self.reloadFileList()
        updateTableViewWD()
    }
    
    @IBAction func removeFileFromContext(sender: AnyObject) {
        rmvFile()
    }
    
    
    @IBAction func deleteWDButton(sender: AnyObject) {
        
        if(currentContext != nil){
            print("Delete.")
            statusLabel.stringValue = currentContext + " was deleted."
        
            singleton.coreDataObject.deleteEntityObject("WorkingDomain", nameOfKey: "nameOfWD", nameOfObject: currentContext)
            reloadFileList()
            
            currentContext = nil
            
            setNoteTable()
            
            updateTableViewWD()
        }
    }
    
    
 
    
    func AW_notif(){
        print("Associating...")
        currentContext = singleton.openedWD
        AssociateWDButton()
    }
    @IBAction func delFromContext(sender: AnyObject) {
        statusLabel.stringValue = "A file was deleted from " + currentContext
    }
    
    
    
    func AssociateWDButton() {
        
//        let openedWD = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD)
//        
//        singleton.coreDataObject.createRelationship(openedWD, objectTwo: singleton.readCard, relationshipType: "associatedCard")
        
        let openedWD = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: currentContext)
        
        singleton.coreDataObject.createRelationship(openedWD, objectTwo: singleton.readCard, relationshipType: "associatedCard")
        
    }

}

extension contextManager : NSTableViewDataSource {
    
    
    /*This function is called everytime there is a change in the table view.*/
    func updateStatus() {
        let index = tableView!.selectedRow
        
        // 1 - Get collection of objects from object graph.
        workingSets = singleton.coreDataObject.getDataObjects("WorkingDomain")
        
        // 2 - Set the current selection of working set from table view.
        let item = workingSets[tableView!.selectedRow]
        
        
        
        currentContext =  launchWindowTable.getItemSelected_String(tableView, managedObjectArray: workingSets, objectAttr: "nameOfWD")
        singleton.openedWD = currentContext
        statusLabel.stringValue = currentContext + " is selected."
        tableViewWD.reloadData()
        setNoteTable()
        
        // 3 - When a working set is seleted from the table view, launch window buttons are then made available to be pressed.
        //switchOnOffButtons(true,deleteActive: true,associateActive: false)
    }
    
    
    func getItemSelected_String(tableView :NSTableView)->String{
        
        if(tableView == tableViewWD){
            let fetchedWD:NSManagedObject!
            
            
            //Here we will specify the contents for associated files of WD.
            
            // 1 - Get Managed Object Context
            let managedContext = singleton.coreDataObject.managedObjectContext
            
            // 2 - Establish Fetch Request
            let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
            
            // 3 - Specify Predicate
            //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
            
            
            let predicate = NSPredicate(format: "%K == %@","nameOfWD",currentContext)
            
            
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
        
        return " "
    }

    
    
    func updateStatusWD(){
        print("A file is being selected.")
        
        print(tableViewWD.selectedRow)
        ///*
        if(tableViewWD.selectedRow != -1){
            print("Next")
            selectedFile =  getItemSelected_String(tableViewWD)
            directoryPath = singleton.coreDataObject.getValueOfEntityObject("File", idKey: "nameOfFile", nameOfKey: "nameOfPath", nameOfObject: selectedFile)
            let fileURL = NSURL(fileURLWithPath: directoryPath)
            
            
            print(selectedFile + " was selected.")
            
            print(fileURL)
            pathControl.URL = fileURL
        }//*/
    }
    
    
    func tableViewDoubleClick(sender: AnyObject) {
        
//        if(currentContext != nil){
//            singleton.openedWD = currentContext
//            //NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
//            print("Hitting.")
//            //self.openWDButton(self)    <----- THIS IS WHERE WE PUT THE CODE TO OPEN THE CONTEXT CONTENT
//            
//           
//            
//            
//            
//            
//            
//            
//            
//        }
//        else{
//            print("Nothing is selected.")
//            //openWDButton.enabled = false
//        }
//        
//        //print("Hit")
        print("A file was double clicked.")
        if(selectedFile != nil){
            print("Double click for \(selectedFile)")
            
            statusLabel.stringValue = selectedFile + " was opened."
            let openWindowObject = windowManager()
            
            let filePath:String!
            
            
            filePath = singleton.coreDataObject.getValueOfEntityObject("File", idKey: "nameOfFile", nameOfKey: "nameOfPath", nameOfObject: selectedFile)
            print (filePath)
            
            NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: filePath)
        }

        
    }
    
    
    // Fine as is.
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if(tableView == self.tableView){
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
        else if((tableView == tableViewWD) ){
            
            
            
            if(currentContext != nil){
                //print("Getting count")
                ///*
                let fetchedWD:NSManagedObject!
                
                
                //Here we will specify the contents for associated files of WD.
                
                // 1 - Get Managed Object Context
                let managedContext = singleton.coreDataObject.managedObjectContext
                
                // 2 - Establish Fetch Request
                let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
                
                // 3 - Specify Predicate
                //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
                
                
                let predicate = NSPredicate(format: "%K == %@","nameOfWD",currentContext)
                
                
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
                
                return list.count ?? 0
                
                //return 1
            }
            else{
                return 0
            }
         
            
            
            
            
        }
        else{
            return 0
        }
    }
    
    // Function sets the sorting schema, then calls on "reloadFileList()" to actually change table view.
    func tableView(tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        //print("Starting sort.")
        if(tableView == self.tableView){
            
        }
        else if(tableView == tableViewWD){
            
        }
    }
    
    
    
}



extension contextManager : NSTableViewDelegate {
    
    func tableViewSelectionDidChange(notification: NSNotification) {
       let myTableViewFromNotification = notification.object as! NSTableView
        
        if(myTableViewFromNotification == tableView){
        updateStatus()
        }
        else if(myTableViewFromNotification == tableViewWD){
        updateStatusWD()
        }
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        var text:String = ""
        var cellIdentifier: String = ""
        
        if(tableView == self.tableView){
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

        }
        else if(tableView == tableViewWD){
            
            
            var image: NSImage?
            
            
            
            let fetchedWD:NSManagedObject!
            
            
            //Here we will specify the contents for associated files of WD.
            
            // 1 - Get Managed Object Context
            let managedContext = singleton.coreDataObject.managedObjectContext
            
            // 2 - Establish Fetch Request
            let fetchRequest = NSFetchRequest(entityName: "WorkingDomain")
            
            // 3 - Specify Predicate
            //let predicate = NSPredicate(format: "nameOfWD",loadedWDName)
            
            
            let predicate = NSPredicate(format: "%K == %@","nameOfWD",currentContext)
            
            
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
            
            
            
            //Dummy Value
            
           
            
            
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
                    //print( item )
                    
                    associatedObjects.append(item)
                }
                
                
                var value = associatedObjects[row]
                
                
                
                
                // 6 - Specifying table column
                if tableColumn == tableView.tableColumns[0] {
                    
                   text = value //value! <--- ADD
                   //text = "Value"
                    cellIdentifier = "NameCellID"
                }
               
                else if tableColumn == tableView.tableColumns[1] {
                
                    
                    
                text = "Delete"
                cellIdentifier = "DelCellID"
                }   
                
                // 7 - Fill cell content.
                if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
                    cell.textField?.stringValue = text
                    return cell
                }
            }

        }
        
      
        
        
        
        // 8
        return nil
    }
}



///////////////////////////







