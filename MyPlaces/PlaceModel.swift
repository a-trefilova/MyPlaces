//
//  PlaceModel.swift
//  MyPlaces
//
//  Created by Константин Сабицкий on 08.04.2020.
//  Copyright © 2020 Константин Сабицкий. All rights reserved.
//

import Foundation

struct Place {
    var name: String
    var location: String
    var type: String
    var image: String
    
    static let restaurantNames = ["BurgerHeroes", "Kitchen", "Bonsai", "X.O.", "Sherlock Holmes", "Speak Easy", "Morris Pub", "Love&Life", "Shock"]
    
   static func getPlaces() -> [Place] {
        var places = [Place]()
        for place in restaurantNames {
            places.append(Place(name: place, location: "Saint-P", type: "Restaurant", image: place))
        }
        
        
        
        
        
        
        return places
        
        
    }

}
