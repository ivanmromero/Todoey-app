//
//  Item.swift
//  Todoey
//
//  Created by Ivan Romero on 05/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
