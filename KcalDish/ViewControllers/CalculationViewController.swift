//
//  CalculationTableViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class CalculationViewController: UIViewController {
    
    var cellNumber = 2
    private let storageManager = StorageManager.shared
    private let calculation = Calculations.shared
    private var productCart: [ProductCart] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        addElementsOnScrenn()
        doConstrains()
        saveDishButton.addTarget(self, action: #selector(saveDish), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // MARK: - UIElements
    private var dishNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Dish name"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    private var dishTotalMassTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Dish total mass"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CalculationTableViewCell.self, forCellReuseIdentifier: "calculationCell")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var saveDishButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save Dish", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    
}

private extension CalculationViewController {
    func addElementsOnScrenn() {
        [
            dishNameTextField,
            dishTotalMassTextField,
            tableView,
            saveDishButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    func doConstrains() {
        NSLayoutConstraint.activate([
            dishNameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dishNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dishNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dishTotalMassTextField.topAnchor.constraint(equalTo: dishNameTextField.bottomAnchor, constant: 16),
            dishTotalMassTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dishTotalMassTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: dishTotalMassTextField.bottomAnchor, constant: 36),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: saveDishButton.topAnchor, constant: -16),
            saveDishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveDishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveDishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
    
    func fetchData() {
        storageManager.fetchDataProductCart { [unowned self] result in
            switch result {
            case .success(let productCart):
                self.productCart = productCart
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CalculationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "calculationCell", for: indexPath) as! CalculationTableViewCell
        cell.textDidChange = { [weak self] newText in
            guard let self = self else { return }
            
            if let match = self.productCart.first(where: { $0.name == newText}) {
                cell.productMassTextField.text  = "\(match.mass)"
                cell.productKcalTextField.text  = "\(match.kcal)"
                cell.productFatsTextField.text  = "\(match.fats)"
                cell.productCarbsTextField.text = "\(match.carbohydrates)"
                cell.productProtsTextField.text = "\(match.proteins)"
            } else {
                cell.productMassTextField.text = ""
                cell.productKcalTextField.text = ""
                cell.productFatsTextField.text = ""
                cell.productCarbsTextField.text = ""
                cell.productProtsTextField.text = ""
            }
        }
        return cell
    }
    
    @objc func saveDish() {
        var newDish = storageManager.create(dishNameTextField.text ?? "No name")
        
        guard let totalMass = Double(dishTotalMassTextField.text ?? "0") else { return }
        
        for i in 0..<cellNumber {
            let product = storageManager.createProduct()
            let productCart = storageManager.createProductCart()
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CalculationTableViewCell {
                product.name = cell.productNameTextField.text ?? "No name"
                product.mass = Double(cell.productMassTextField.text ?? "0") ?? 0
                product.kcal = Double(cell.productKcalTextField.text ?? "0") ?? 0
                product.fats = Double(cell.productFatsTextField.text ?? "0") ?? 0
                product.carbohydrates = Double(cell.productCarbsTextField.text ?? "0") ?? 0
                product.proteins = Double(cell.productProtsTextField.text ?? "0") ?? 0
                
                productCart.name = cell.productNameTextField.text ?? "No name"
                productCart.mass = Double(cell.productMassTextField.text ?? "0") ?? 0
                productCart.kcal = Double(cell.productKcalTextField.text ?? "0") ?? 0
                productCart.fats = Double(cell.productFatsTextField.text ?? "0") ?? 0
                productCart.carbohydrates = Double(cell.productCarbsTextField.text ?? "0") ?? 0
                productCart.proteins = Double(cell.productProtsTextField.text ?? "0") ?? 0
            }
            newDish.addToIngredients(product)
            newDish = calculation.getDishNutrition(newDish, totalMass: totalMass)
            storageManager.saveContext()
        }
        dismiss(animated: true)
    }
    
}
