//
//  UIViewController+Alert.swift
//  TestApp
//
//  Created by Wojtek Frątczak on 2017-05-29.
//  Copyright © 2017 AlayaCare. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showErrorAlert(with message: String) {
        let errorAlertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }
    
}
