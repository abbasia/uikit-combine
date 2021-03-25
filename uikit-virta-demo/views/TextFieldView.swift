//
//  TextFieldView.swift
//  uikit-virta-demo
//
//  Created by abbasi on 14.3.2021.
//

import Foundation
import UIKit

class TextFieldView: UIView {
    
    let imageName: String
    let placeholderText: String
    let isSecure: Bool
    
    let imageView = UIImageView()
    let textField = UITextField()
    let divider = UIView()
    
    init(imageName: String, placeholderText: String, isSecure: Bool = false ) {
        self.imageName = imageName
        self.placeholderText = placeholderText
        self.isSecure = isSecure
        super.init(frame: .zero)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        for v in [imageView,textField,divider] {
            addSubview(v)
            v.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    func configureDisplay() {
        textField.isSecureTextEntry = isSecure
        divider.backgroundColor = .lightGray
        textField.placeholder = placeholderText
        imageView.image = UIImage(named: imageName)
    }
    func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            textField.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            
            divider.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setup(){
        configureDisplay()
        addSubviews()
        configureConstraints()
    }
}
