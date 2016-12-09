//
//  ClothingItem.swift
//  SwapNStyle
//
//  Created by Evan Elkin on 12/4/16.
//  Copyright © 2016 Evan Elkin. All rights reserved.
//

import Foundation
//add itemPicture when I know how to store pictures
class Item {
    var id: Int64?
    var itemType: String
    var itemPicture: String
    
    init(id: Int64, itemType: String, itemPicture: String) {
        self.id = id
        self.itemType = itemType
        self.itemPicture = itemPicture
    }
    
}
