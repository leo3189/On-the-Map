//
//  logInTextFieldView.swift
//  On The Map
//
//  Created by leonard on 3/21/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit

class logInTextFieldView: UITextField {

    override func awakeFromNib() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.borderStyle = .none
        self.layer.cornerRadius = 5
        
        self.contentHorizontalAlignment = .trailing
    }
}
