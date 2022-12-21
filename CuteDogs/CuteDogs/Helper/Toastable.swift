//
//  Toastable.swift
//  CuteDogs
//
//  Created by Victor Sousa on 21/12/2022.
//

import UIKit

protocol Toastable {
    
    func showToast(message : String)
}
extension Toastable where Self: UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(toastLabel)
        toastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        toastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        
        UIView.animate(withDuration: 5.0, delay: 0, options: .curveEaseIn, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
