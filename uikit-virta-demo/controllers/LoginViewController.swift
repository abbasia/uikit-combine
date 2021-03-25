//
//  LoginViewController.swift
//  uikit-virta-demo
//
//  Created by abbasi on 14.3.2021.
//

import Foundation
import UIKit
import Combine

final class LoginViewController: UIViewController {
    let viewModel :LoginViewModel
    
    let headerLabel = UILabel()
    let notificationLabel = UILabel()
    let imageView = UIImageView()
    let loginButton = UIButton()
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    
    let emailView = TextFieldView(imageName: "icPerson", placeholderText: "Username")
    let passwordView = TextFieldView(imageName: "icLock", placeholderText: "Password", isSecure: true)
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        
        addSubviews()
        configureDisplay()
        configureConstraints()
        
        loginButton.tapPublisher.sink { [weak self]  (_) in
            self?.activityIndicatorView.startAnimating()
            self?.viewModel.login()
        }.store(in: &cancellable)
        
        viewModel.$notification.sink { [weak self] (notification) in
            self?.notificationLabel.text = notification.message
            self?.notificationLabel.textColor = notification.color
            self?.activityIndicatorView.stopAnimating()
        }.store(in: &cancellable)
        
        emailView.textField.textPublisher.assign(to: \.email, on: viewModel).store(in: &cancellable)
        passwordView.textField.textPublisher.assign(to: \.password, on: viewModel).store(in: &cancellable)
        
    }
    
    
    func configureDisplay()  {
        view.backgroundColor = .white
        headerLabel.font = UIFont.boldSystemFont(ofSize: 18)
        headerLabel.text = viewModel.headerText
        imageView.image = UIImage(named: "logIn")
        loginButton.setTitle("Log in", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        loginButton.backgroundColor = .yellow
        activityIndicatorView.hidesWhenStopped = true
    }
    
    func configureConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 40),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            notificationLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            notificationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationLabel.heightAnchor.constraint(equalToConstant: 30),
            
            emailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            emailView.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 30),
            emailView.heightAnchor.constraint(equalToConstant: 50),
            
            passwordView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            passwordView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            passwordView.topAnchor.constraint(equalTo: emailView.bottomAnchor, constant: 30),
            passwordView.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicatorView.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 20),
            activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            loginButton.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 70),
            loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func addSubviews()  {
        for v in [headerLabel,imageView, notificationLabel,emailView, passwordView, loginButton,activityIndicatorView] {
            v.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(v)
        }
    }
    
    init(_ appModel: AppModel) {
        self.viewModel = LoginViewModel(appModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
