//
//  CalculationTableViewCell.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 05.07.2024.
//

import UIKit

class CalculationTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    let cellNumber = 0
    let measure = Measure.shared
    
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
        stack.distribution = .equalCentering
        stack.spacing = 20
        return stack
    }()
    
    private var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .equalCentering
        stack.spacing = 20
        return stack
    }()
    
    var productNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product name"
        textField.autocorrectionType = .no
        textField.layer.borderColor = UIColor.myColorMain.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.setPadding(top: 15, left: 10, bottom: 15, right: 10)
        return textField
    }()
    
    var productMassTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product mass"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productKcalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Kcal"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productFatsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Fats"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productCarbsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Carbohydrates"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productProtsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Product Proteins"
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .none
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Name:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(named: "MyColorText")
        return label
    }()
    
    var productMassLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Mass:"
        return label
    }()
    
    var productKcalLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Kcal:"
        return label
    }()
    
    var productFatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Fats:"
        return label
    }()
    
    var productCarbohydratesLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Carbs:"
        return label
    }()
    
    var productProteinsLabel: UILabel = {
        let label = UILabel()
        label.text = "Product Proteins:"
        return label
    }()
    
    var footerVeiw: UIView = {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }()
    
    
    private func addElementInCell() {
        [
            textFieldStack,
            labelStack,
            productNameTextField,
            productMassTextField,
            productKcalTextField,
            productFatsTextField,
            productCarbsTextField,
            productProtsTextField,
            productNameLabel,
            productMassLabel,
            productKcalLabel,
            productFatsLabel,
            productCarbohydratesLabel,
            productProteinsLabel,
            footerVeiw
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(productNameLabel)
        contentView.addSubview(productNameTextField)
        contentView.addSubview(textFieldStack)
        contentView.addSubview(labelStack)
        contentView.addSubview(footerVeiw)
        
        [
            productMassTextField,
            productKcalTextField,
            productFatsTextField,
            productCarbsTextField,
            productProtsTextField
        ].forEach {
            $0.layer.borderColor = UIColor.myColorMain.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 5
            $0.setPadding(top: 15, left: 10, bottom: 15, right: 10)
            textFieldStack.addArrangedSubview($0)
        }
        
        [
            productMassLabel,
            productKcalLabel,
            productFatsLabel,
            productCarbohydratesLabel,
            productProteinsLabel
        ].forEach {
            $0.font = .systemFont(ofSize: 18)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.adjustsFontSizeToFitWidth = true
            $0.textColor = UIColor(named: "MyColorText")
            labelStack.addArrangedSubview($0)
        }
    }
    
    private func setUpCell() {
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productNameLabel.bottomAnchor.constraint(equalTo: productNameTextField.topAnchor, constant: -8),
            productNameTextField.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 8),
            productNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            productNameTextField.bottomAnchor.constraint(equalTo: textFieldStack.topAnchor, constant: -24),
            productNameTextField.bottomAnchor.constraint(equalTo: labelStack.topAnchor, constant: -24),
            labelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(equalTo: textFieldStack.leadingAnchor, constant: -16),
            labelStack.bottomAnchor.constraint(equalTo: footerVeiw.topAnchor, constant: -8),
            textFieldStack.leadingAnchor.constraint(equalTo: labelStack.trailingAnchor, constant: 16),
            textFieldStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textFieldStack.bottomAnchor.constraint(equalTo: footerVeiw.topAnchor, constant: -8),
            productNameTextField.heightAnchor.constraint(equalToConstant: 30),
//            productMassTextField.heightAnchor.constraint(equalTo: productNameTextField.heightAnchor),
//            productKcalTextField.heightAnchor.constraint(equalTo: productNameTextField.heightAnchor),
//            productFatsTextField.heightAnchor.constraint(equalTo: productNameTextField.heightAnchor),
//            productCarbsTextField.heightAnchor.constraint(equalTo: productNameTextField.heightAnchor),
//            productProtsTextField.heightAnchor.constraint(equalTo: productNameTextField.heightAnchor),
            footerVeiw.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            footerVeiw.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            footerVeiw.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            footerVeiw.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text as NSString? else { return true }
        let newText = currentText.replacingCharacters(in: range, with: string)
        textDidChange?(newText)
        return true
    }
    
}

extension UITextField {
    func setPadding(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always

        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always

        self.textRect(forBounds: self.bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)))
        self.editingRect(forBounds: self.bounds.inset(by: UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)))
    }
}

