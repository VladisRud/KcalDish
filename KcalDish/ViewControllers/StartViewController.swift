//
//  ViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class StartViewController: UIViewController {
    
    var cellNumber = 30
    var cellArray: [CalculationTableViewCell] = []
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
        fillCellsArray()
        
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
    private var greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "Hi, let's start calculate your dish!"
        label.textColor = UIColor(named: "MyColorText")
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
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

private extension StartViewController {
    func addElementsOnScrenn() {
        [
            greetingLabel,
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
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dishNameTextField.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 16),
            dishNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dishNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dishTotalMassTextField.topAnchor.constraint(equalTo: dishNameTextField.bottomAnchor, constant: 16),
            dishTotalMassTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dishTotalMassTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: dishTotalMassTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: saveDishButton.topAnchor, constant: -16),
            saveDishButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveDishButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveDishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
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

extension StartViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellArray[indexPath.row]
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
        
        for i in 0..<cellArray.count {
            let product = storageManager.createProduct()
            let cell = cellArray[i]
            product.name = cell.productNameTextField.text ?? ""
            product.mass = createDoubleFromTFText(cell.productMassTextField)
            product.kcal = createDoubleFromTFText(cell.productKcalTextField)
            product.fats = createDoubleFromTFText(cell.productFatsTextField)
            product.carbohydrates = createDoubleFromTFText(cell.productCarbsTextField)
            product.proteins = createDoubleFromTFText(cell.productProtsTextField)
            
            if checkProduct(product) == true && checkProductCart(product) == false {
                let productCart = storageManager.createProductCart()
                productCart.name = cell.productNameTextField.text ?? "No name"
                productCart.mass = createDoubleFromTFText(cell.productMassTextField)
                productCart.kcal = createDoubleFromTFText(cell.productKcalTextField)
                productCart.fats = createDoubleFromTFText(cell.productFatsTextField)
                productCart.carbohydrates = createDoubleFromTFText(cell.productCarbsTextField)
                productCart.proteins = createDoubleFromTFText(cell.productProtsTextField)
                newDish.addToIngredients(product)
            }
            clearAllTF(cell)
        }
        newDish = calculation.getDishNutrition(newDish, totalMass: totalMass)
        storageManager.saveContext()
        showAlert()
    }
    
}

extension StartViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.endEditing(true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Succes!", message: "Nutrition Calculated", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            if let tabBC = self.tabBarController {
                tabBC.selectedIndex = 1
                if let selectedNC = tabBarController?.viewControllers?[1] as? CookBookTableViewController {
                    navigationController?.pushViewController(selectedNC, animated: true)
                }
            }
        })
        present(alert, animated: true)
    }
    
    func createDoubleFromTFText(_ tf: UITextField) -> Double {
        guard let textToDouble = tf.text else { return 999 }
        let doubleText = textToDouble.replacingOccurrences(of: ",", with: ".")
        return Double(doubleText) ?? 999
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
        if product.name == "" || product.kcal == 999 || product.fats == 999  || product.carbohydrates == 999  || product.proteins == 999 {
            return false
        } else {
            return true
        }
    }
    
    func checkProductCart(_ product: Ingredients) -> Bool {
        productCart.contains { productCart in
            productCart.name == product.name
        }
    }
    
    func fillCellsArray() {
        for _ in 0..<cellNumber {
            let cell = CalculationTableViewCell(style: .default, reuseIdentifier: nil)
            cellArray.append(cell)
        }
    }
    
    func clearAllTF(_ cell: CalculationTableViewCell) {
        cell.productNameTextField.text = ""
        cell.productMassTextField.text = ""
        cell.productKcalTextField.text = ""
        cell.productFatsTextField.text = ""
        cell.productCarbsTextField.text = ""
        cell.productProtsTextField.text = ""
        dishNameTextField.text = ""
        dishTotalMassTextField.text = ""
    }
    
}













/*
override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .myColorBackground
    addElementsOnScreen()
    doConstainsStack()
    calculateButton.addTarget(self, action: #selector(startCalculate), for: .touchUpInside)
    self.title = "Calculate"
}

override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
}

// MARK: - UIElements and Constrains
private var mainStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.distribution = .fillEqually
    stack.alignment = .center
    stack.spacing = 20
    return stack
}()

private var greetingLabel: UILabel = {
    let label = UILabel()
    label.text = "Hi, let's start calculate your dish!"
    label.textColor = UIColor(named: "MyColorText")
    label.font = .systemFont(ofSize: 20)
    return label
}()

private var productNumberTF: UITextField = {
    let textField = UITextField()
    textField.placeholder = "How many ingredients?"
    textField.borderStyle = .roundedRect
    textField.layer.borderColor = UIColor.myColorMain.cgColor
    textField.layer.borderWidth = 2
    textField.layer.cornerRadius = 5
    textField.keyboardType = .numberPad
    return textField
}()

private var calculateButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Calculate", for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.layer.cornerRadius = 10
    return button
}()
}

private extension StartViewController {
func addElementsOnScreen() {
    [
        mainStack,
        greetingLabel,
        productNumberTF,
        calculateButton
    ].forEach {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    view.addSubview(mainStack)
    
    [
        greetingLabel,
        productNumberTF,
        calculateButton
    ].forEach {
        mainStack.addArrangedSubview($0)
    }
}

func doConstainsStack() {
    NSLayoutConstraint.activate([
        mainStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
        mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
    ])
}

@objc func startCalculate() {
    guard let numberText = productNumberTF.text, let number = Int(numberText) else {
        return
    }
    let calcVC = CalculationViewController()
    calcVC.cellNumber = number
    view.endEditing(true)
    present(calcVC, animated: true)
}
*/
