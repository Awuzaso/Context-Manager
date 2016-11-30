//
//  WorkingDomainController.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/5/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

class WorkingDomainController: NSViewController {
    
 
    
    var loadedWDName = "Value"
    var wdAccDate:NSDate!
    
  
    
    
    @IBOutlet weak var tableViewWD: NSTableView!
    @IBOutlet weak var nameOfWD: NSTextField!
    @IBOutlet weak var associateToCardState: NSTextField!
    //@IBOutlet weak var directoryPath: NSTextField!
    
    @IBOutlet weak var pathControl: NSPathControl!
    
    @IBOutlet weak var textField: NSTextField!
    
    
    
    
    /*Variables*/
    //var nameOfWS = "Stuff" //Selected WS
    var directoryPath:String!
    var selectedFile:String!
    var contentsOfWD = [NSManagedObject]() //Stores instances of entity 'Working-Set'
    /*Variables for Sorting Table View*/
    var sortOrder = Directory.FileOrder.Name
    var sortAscending = true

    func setNoteTable(){
        
        
        
        let wd = singleton.coreDataObject.getEntityObject("WorkingDomain", idKey: "nameOfWD", idName: singleton.openedWD)
        
        
        
        let noteOfWD = wd.valueForKey("noteForWD")
        
        if( noteOfWD == nil ){
            textField.stringValue = "Type your notes here."
        }
        else{
            textField.stringValue = noteOfWD as! String
        }
        
        
    }
    
    
    func setupTableView(){
        tableViewWD!.setDelegate(self)
        tableViewWD!.setDataSource(self)
        tableViewWD!.target = self
        tableViewWD.doubleAction = "tableViewDoubleClick:"
        
     
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveNameChange_Button:",name:"updateWD", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rmvFile",name:"remove", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "saveName",name:"saver", object: nil)

        
    }
    
 
    
    func openPath(){
        
        let tval = pathControl.clickedPathComponentCell()?.URL?.filePathURL
        
        let nval = (tval?.relativePath)! as String
        
        print( nval )
        
        
        let value = (pathControl.clickedPathComponentCell()?.URL?.relativeString)! as String
        //print( value )
        let openWindowObject = windowManager()
        
        let filePath:String!
        
        
        filePath = value
        
        
        NSWorkspace.sharedWorkspace().selectFile(nil, inFileViewerRootedAtPath: nval)
    }

    /*Set-up View*/
    override func viewDidLoad() {
        super.viewDidLoad()
        print("The value is now: \(singleton.openedWD)")
        nameOfWD.stringValue = singleton.openedWD
        loadedWDName = nameOfWD.stringValue
        setupTableView()
        pathControl.doubleAction = "openPath"
        setNoteTable()
        
        let registeredTypes:[String] = [NSStringPboardType]
        tableViewWD.registerForDraggedTypes(registeredTypes)
        NSLog(tableViewWD.registeredDraggedTypes.description)
        
        
    }

    override func awakeFromNib() {
        
    }
    
    func rmvFile(){
        singleton.coreDataObject.deleteEntityObject("File", nameOfKey: "nameOfFile", nameOfObject: selectedFile)
        
        self.reloadFileList()
        
    }
    
    func saveName(){
        print("Notification")
        nameOfWD.stringValue = singleton.openedWD
        print(nameOfWD.stringValue)
        singleton.coreDataObject.editEntityObject("WorkingDomain", nameOfKey: "nameOfWD", oldName: loadedWDName, editName: nameOfWD.stringValue)
        loadedWDName = nameOfWD.stringValue
        singleton.openedWD = loadedWDName
        NSNotificationCenter.defaultCenter().postNotificationName("update", object: nil)
        NSNotificationCenter.defaultCenter().postNotificationName("UVS", object: nil)
        self.reloadFileList()
        
        print("Saved!")
    }
    
    
    
    
    
    
    @IBAction func saveNameChange_Button(sender: AnyObject) {
        singleton.coreDataObject.editEntityObject("WorkingDomain", nameOfKey: "nameOfWD", oldName: loadedWDName, editName: nameOfWD.stringValue)
        loadedWDName = nameOfWD.stringValue
        singleton.openedWD = loadedWDName
        NSNotificationCenter.defaultCenter().postNotificationName("update", object: nil)
        self.reloadFileList()
        print("Saved!")
    }
    
    
    
    @IBAction func removeFile_Button(sender: AnyObject) {
        
        singleton.openWindowObject.setWindow("Main", nameOfWindowController: "removeFileWindow")
        singleton.openWindowObject.runModalWindow()
        //self.removeSelectedFile()
    }
    
    
    @IBAction func EditWD_Button(sender: AnyObject) {
        
        singleton.openWindowObject.setWindow("Main", nameOfWindowController: "EditWDWindow")
        singleton.openWindowObject.runModalWindow()
        
        
        
    }
    
    
    @IBAction func onEnterTextFieldButton(sender: NSTextField) {
        
        print("Note saved!")
        
        singleton.coreDataObject.setValueOfEntityObject("WorkingDomain", idKey: "nameOfWD", nameOfKey: "noteForWD", idName: singleton.openedWD, editName: sender.stringValue)
        
        
    }
    
    
    
    
    
    
    
    
    func updateTableViewWD(){
        self.reloadFileList()
    }
    
    func reloadFileList() {
        //directoryItems = directory?.contentsOrderedBy(sortOrder, ascending: sortAscending)
        tableViewWD!.reloadData()
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
            reloadFileList()
        }
    }
}
