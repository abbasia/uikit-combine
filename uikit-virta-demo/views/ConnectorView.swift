//
//  ConnectorView.swift
//  uikit-virta-demo
//
//  Created by abbasi on 20.3.2021.
//

import UIKit
class ConnectorView: UIView {
    static let height: CGFloat = 80
    
    let imageView = UIImageView(image: UIImage(named: "icType2"))
    let countLabel = UILabel()
    let kWLabel = UILabel()
    let valueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureConstraints()
        configureDisplay()
        
    }
    
    func configureConstraints(){
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -7).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20).isActive = true
        
        countLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -20).isActive = true
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 17).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        
        valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor,constant: -8).isActive = true
        valueLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 32).isActive = true
        
        
        kWLabel.centerYAnchor.constraint(equalTo: centerYAnchor,constant: 12).isActive = true
        kWLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 32).isActive = true
        
    }
    
    func configureDisplay(){
        kWLabel.text = "kW"
        countLabel.font = .preferredFont(forTextStyle: .footnote)
        countLabel.textColor = .gray
        countLabel.textAlignment = .center
        
        valueLabel.font = .systemFont(ofSize: 22, weight: .heavy)
        valueLabel.textColor = .darkText
        valueLabel.textAlignment = .center
        
        kWLabel.font = .preferredFont(forTextStyle: .footnote)
        kWLabel.textColor = .gray
        kWLabel.textAlignment = .center
    }
    
    
    func addSubviews()  {
        for v in [imageView, countLabel, kWLabel, valueLabel] {
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
