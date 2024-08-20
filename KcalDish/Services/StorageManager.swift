//
//  StorageManager.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 24.07.2024.
//

import Foundation
import CoreData

enum KFCP {
    case Kcal
    case Fats
    case Carbohydrates
    case Proteins
    
    var textKFCP: String {
        switch self {
        case .Kcal:
            "Kcal"
        case .Fats:
            "Fats"
        case .Carbohydrates:
            "Carbohydrates"
        case .Proteins:
            "Proteins"
        }
    }
}

final class StorageManager {
    
    static let shared = StorageManager()
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Dish")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    func create(_ name: String) -> Dish {
        let dish = Dish(context: viewContext)
        dish.dishName = name
        saveContext()
        return dish
    }
    
    func createProduct() -> Ingredients {
        let ingredients = Ingredients(context: viewContext)
        saveContext()
        return ingredients
    }
    
    func createProductCart() -> ProductCart {
        let productCart = ProductCart(context: viewContext)
        saveContext()
        return productCart
    }
    
    func fetchData(completion: (Result<[Dish], Error>) -> Void) {
        let fetchRequest = Dish.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func fetchDataProductCart(completion: (Result<[ProductCart], Error>) -> Void) {
        let fetchRequest = ProductCart.fetchRequest()
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ dish: Dish, newName: String) {
        dish.dishName = newName
        saveContext()
    }
    
    func delete(_ dish: Dish) {
        viewContext.delete(dish)
        saveContext()
    }
    
    func delete(_ product: ProductCart) {
        viewContext.delete(product)
        saveContext()
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
