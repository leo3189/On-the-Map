//
//  CustomView.swift
//  On The Map
//
//  Created by leonard on 3/26/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showInfo(title: String = "Info", message: String, action: ( () -> Void)? = nil) {
        performUIUpdateOnMain {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: {(alertAction) in
                action?()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func showConfirmationAlert(message: String, actionTitle: String, action: @escaping () -> Void) {
        performUIUpdateOnMain {
            let ac = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (actionAction) in
                action()
            }))
            self.present(ac, animated: true)
        }
    }
    
    func enableUI(views: UIControl..., enable: Bool) {
        performUIUpdateOnMain {
            for view in views {
                view.isEnabled = enable
            }
        }
    }
    
    func performUIUpdateOnMain(_ updates: @escaping () -> Void) {
        DispatchQueue.main.async {
            updates()
        }
    }
    
    func openWithSafari(_ url: String) {
        guard let url = URL(string: url), UIApplication.shared.canOpenURL(url) else {
            showInfo(message: "Invalid link")
            return
        }
        UIApplication.shared.open(url, options: [:])
    }

}
