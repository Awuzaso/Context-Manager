//
//  workingSetSingleton_Class.swift
//  workingSetProject_v2
//
//  Created by Osa on 7/5/16.
//  Copyright © 2016 Osa. All rights reserved.
//

import Cocoa

let singleton = workingSetSingleton()

class workingSetSingleton {
    
    /*Establish Singleton*/
        static let sharedInstance = workingSetSingleton()
    
    /*Objects*/
        var coreDataObject = dataCore()
        var serialPortObject: SerialPortManager!
        let openWindowObject = windowManager()
        let googleChromeObject = chromeManager()
        let desktopWindowObject = desktopWindowManger()
        let previewObject = previewManager()
    
    /*Frequently Used Variables*/
    
        // Bool variable that constrains actions on the basis if a card is present or not.
            var canAssociateVar = false
    
        // The current card that is read.
            var readCard:NSManagedObject!
    
        // The name of the currently opened working domain.
            var openedWD: String!
    
        //Path to user's prefferred serial port.
            var serialPath:String!
    
        // Variable to control if 'canAssoc' window can pop up.
            var canOpenAssocWindow = true
    
    /*Function for retrieving the current date in string form.*/
        func getDate(dateFormat:String)->String{
            
            // - 1 - Gets the current date.
                let currentDate = NSDate()
            
            // - 2 - Setting up date formatter.
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "en_GR")
                dateFormatter.dateFormat = dateFormat
            
            // - 3 - Convert the prior date established earlier.
                var convertedDate = dateFormatter.stringFromDate(currentDate)
            
            return convertedDate
        }
    
}
