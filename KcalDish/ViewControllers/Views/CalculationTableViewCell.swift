//
//  CalculationTableViewCell.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class CalculationTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let cellNumber = 0
    
    var textDidChange: ((String) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addElementInCell()
        setUpCell()
        productNameTextField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private var textFieldStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    var productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product name"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        return textField
    }()
    
    var productMassTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product mass"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productKcalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Kcal"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productFatsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Fats"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productCarbsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Carbohydrates"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productProtsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Proteins"
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private func addElementInCell() {
        [
            textFieldStack,
            productNameTextField,
            productMassTextField,
            productKcalTextField,
            productFatsTextField,
            productCarbsTextField,
            productProtsTextField
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(textFieldStack)
        
        [
            productNameTextField,
            productMassTextField,
            productKcalTextField,
            productFatsTextField,
            productCarbsTextField,
            productProtsTextField
        ].forEach {
            textFieldStack.addArrangedSubview($0)
        }
    }
    
    private func setUpCell() {
        NSLayoutConstraint.activate([
            textFieldStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textFieldStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textFieldStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        textDidChange?(newText)
        return true
    }
}
