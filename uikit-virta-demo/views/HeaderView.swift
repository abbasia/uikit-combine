//
//  HeaderView.swift
//  uikit-virta-demo
//
//  Created by abbasi on 20.3.2021.
//

import Foundation
import UIKit
class HeaderView: UIView {
    static let height: CGFloat = 50
    let nameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    let directionImageView = UIImageView(image: UIImage(named: "icNavigate"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        configureDisplay()
        configureConstraints()
    }
    
    func configureConstraints()  {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 10),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            addressLabel.heightAnchor.constraint(equalToConstant: 18),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            addressLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            
            directionImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            directionImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            distanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            distanceLabel.trailingAnchor.constraint(equalTo: directionImageView.leadingAnchor, constant: -3)
        ])
        
    }
    
    func addSubviews()  {
        for v in [nameLabel,addressLabel,distanceLabel,directionImageView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            addSubview(v)
        }
    }
    
    func configureDisplay(){
        backgroundColor = .white
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.textColor = .darkText
        
        
        addressLabel.font = .preferredFont(forTextStyle: .subheadline)
        addressLabel.textColor = .gray
        
        distanceLabel.font = .preferredFont(forTextStyle: .footnote)
        addressLabel.textColor = .gray
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
