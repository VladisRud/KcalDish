//
//  Measure.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 04.10.2024.
//

import Foundation

final class Measure {
    
    static let shared = Measure()
    
    var energyType: Bool = true
    
    var energy: String {
        switch energyType {
        case true:
            "kcal"
        case false:
            "kj"
        }
    }
    
    var massType: Bool = true
    
    var massMeasure: String {
        switch massType {
        case true:
            "g"
        case false:
            "oz"
        }
    }
    
    let message = "Enter information for 100"
    
    let fat = "fat"
    let carbs = "carbs"
    let prot = "prot"
    
    func energyTypeToggle() {
        energyType.toggle()
    }
    
    func massTypeToggle() {
        massType.toggle()
    }
    
}
