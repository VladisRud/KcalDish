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
        view.backgroundColor = .myColorBackground
        tableView.dataSource = self
        tableView.delegate = self
        addElementsOnScrenn()
        doConstrains()
        saveDishButton.addTarget(self, action: #selector(saveDish), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        textField.layer.borderColor = UIColor.myColorMain.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private var dishTotalMassTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Dish total mass"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.myColorMain.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CalculationTableViewCell.self, forCellReuseIdentifier: "calculationCell")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private var saveDishButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Save Dish", for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.tintColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.frame.size.width = 13
        button.frame.size.height = 100
        button.setTitleColor(.systemBlue, for: .normal)
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
            saveDishButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
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
        cell.selectionStyle = .none
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
        let totalMass = createDoubleFromTFText(dishTotalMassTextField)
        
        for i in 0..<cellNumber {
            let product = storageManager.createProduct()
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CalculationTableViewCell {
                product.name = cell.productNameTextField.text ?? "No name"
                product.mass = createDoubleFromTFText(cell.productMassTextField)
                product.kcal = createDoubleFromTFText(cell.productKcalTextField)
                product.fats = createDoubleFromTFText(cell.productFatsTextField)
                product.carbohydrates = createDoubleFromTFText(cell.productCarbsTextField)
                product.proteins = createDoubleFromTFText(cell.productProtsTextField)
            }
            
            if checkProduct(product) == true {
                if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CalculationTableViewCell {
                    let productCart = storageManager.createProductCart()
                    productCart.name = cell.productNameTextField.text ?? "No name"
                    productCart.mass = createDoubleFromTFText(cell.productMassTextField)
                    productCart.kcal = createDoubleFromTFText(cell.productKcalTextField)
                    productCart.fats = createDoubleFromTFText(cell.productFatsTextField)
                    productCart.carbohydrates = createDoubleFromTFText(cell.productCarbsTextField)
                    productCart.proteins = createDoubleFromTFText(cell.productProtsTextField)
                }
            }
            
            newDish.addToIngredients(product)
            newDish = calculation.getDishNutrition(newDish, totalMass: totalMass)
            storageManager.saveContext()
            
        }
        showAlert()
    }
    
}

extension CalculationViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Succes!", message: "Nutrition Calculated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func createDoubleFromTFText(_ tf: UITextField) -> Double {
        guard let textToDouble = tf.text else { return 999 }
        let doubleText = textToDouble.replacingOccurrences(of: ",", with: ".")
        return Double(doubleText) ?? 0
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    func checkProduct(_ product: Ingredients) -> Bool {
        if product.name == "No name" || product.kcal == 999 || product.fats == 999  || product.carbohydrates == 999  || product.proteins == 999 {
            return true
        } else {
            return false
        }
    }
    
}
