//
//  LoginViewModel.swift
//  uikit-virta-demo
//
//  Created by abbasi on 14.3.2021.
//

import Foundation
import Combine
import UIKit

class LoginViewModel {
    let headerText = "Log in and Charge!"
    let appModel: AppModel
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var notification: Notification = Notification(message: "", type: .Success)
    
    var cancellable = Set<AnyCancellable>()
    
    init(_ appModel: AppModel) {
        self.appModel = appModel
        
        $notification.filter({ (notification) in
            notification.message.count>0
        }).debounce(for: .seconds(5), scheduler: RunLoop.main).sink { _ in
            self.notification  = Notification(message: "", type: .Success)
        }.store(in: &cancellable)
    }
    
    func login() {
        appModel.network.login(email, password)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.notification = Notification(message:"operation completed successfully" , type: .Success)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    self.notification = Notification(message: "invalid email or password", type: .Failure)
                }
            }, receiveValue: { token in
                self.appModel.setToken(t: token.token)
            })
            .store(in: &cancellable)
    }
}


enum NotificationType {
    case Failure
    case Success
}
struct Notification {
    let message:String
    let type: NotificationType
    
    var color: UIColor {
        return ((self.type == .Success) ? .systemGreen : .systemRed)
    }
}
