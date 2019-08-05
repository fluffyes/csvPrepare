//
//  ViewController.swift
//  csvPrepare
//
//  Created by Soulchild on 25/07/2019.
//  Copyright © 2019 fluffy. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftCSV

class ViewController: UIViewController {
    
    // restaurants.csv
    let restaurantsCSV = "restaurants"
    
    // food.csv
    let foodCSV = "food"
    
    // default realm object
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("default realm path is \(realm.configuration.fileURL?.absoluteString)")
    }

    @IBAction func generateRealmTapped(_ sender: UIButton) {
        
        // clear everything in the realm in case we clicked the button twice and it adds the same data twice
        try? realm.write {
            realm.deleteAll()
        }
        
        generateRestaurantsFromCSV()
        generateFoodFromCSV()
    }
    
    func generateRestaurantsFromCSV() {
        guard let csvURL = Bundle.main.url(forResource: restaurantsCSV, withExtension: "csv") else {
            print("unable to open csv")
            return
        }
        
        guard let csv : CSV? = try? CSV(url: csvURL) else {
            print("unable to parse csv")
            return
        }
        
        try? csv?.enumerateAsDict{ dict in
            
            let restaurant = Restaurant()
            if let restaurantIDstr = dict["id"],
               let restaurantID = Int(restaurantIDstr) {
                restaurant.restaurantID = restaurantID
            }
            
            if let name = dict["name"] {
                restaurant.name = name
            }
            
            if let slogan = dict["slogan"] {
                restaurant.slogan = slogan
            }
            
            try? self.realm.write {
                self.realm.add(restaurant)
            }
        }
    }
    
    func generateFoodFromCSV() {
        guard let csvURL = Bundle.main.url(forResource: foodCSV, withExtension: "csv") else {
            print("unable to open csv")
            return
        }
        
        guard let csv : CSV? = try? CSV(url: csvURL) else {
            print("unable to parse csv")
            return
        }
        
        try? csv?.enumerateAsDict{ dict in
            guard let restaurantIDstr = dict["restaurant_id"],
                let restaurantID = Int(restaurantIDstr) else {
                print("unable to retrieve restaurant ID")
                return
            }
            
            guard let restaurant = self.realm.object(ofType: Restaurant.self, forPrimaryKey: restaurantID) else {
                print("unable to find Restaurant")
                return
            }
            
            let food = Food()
            
            if let name = dict["name"] {
                food.name = name
            }
            
            if let priceStr = dict["price"],
            let price = Int(priceStr) {
                food.price = price
            }
            
            try? self.realm.write {
                restaurant.foods.append(food)
            }
        }
    }
}

