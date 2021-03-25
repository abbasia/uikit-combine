//
//  SettingsViewController.swift
//  uikit-virta-demo
//
//  Created by abbasi on 21.3.2021.
//

import UIKit
import Combine
class SettingsViewController: UIViewController {
    
    let titleLabel = UILabel()
    let showKwLabel = UILabel()
    let showDistanceLabel = UILabel()
    
    let showKwSwitch = UISwitch()
    let showDistanceSwitch = UISwitch()
    
    let doneButton = UIButton(type: .close)
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDisplay()
        addSubviews()
        configureConstraints()
        
        doneButton.tapPublisher.sink { [weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }.store(in: &cancellable)

    }
    
    func configureDisplay(){
        
        view.backgroundColor = .white
        
        titleLabel.text = "Settings"
        titleLabel.font = .preferredFont(forTextStyle: .largeTitle)
        
        showKwLabel.text = "Show kW:"
        showKwLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        showKwLabel.textAlignment = .left
        
        showDistanceLabel.text = "Show Distance: "
        showDistanceLabel.font = .systemFont(ofSize: 18, weight: .heavy)
        showDistanceLabel.textAlignment = .left
        
    }
    
    func configureConstraints() {
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            showKwLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            showKwLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
            showDistanceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            showDistanceLabel.topAnchor.constraint(equalTo: showKwLabel.bottomAnchor, constant: 30),
            
            doneButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
            showKwSwitch.centerYAnchor.constraint(equalTo: showKwLabel.centerYAnchor),
            showKwSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            showDistanceSwitch.centerYAnchor.constraint(equalTo: showDistanceLabel.centerYAnchor),
            showDistanceSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
    
    func addSubviews()  {
        for v in [titleLabel,showKwLabel,showDistanceLabel,showKwSwitch, showDistanceSwitch,doneButton] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
    }
    
}
