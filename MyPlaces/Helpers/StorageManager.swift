//
//  StorageManager.swift
//  MyPlaces
//
//  Created by Константин Сабицкий on 10.04.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
    
    
    static func deleteObject(_ place: Place) {
        try! realm.write {
            realm.delete(place)
        }
    }
}
