//
//  Restaurant.swift
//  csvPrepare
//
//  Created by Soulchild on 04/08/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import Foundation
import RealmSwift

class Restaurant : Object {
    @objc dynamic var restaurantID = 0
    @objc dynamic var name = ""
    @objc dynamic var slogan : String?
    
    let foods = List<Food>()
    
    override class func primaryKey() -> String? {
        return "restaurantID"
    }
}
