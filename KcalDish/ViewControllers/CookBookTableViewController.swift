//
//  BookTableViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 21.07.2024.
//

import UIKit

class CookBookTableViewController: UITableViewController {
    
    private var dishes: [Dish] = []
    private var products: [Ingredients] = []
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        let dish = dishes[indexPath.row]
        products = getAddonArray(dish)
        content.text = (dish.dishName ?? "nil")
        cell.contentConfiguration = content
        return cell
    }
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dishInfoVC = DishInformationViewController()
        let dish = dishes[indexPath.row]
        products = getAddonArray(dish)
        dishInfoVC.cellNumber = products.count
        dishInfoVC.dish = dishes[indexPath.row]
        dishInfoVC.products = products
        present(dishInfoVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(dishes[indexPath.row])
            dishes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
}

private extension CookBookTableViewController {
    func fetchData() {
        storageManager.fetchData { [unowned self] result in
            switch result {
            case .success(let dishes):
                self.dishes = dishes
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
