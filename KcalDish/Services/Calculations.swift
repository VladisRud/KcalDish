//
//  Calculations.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 31.07.2024.
//

import Foundation

final class Calculations {
    
    static let shared = Calculations()
    
    func getDishNutrition(_ dish: Dish, totalMass: Double) -> Dish {
        let products = getAddonArray(dish)
        var productsMass = 0.0
        var productsKcal = 0.0
        var productsFat = 0.0
        var productsCarbs = 0.0
        var productsProts = 0.0
        
        for i in 0..<products.count {
            productsMass += products[i].mass
            productsKcal += products[i].kcal / 100 * products[i].mass
            productsFat += products[i].fats / 100 * products[i].mass
            productsCarbs += products[i].carbohydrates / 100 * products[i].mass
            productsProts += products[i].proteins / 100 * products[i].mass
        }
        
        let kefMass = productsMass / totalMass
        
        dish.totalMass = totalMass
        dish.kcal = ((productsKcal / productsMass) * 100) * kefMass
        dish.fats = ((productsFat / productsMass) * 100) * kefMass
        dish.carbohydrates = ((productsCarbs / productsMass) * 100) * kefMass
        dish.proteins = ((productsProts / productsMass) * 100) * kefMass
        
        return dish
        
    }
    
    private func getAddonArray(_ dish: Dish) -> [Ingredients] {
        (dish.ingredients as? Set<Ingredients>)?.sorted(by: { $0.id < $1.id }) ?? []
    }

}
