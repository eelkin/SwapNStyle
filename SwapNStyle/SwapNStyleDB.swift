//
//  SwapNStyleDB.swift
//  SwapNStyle
//
//  Created by Evan Elkin on 12/4/16.
//  Copyright © 2016 Evan Elkin. All rights reserved.
//

import SQLite

class ItemDB {
    // singleton pattern
    static let instance = ItemDB()
    
    // connection to database
    private var db: Connection? = nil
    
    // table and expressions
    private let clothes = Table("clothes")
    private let id = Expression<Int64>("id")
    private let itemType = Expression<String>("itemType")
    private let itemPicture = Expression<String>("itemPicture")
    
    init () {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do {
            db = try Connection("\(path)/SwapNStyle.sqlite")
            
            //COMMENT OUT LINE WHEN ACTUALLY RUNNING APP
            //try db?.run("DROP TABLE clothes")
            
            createTable()
        } catch {
            print("SWAPNSTYLE: Unable to open the database")
        }
    }
    
    func createTable() {
        do {
            try db!.run(clothes.create { table in
                table.column(id, primaryKey: true)
                table.column(itemType)
                table.column(itemPicture)
            })
        } catch {
            print("SWAPNSTYLE: Unable to create table")
        }
    }
    
    // need to work on adding items, etc
    func add(item: Item) -> Int64?{
        do {
            let insert = clothes.insert(
                itemType <- item.itemType,
                itemPicture <- item.itemPicture)
            
            let id = try db!.run(insert)
            return id
        } catch {
            print("SWAPNSTYLE: Insert failed")
            return nil
        }
    }
    
    func deleteItem(aID: Int64) {
        do {
            let item = clothes.filter(id == aID)
            let _ = try db!.run(item.delete())
        } catch {
            print("SWAPNSTYLE: Delete Failed")
        }
    }
    
    func getClothes() -> [Item] {
        var clothes: [Item] = []
        
        do {
            for item in try db!.prepare(self.clothes) {
                clothes.append(
                    Item(id: item[id],
                         itemType: item[itemType],
                         itemPicture: item[itemPicture]))
            }
        } catch {
            print("SWAPNSTYLE: Unable to read the table")
        }
        return clothes
    }
}
