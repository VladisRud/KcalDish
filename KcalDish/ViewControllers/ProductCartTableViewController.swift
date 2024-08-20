//
//  ProductCartTableViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 20.08.2024.
//

import UIKit

class ProductCartTableViewController: UITableViewController {

    private var productCart: [ProductCart] = []
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .myColorBackground
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "productCartCell")
        tableView.register(ProductCartTableViewCell.self, forCellReuseIdentifier: "productCartCell")
        self.title = "Product Cart"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productCart.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCartCell", for: indexPath) as! ProductCartTableViewCell
        for _ in 0..<productCart.count {
            cell.productNameLabel.text = "Product Name: \(productCart[indexPath.row].name ?? "")"
            cell.productKcalLabel.text = "Kcal: \(productCart[indexPath.row].kcal)"
            cell.productFatsLabel.text = "Fats: \(productCart[indexPath.row].fats)"
            cell.productCarbsLabel.text = "Carbs: \(productCart[indexPath.row].carbohydrates)"
            cell.productProtsLabel.text = "Prots: \(productCart[indexPath.row].proteins)"
        }
        
//        var content = cell.defaultContentConfiguration()
//        let product = productCart[indexPath.row]
//        content.text = (product.name ?? "nil")
//        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(productCart[indexPath.row])
            productCart.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

private extension ProductCartTableViewController {
    func fetchData() {
        storageManager.fetchDataProductCart { [unowned self] result in
            switch result {
            case .success(let productCart):
                self.productCart = productCart
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        tableView.reloadData()
    }
    
    func getAddonArray(_ dish: Dish) -> [Ingredients] {
        (dish.ingredients as? Set<Ingredients>)?.sorted(by: { $0.id < $1.id }) ?? []
    }
    
}
