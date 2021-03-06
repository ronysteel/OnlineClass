//
//  KeyValueStore.swift
//  jufangzhushou
//
//  Created by 刘兆娜 on 16/6/25.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import Foundation
import CoreData
import QorumLogs


class KeyValueStore {
    
    static let key_jifen = "key_jifen"
    static let key_chaifu = "key_chaifu"
    static let key_tuandui = "key_tuandui"
    static let key_tuijian = "key_tuijian"
    static let key_ordercount = "key_ordercount"
    
    var coreDataStack = CoreDataStack(modelName: "jufangzhushou")
    
    func save(key: String, value: String) -> Bool {
        
        //首先查询key是否存在
        let oldKeyValuePair: KeyValueEntity?
        
        do {
            oldKeyValuePair = try getKeyValuePair(key)  //error happens
        } catch {
            return false
        }
        
        
        if oldKeyValuePair == nil {  //the key is not exist
            let context = coreDataStack.mainQueueContext
            var entity: KeyValueEntity!
            context.performBlockAndWait() {
                entity = NSEntityDescription.insertNewObjectForEntityForName("KeyValueEntity", inManagedObjectContext: context) as! KeyValueEntity
                entity.key = key
                entity.value = value
            }
            
        } else {                     //the key is exist
            oldKeyValuePair?.value = value
        }
        
        do {
            try coreDataStack.saveChanges()
        }
        catch let error {
            QL4("Core Data save failed: \(error)")
            return false
        }
        
        return true
        
    }
    
    private func getKeyValuePair(key: String) throws -> KeyValueEntity?  {
        let fetchRequest = NSFetchRequest(entityName: "KeyValueEntity")
        fetchRequest.sortDescriptors = nil
        fetchRequest.predicate = NSPredicate(format: "key = %@", key)
        
        let mainQueueContext = self.coreDataStack.mainQueueContext
        var mainQueueUsers: [KeyValueEntity]?
        var fetchRequestError: ErrorType?
        mainQueueContext.performBlockAndWait() {
            do {
                mainQueueUsers = try mainQueueContext.executeFetchRequest(fetchRequest) as? [KeyValueEntity]
            }
            catch let error {
                fetchRequestError = error
                QL4("isKeyExist()出现异常")
            }
        }
        
        if fetchRequestError == nil {
            if mainQueueUsers?.count == 0 {
                return nil
            } else {
                return mainQueueUsers![0]
            }
        } else {
            throw fetchRequestError!
        }
    }
    
    
    func get(key: String, defaultValue: String = "") -> String? {
        var result : String?
        do {
            let pair = try getKeyValuePair(key)
            
            if pair == nil {
                result = defaultValue
            } else {
                result = pair?.value
            }
        } catch {
            result = defaultValue
        }
        QL1("key = \(key), value = \(result)")
        return result
    }
}