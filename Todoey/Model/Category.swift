//
//  Category.swift
//  Todoey
//
//  Created by Ivan Romero on 05/02/2022.
//  Copyright © 2022 Seven Software. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}
