//
//  Station.swift
//  uikit-virta-demo
//
//  Created by abbasi on 19.3.2021.
//

import Foundation

struct Connector: Decodable, Identifiable, Hashable {
    var id = Int.random(in: 1..<100000)
    let type: String
    let maxKw: Double
    private enum CodingKeys : String, CodingKey {
            case type, maxKw
    }
    
}
struct Evse: Decodable, Identifiable {
    let id: Int
    let groupName: String
    let connectors: [Connector]
    
}
class Station: Decodable {
    let id: Int
    let latitude: Double
    let longitude: Double
    let name: String
    let provider: String
    let evses: [Evse]?
    var distanceFromUser:Double = 0
    
    @Published var address: String = ""
    
    private enum CodingKeys : String, CodingKey {
            case id, latitude,longitude,name, provider,evses
    }
    
    var connectors: [Double : Int] {
        if let connectors = connectorDictionary {
            return connectors
        }
        return getConnectors()
    }
    
    private var connectorDictionary: [Double : Int]?
    func getConnectors() -> [Double : Int] {
        if let connectors = connectorDictionary {
            return connectors
        }
        
        var connectors = [Double : Int]()
        if let evses = evses {
            for evse in evses {
                for connector in evse.connectors {
                    if connector.maxKw > 0 {
                        if let count = connectors[connector.maxKw]{
                            connectors[connector.maxKw] = count+1
                        }else{
                            connectors[connector.maxKw] = 1
                        }
                        
                    }
                }
            }
        }
        connectorDictionary = connectors
        return connectors
    }
}
