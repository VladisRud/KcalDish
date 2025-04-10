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
        createAddButton()
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
            cell.productNameLabel.text = "\(productCart[indexPath.row].name ?? "")"
            cell.productKcalLabel.text = "Kcal: \(productCart[indexPath.row].kcal)"
            cell.productFatsLabel.text = "Fats: \(productCart[indexPath.row].fats)"
            cell.productCarbsLabel.text = "Carbs: \(productCart[indexPath.row].carbohydrates)"
            cell.productProtsLabel.text = "Prots: \(productCart[indexPath.row].proteins)"
        }
        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = productCart[indexPath.row].name
        triggerHapticFeedback()
        showAlertCopy()
        tableView.deselectRow(at: indexPath, animated: true)
        
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
    
    func createAddButton() {
        let addProductCartButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addProductCart)
        )
        self.navigationItem.rightBarButtonItem = addProductCartButton
    }
    
    @objc func addProductCart() {
        showAlert()
    }
    
    func triggerHapticFeedback() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Add new product", message: "Please enter information for 100 gr of product", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Product name"
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .sentences
        }
        alert.addTextField { textField in
            textField.placeholder = "Kcal"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Fat"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Carbs"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .decimalPad
        }
        alert.addTextField { textField in
            textField.placeholder = "Prot"
            textField.autocorrectionType = .no
            textField.spellCheckingType = .no
            textField.autocapitalizationType = .none
            textField.keyboardType = .decimalPad
        }
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { _ in
            let product = self.storageManager.createProductCart()
            product.name = alert.textFields?[0].text ?? "No name"
            product.kcal = self.createDoubleFromTFText((alert.textFields?[1])!)
            product.fats = self.createDoubleFromTFText((alert.textFields?[2])!)
            product.carbohydrates = self.createDoubleFromTFText((alert.textFields?[3])!)
            product.proteins = self.createDoubleFromTFText((alert.textFields?[4])!)
            self.storageManager.saveContext()
            self.fetchData()
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(saveButton)
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertCopy() {
        let alert = UIAlertController(title: "Succes", message: "You copied product name", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
    }
    
    func createDoubleFromTFText(_ tf: UITextField) -> Double {
        guard let textToDouble = tf.text else { return 999 }
        let doubleText = textToDouble.replacingOccurrences(of: ",", with: ".")
        return Double(doubleText) ?? 999
    }

}
