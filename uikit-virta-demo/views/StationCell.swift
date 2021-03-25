//
//  StationCell.swift
//  uikit-virta-demo
//
//  Created by abbasi on 19.3.2021.
//

import UIKit
import Combine

typealias SwitchPublisher = Published<Bool>.Publisher
class StationCell: UITableViewCell {
    
    let header = HeaderView()
    let container = UIView()
    var viewModel = StationCellViewModel()
    
    var addressSubscription: AnyCancellable?
    var showDistanceSubscription: AnyCancellable?
    var showKwSubscription: AnyCancellable?
    
    
    func updateContent(station: Station, showDistancePublisher: SwitchPublisher, showKwPublisher: SwitchPublisher ){
        viewModel.station = station
        flushContainer()
        addConnectors()
        
        header.nameLabel.text = viewModel.name
        header.addressLabel.text = viewModel.address
        header.distanceLabel.text = viewModel.distanceFromUserString()
        
        refreshSubsciptions(showDistancePublisher, showKwPublisher)
    }
    
    func refreshSubsciptions(_ showDistancePublisher: SwitchPublisher, _ showKwPublisher: SwitchPublisher){
        addressSubscription = viewModel.station?.$address
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] address in
                self?.header.addressLabel.text = address
            })
        showDistanceSubscription = showDistancePublisher.sink { [weak self] (showDistance) in
            self?.header.distanceLabel.isHidden = !showDistance
        }
        showKwSubscription = showKwPublisher.sink { [weak self] (showKw) in
            self?.refreshContainers(showKw: showKw)
        }
    }
    
    func refreshContainers(showKw:Bool){
        for v in container.subviews{
            if let connectorVew = v as? ConnectorView {
                connectorVew.kWLabel.isHidden = !showKw
                connectorVew.valueLabel.isHidden = !showKw
            }
        }
    }
    
    override func prepareForReuse() {
        showDistanceSubscription?.cancel()
        showKwSubscription?.cancel()
        addressSubscription?.cancel()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(header)
        addSubview(container)
        configureHeader()
        configureContainer()
        backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        
    }
    
    
    
    func configureHeader() {
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: topAnchor,constant: 2).isActive = true
        header.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0).isActive = true
        header.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureContainer(){
        container.backgroundColor = .white
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 0).isActive = true
        container.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0).isActive = true
        container.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0).isActive = true
        container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        
    }
    
    func addConnectors() {
        var index = 0
        var count = 0
        var topRef: UIView?
        var leadingRef: UIView?
        let connectors = viewModel.station!.connectors
        for power  in connectors.keys{
            let connectorView = ConnectorView()
            container.addSubview(connectorView)
            connectorView.translatesAutoresizingMaskIntoConstraints = false
            if index == 0 {
                connectorView.topAnchor.constraint(equalTo: (topRef != nil) ? topRef!.bottomAnchor: container.topAnchor, constant: 0).isActive = true
                connectorView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0).isActive = true
                connectorView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
                connectorView.heightAnchor.constraint(equalToConstant: ConnectorView.height).isActive = true
                leadingRef = connectorView
            }else {
                connectorView.topAnchor.constraint(equalTo: (topRef != nil) ? topRef!.bottomAnchor: container.topAnchor, constant: 0).isActive = true
                connectorView.leadingAnchor.constraint(equalTo: leadingRef!.trailingAnchor, constant: 0).isActive = true
                connectorView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.33).isActive = true
                connectorView.heightAnchor.constraint(equalToConstant: ConnectorView.height).isActive = true
                leadingRef = connectorView
            }
            
            setParams(for: connectorView, count: connectors[power], kW: power)
            
            
            count += 1
            index += 1
            index = index % 3
            
            if (index == 0 ) {topRef = connectorView}
        }
    }
    
    func setParams(for connectorView: ConnectorView, count: Int?, kW : Double){
        connectorView.countLabel.text = viewModel.countString(count: count)
        connectorView.valueLabel.text = viewModel.kWString(kW: kW)
    }
    
    func flushContainer()  {
        for v in container.subviews{
            v.removeFromSuperview()
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
