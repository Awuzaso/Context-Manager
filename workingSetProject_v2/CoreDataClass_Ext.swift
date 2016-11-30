

import Cocoa
import CoreData




extension dataCore{
    ////////////////////////////////////////////////////////////
    /*Used to save to the persistent store of the entity,*/
    func saveManagedContext(){
        do {
            try self.managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    func getCountOfDataObjects(nameOfEntity:String) -> Int{
        var dataObjectsCount:Int!
        print("Test")
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity) // Keep, buy will need to specify a string as argument to hold this value.
        
        
        
        let result = get_result(fetchRequest)
        print("Test")
        dataObjectsCount = result.count
        
        print(dataObjectsCount)
        /*
         //3
         do {
         let results =
         try self.managedObjectContext.executeFetchRequest(fetchRequest) // Use a self reference
         let dataObjects = results as! [NSManagedObject] //Define earlier
         dataObjectsCount = dataObjects.count
         } catch let error as NSError {
         print("Could not fetch \(error), \(error.userInfo)")
         dataObjectsCount = 0
         }
         */
        
        return dataObjectsCount
    }
    
    func getDataObjects(nameOfEntity:String) -> Array<NSManagedObject>{
        var dataObjects = [NSManagedObject]()
        
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity) // Keep, buy will need to specify a string as argument to hold this value.
        
        //3
        do {
            let results =
                try self.managedObjectContext.executeFetchRequest(fetchRequest) // Use a self reference
            dataObjects = results as! [NSManagedObject] //Define earlier
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return dataObjects
    }
    
    ////////////////////////////////////////////////////////////
    /*Used to add new objects to the persistent store of a given entity.*/
    func addEntityObject(nameOfEntity: String, nameOfKey: String, nameOfObject: String){
        
        // 1 - Create an instance of NSEntity Description
        let specified_entity = NSEntityDescription.entityForName(nameOfEntity, inManagedObjectContext: self.managedObjectContext)
        
        // 2 - Create new object for entity description and insert it within the entity.
        let new_object = NSManagedObject(entity: specified_entity!, insertIntoManagedObjectContext: self.managedObjectContext)
        
        // 3 - Set value of new object.
        new_object.setValue(nameOfObject, forKey: nameOfKey)
        
        // 4 - Save the object.
        self.saveManagedContext()
        
        
    }
    
    // - MARK: Functions for single objects represented within a database.
    
    //
    func setSingleObjectAttrib(nameOfEntity:String,nameOfKey:String,value:String){
        //1
        _ = [NSManagedObject]()
        
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        
        
        //3
        do{
            
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                
                managedObject.setValue(value, forKey: nameOfKey)
                self.saveManagedContext()
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func getSingleObjectAttrib(nameOfEntity:String,nameOfKey:String)->String{
        var retVal:String!
        //1
        _ = [NSManagedObject]()
        
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        
        
        //3
        do{
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                
                retVal = managedObject.valueForKey(nameOfKey) as! String
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
        return retVal
    }
    
    
    
    ////////////////////////////////////////////////////////////
    /*Used to edit attributes of a specified object of a specific entity. This is functional.*/
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func editEntityObject(nameOfEntity: String, nameOfKey: String, oldName:String, editName: String){
        
        
        //1
        
        
        //2
        
        print("The old name, \(oldName)")
        print("The new name, \(editName)")
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        let predicate = NSPredicate(format: "%K == %@",nameOfKey,oldName/*"Untitled Working Domain"*/)
        fetchRequest.predicate = predicate
        
        //3
        do{
            
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            print(result)
            for managedObject in result {
                
                managedObject.setValue(editName, forKey: nameOfKey)
                print(managedObject.valueForKey(nameOfKey))
                self.saveManagedContext()
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    
    
    
    
    
    /////////////////////////////
    
    /*Used to get a fetch request object as per arguments.*/
    func get_fetchRequest(nameOfEntity: String, nameOfKey: String, nameOfObject: String)->NSFetchRequest{
        //print("Name of entity is, \(nameOfEntity).")
        //print("Name of search key is, \(nameOfKey).")
        //print("Name of search attribute is, \(nameOfObject)")
        // 1 - Generate 'fetchRequest' object.
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        
        // 2 - Specify predicate for 'fetchRequest' object.
        let predicate = NSPredicate(format: "%K == %@",nameOfKey,nameOfObject)
        fetchRequest.predicate = predicate
        
        // 3 - Return 'fetchRequest' object.
        return fetchRequest
    }
    
    
    
    
    
    
    
    func setValueOfEntityObject(nameOfEntity: String, idKey:String, nameOfKey: String, idName:String, editName: String){
        
        
        
        
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        let predicate = NSPredicate(format: "%K == %@",idKey,idName)
        fetchRequest.predicate = predicate
        
        //3
        do{
            
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                
                
                managedObject.setValue(editName, forKey: nameOfKey)
                
                print("Value of \(idName), of attribute, \(nameOfKey) is \(editName)")
                
                self.saveManagedContext()
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    
    
    func getEntityObject(nameOfEntity: String, idKey:String, idName:String )->NSManagedObject{
        var retVal:NSManagedObject!
        
        
        //2
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        let predicate = NSPredicate(format: "%K == %@",idKey,idName)
        fetchRequest.predicate = predicate
        
        //3
        do{
            
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
              
                retVal = managedObject as! NSManagedObject
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }

        
        
        return retVal
    }
    
    
    
    
    
    
    func getValueOfEntityObject(nameOfEntity: String, idKey: String,nameOfKey:String, nameOfObject: String)->String{
        var retVal = "Value"
        
        
        let fetchRequest = NSFetchRequest(entityName: nameOfEntity)
        let predicate = NSPredicate(format: "%K == %@",idKey,nameOfObject/*"Untitled Working Domain"*/)
        fetchRequest.predicate = predicate
        
        //3
        do{
            
            
            let result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            for managedObject in result {
                
                retVal = managedObject.valueForKey(nameOfKey) as! String
                print(retVal)
                self.saveManagedContext()
                
            }
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }

        return retVal
        
        
    }
    
    
    
    
    
    
    /*Used to delete specified objects of a specified entity.*/
    func deleteEntityObject(nameOfEntity: String, nameOfKey: String, nameOfObject: String){
        
        // 1 - Get fetch request
        let fetchRequest = get_fetchRequest(nameOfEntity, nameOfKey: nameOfKey, nameOfObject: nameOfObject)
        
        // 2 = Get array of NSAnyObject
        let result = get_result(fetchRequest)
        
        // 3 - Delete result
        deleteFromEntity(result)
        
    }
    
    
    
    
    
    
    
    /*Used to get resulting array of objects from CoreData  as specified by 'fetchRequest'.*/
    func get_result(fetchRequest:NSFetchRequest)->[AnyObject]{
        // 1 - Generate 'result' array of type, AnyObject.
        var result = [AnyObject]!()
        
        // 2 - Populate array of 'result'.
        do{
            
            result = try self.managedObjectContext.executeFetchRequest(fetchRequest)
            
            
        } catch{
            let fetchError = error as NSError
            print(fetchError)
        }
        
        // 3 - Return array of 'result'.
        return result
    }
    
    
    
    
    
    
    /*Used to delete objects specified by 'result' from a given entity.*/
    func deleteFromEntity(result:[AnyObject]){
        // 1 - Loop through array of 'result'.
        for managedObject in result {
            // 2 - Delete specified object from entity.
            self.managedObjectContext.deleteObject(managedObject as! NSManagedObject)
            // 3 - Save changes to persistent store.
            self.saveManagedContext()
        }
    }
    
    
    
    /*Used to evaluate if a specified object is within an entity's object graph.*/
    func evaluateIfInDB(nameOfEntity: String, nameOfKey: String, nameOfObject: String)->Bool{
        var evalVal: Bool!
        
        // 1 - Fetching
        let fetchRequest = get_fetchRequest(nameOfEntity, nameOfKey: nameOfKey, nameOfObject: nameOfObject)
        
        // 2 - Get array of NSAnyObject
        let result = get_result(fetchRequest)
        
        // 3 - Evaluate.
        if(result.count == 0){
            
            evalVal = false
        }
        else{
            evalVal = true
        }
        
        // 4 - Return 'evalVal'.
        return evalVal
    }
    
    
    
    /*Used to evaluate if a card is within an entity's object graph.*/
    func evaluateIfCardIsInDB(nameOfEntity: String, nameOfKey: String, nameOfObject: String)->Bool{
        var evalVal: Bool!
        
        // 1 - Fetching
        let fetchRequest = get_fetchRequest(nameOfEntity, nameOfKey: nameOfKey, nameOfObject: nameOfObject)
        
        // 2 - Get array of NSAnyObject
        let result = get_result(fetchRequest)
        
        // 3 - Evaluate.
        if(result.count == 0){
            
            evalVal = false
            
            // Add Card to DB
            self.addEntityObject("Card", nameOfKey: "rfidValue", nameOfObject: nameOfObject)
            
            
            
            // Test if Saved:
            let addedCard = self.getEntityObject("Card", idKey: "rfidValue", idName: nameOfObject)
            self.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "cardName", idName: nameOfObject, editName: "Untitled Card")
            self.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "cardOwner", idName: nameOfObject, editName: "Unnamed Owner")
            self.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "dateCreated", idName: nameOfObject, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
            self.setValueOfEntityObject("Card", idKey: "rfidValue", nameOfKey: "dateLastAccessed", idName: nameOfObject, editName: singleton.getDate("EEEE, MMMM dd, yyyy, HH:mm:ss"))
            
            //print( addedCard )
        }
        else{
            //print( "Card is in database." )
            evalVal = true
        }
        
        // 4 - Return 'evalVal'.
        return evalVal
    }
    
    
    
    // RELAITONSHIP FUNCTIONS
    
    func createRelationship(objectOne:NSManagedObject,objectTwo:NSManagedObject,relationshipType:String){
        
        
        // - 1  Add objectTwo to objectOne.
            let objectOfRelationship = NSSet(object:objectTwo)
        
        // -2 Add entityTwo to entityOne.
            objectOne.setValue(objectOfRelationship, forKey: relationshipType)
        
        // -3 Save
            do{
                try objectOne.managedObjectContext?.save()
            } catch {
                let saveError = error as NSError
                print(saveError)
            }
    }
    
    
    func deleteRelationship(object:NSManagedObject,relationshipType:String){
        object.setValue(nil, forKey: relationshipType)
    }
    
}