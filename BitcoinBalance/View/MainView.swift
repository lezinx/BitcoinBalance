//
//  MainView.swift
//  BitcoinBalance
//
//  Created by Ziong on 2/11/19.
//  Copyright © 2019 Ziong. All rights reserved.
//

import UIKit

// Creating UI programmatically

class MainView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
      
        setupViews()
        setupConstraints()
        
    }
    
    func setupViews() {
        self.backgroundColor = .white
        self.addSubview(addressTextField)
        self.addSubview(checkBalanceButton)
    }
    
    func setupConstraints() {
        addressTextField.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        addressTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        addressTextField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.75).isActive = true
        addressTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        checkBalanceButton.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 30).isActive = true
        checkBalanceButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        checkBalanceButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        checkBalanceButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    let addressTextField: UITextField = {
        let textField =  UITextField()
        textField.placeholder = "Enter wallet here"
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let checkBalanceButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Check Balance", for: .normal)
        button.layer.cornerRadius = 15
        return button
    }()

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
