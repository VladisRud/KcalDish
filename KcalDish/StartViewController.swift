//
//  ViewController.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class StartViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        addElementsOnScreen()
        doConstainsStack()
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
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private var productQuantityTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "How many ingredients?"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 10
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
            productQuantityTF,
            calculateButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(mainStack)
        
        [
            greetingLabel,
            productQuantityTF,
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
    
}
