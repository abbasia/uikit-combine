//
//  StationCellViewModel.swift
//  uikit-virta-demo
//
//  Created by abbasi on 20.3.2021.
//

import Foundation
struct StationCellViewModel {
    
    var station: Station?
    
    var name: String { return station?.name ?? "no name"}
    var address: String {return station?.address ?? ""}
    var distance: String { return "200 m"}
    
    func countString(count: Int?) -> String {
        if let count = count {
            return count > 0 ?  "x\(count)" : ""
        }
        return ""
    }
    
    func kWString(kW: Double) -> String {
        return "\(kW)"
    }
    
    func distanceFromUserString()->String {
        if let s = station {
            let distance = s.distanceFromUser 
            return distance < 1000 ?
                String(format:"%.0f", distance) + " m" :
                String(format:"%.1f", (distance)/1000) + " km"
            
            
        }
        return "-"
    }
    
}
