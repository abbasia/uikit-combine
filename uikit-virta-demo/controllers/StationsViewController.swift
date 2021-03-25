//
//  StationsViewController.swift
//  uikit-virta-demo
//
//  Created by abbasi on 16.3.2021.
//

import Foundation
import UIKit
import Combine

class StationsViewController: UITableViewController {
    
    let viewModel : StationsViewModel
    let identifier = "cellIdentifier"
    
    var cancellable = Set<AnyCancellable>()
    var stations = [Station]()
    
    override func viewDidLoad() {
        
        configureDisplay()
        configureTableView()
        
        fetchStations()
        
        viewModel.$sortedStations
            .receive(on: RunLoop.main)
            .sink { [weak self] stations in
                self?.stations = stations
                self?.tableView.reloadData()
                
        }.store(in: &cancellable)
        
    }
    
    func fetchStations(){
        viewModel.appModel.fetchStations()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! StationCell
        
        let station = stations[indexPath.row]
        cell.updateContent(station: station, showDistancePublisher: viewModel.$showDistance, showKwPublisher: viewModel.$showKw)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let station = stations[indexPath.row]
        
        let connectorCount = station.connectors.count
        return computeHeight(connectorCount: connectorCount)
        
    }
    
    func computeHeight(connectorCount: Int) -> CGFloat{
        if connectorCount > 0 {
            var height =  HeaderView.height
            
            if connectorCount <= 3 {
                height += ConnectorView.height
            }
            else if connectorCount.isMultiple(of: 3) {
                height += (CGFloat(connectorCount/3) * ConnectorView.height)
            }else{
                height += (CGFloat(connectorCount/3 + 1) * ConnectorView.height)
            }
            return height
        }
        return HeaderView.height
    }
    
    func configureTableView(){
        tableView.register(StationCell.self, forCellReuseIdentifier: identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
    }
    
    func configureDisplay()  {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.barTintColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        navigationItem.setHidesBackButton(true, animated: true)
        title = "Stations nearby"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsTapped))
        
    }
    
    
    @objc func settingsTapped()  {
        showSettingsView()
    }
    
    func showSettingsView(){
        let settingsVC = SettingsViewController()
        settingsVC.showKwSwitch.isOn = viewModel.showKw
        settingsVC.showDistanceSwitch.isOn = viewModel.showDistance
        
        settingsVC.showKwSwitch.tapPublisher.assign(to: \.showKw, on: viewModel).store(in: &settingsVC.cancellable)
        settingsVC.showDistanceSwitch.tapPublisher.assign(to: \.showDistance, on: viewModel).store(in: &settingsVC.cancellable)
        
        navigationController?.present(settingsVC, animated: true, completion: nil)
        
    }
    
    init(_ appModel: AppModel) {
       viewModel = StationsViewModel(appModel)
       super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
}

