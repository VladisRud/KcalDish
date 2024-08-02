//
//  DishInformationViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 24.07.2024.
//

import UIKit

class DishInformationViewController: UIViewController {
    
    var dish: Dish = Dish()
    var cellNumber = 2
    var products: [Ingredients] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        addElementsOnScreen()
        doConstrains()
        setUpElements()
    }
    
    private var dishStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .leading
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private var dishNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var dishMassLabel: UILabel = {
        let label = UILabel()
        label.text = "Mass"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var dishKcalLabel: UILabel = {
        let label = UILabel()
        label.text = "Kcal"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var dishFatLabel: UILabel = {
        let label = UILabel()
        label.text = "Fat"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var dishCarbsLabel: UILabel = {
        let label = UILabel()
        label.text = "Carbs"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var dishProteinsLabel: UILabel = {
        let label = UILabel()
        label.text = "Proteins"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ProductInformationTableViewCell.self, forCellReuseIdentifier: "infoCell")
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
}

private extension DishInformationViewController {
    func addElementsOnScreen() {
        [
            dishStack,
            dishNameLabel,
            dishMassLabel,
            dishKcalLabel,
            dishFatLabel,
            dishCarbsLabel,
            dishProteinsLabel,
            tableView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [
            dishNameLabel,
            dishMassLabel,
            dishKcalLabel,
            dishFatLabel,
            dishCarbsLabel,
            dishProteinsLabel
        ].forEach {
            dishStack.addArrangedSubview($0)
        }
    }
    
    func doConstrains() {
        NSLayoutConstraint.activate([
            dishStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dishStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dishStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.topAnchor.constraint(equalTo: dishStack.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
        ])
    }
    
    func setUpElements() {
        dishNameLabel.text = dish.dishName
        dishMassLabel.text = "Mass after cooking: \(String(format: "%.0f", dish.totalMass))"
        dishKcalLabel.text = "Kcal: \(String(format: "%.2f", dish.kcal))"
        dishFatLabel.text = "Fats: \(String(format: "%.2f", dish.fats))"
        dishCarbsLabel.text = "Carbs: \(String(format: "%.2f", dish.carbohydrates))"
        dishProteinsLabel.text = "Proteins: \(String(format: "%.2f", dish.proteins))"
    }
    
}

extension DishInformationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNumber
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! ProductInformationTableViewCell
        for _ in 0..<cellNumber {
            cell.productNameLabel.text = products[indexPath.row].name
            cell.productMassLabel.text = "Mass: \(products[indexPath.row].mass)"
            cell.productKcalLabel.text = "Kcal: \(products[indexPath.row].kcal)"
            cell.productFatsLabel.text = "Fats: \(products[indexPath.row].fats)"
            cell.productCarbsLabel.text = "Carbs: \(products[indexPath.row].carbohydrates)"
            cell.productProtsLabel.text = "Prots: \(products[indexPath.row].proteins)"
        }
        return cell
    }
}
