//
//  ViewController.swift
//  uikit-virta-demo
//
//  Created by abbasi on 14.3.2021.
//

import UIKit
import Combine
final class ViewController: UIViewController {
    
    
    let appModel = AppModel()
    let loginViewController: LoginViewController
    let stationsViewController: StationsViewController
    
    var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.appModel.isLoggedInPublisher.sink { [weak self ](isLoggedIn) in
            self?.navigationController?.popToRootViewController(animated: false)
            if let controller = isLoggedIn ? self?.stationsViewController : self?.loginViewController {
                self?.showController(viewController: controller)
            }
            
        }.store(in: &cancellable)
        
    }
    
    func showController(viewController: UIViewController)  {
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    
    init() {
        self.loginViewController = LoginViewController(appModel)
        self.stationsViewController = StationsViewController(appModel)
        super.init(nibName: nil, bundle: nil)
   }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

