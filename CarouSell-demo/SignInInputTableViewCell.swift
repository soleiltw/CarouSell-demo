//
//  SignInInputTableViewCell.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/13/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit

enum SignInInputMode: Int {
    case UserName
    case Password
    case Email
}

// STEP 1: declare a class protocal(via ": class")
protocol SignInInputTableViewCellDelegate: class {
    // STEP 2: declare the func(event) the delegate needs
    func didEditTextField(mode: SignInInputMode, text: String?)
}

class SignInInputTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // STEP 3: declare a weak class property "delegate"
    weak var delegate: SignInInputTableViewCellDelegate?
    
    @IBOutlet weak var fieldNameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var fieldIconImageView: UIImageView!
    
    
    var mode: SignInInputMode! {
        didSet {
            if mode == .UserName {
                self.fieldNameLabel.text = "Username"
                self.fieldIconImageView.image = UIImage(named: "head")
                self.textField.placeholder = "Choose a usernmae"
            } else if mode == .Password {
                self.fieldNameLabel.text = "Password"
                self.fieldIconImageView.image = UIImage(named: "lock")
                self.textField.placeholder = "Choose a password"
                self.textField.secureTextEntry = true
            } else if mode == .Email {
                self.fieldNameLabel.text = "Email"
                self.fieldIconImageView.image = UIImage(named: "email")
                self.textField.placeholder = "you@domain.com"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // STEP 4: when the event is triggered, ask delegate to perform the related func
        self.delegate?.didEditTextField(self.mode, text: textField.text)
    }
}
