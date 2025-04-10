//
//  ProductInformationTableViewCell.swift
//  KcalDish
//
//  Created by Vlad Rudenko on 29.07.2024.
//

import UIKit

class ProductInformationTableViewCell: UITableViewCell {

    let cellNumber = 0

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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    private var labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    var productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    var productMassLabel: UILabel = {
        let label = UILabel()
        label.text = "Mass"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var productKcalLabel: UILabel = {
        let label = UILabel()
        label.text = "Kcal"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var productFatsLabel: UILabel = {
        let label = UILabel()
        label.text = "Fats"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var productCarbsLabel: UILabel = {
        let label = UILabel()
        label.text = "Carbs"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    var productProtsLabel: UILabel = {
        let label = UILabel()
        label.text = "Proteins"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private func addElementInCell() {
        [
            labelStack,
            productNameLabel,
            productMassLabel,
            productKcalLabel,
            productFatsLabel,
            productCarbsLabel,
            productProtsLabel
            
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        contentView.addSubview(productNameLabel)
        contentView.addSubview(labelStack)
        
        [
            productMassLabel,
            productKcalLabel,
            productFatsLabel,
            productCarbsLabel,
            productProtsLabel
        ].forEach {
            labelStack.addArrangedSubview($0)
        }
    }
    
    private func setUpCell() {
        NSLayoutConstraint.activate([
            productNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            productNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            productNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelStack.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 16),
            labelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            labelStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

}
