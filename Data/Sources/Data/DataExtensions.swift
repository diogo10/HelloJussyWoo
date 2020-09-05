//
//  File.swift
//  
//
//  Created by Diogo Ribeiro on 24/05/2020.
//

import Foundation

public extension Double {
    public func format() -> String {
        return String(format: "%.2f", self)
    }
}

extension Array {
    public func chunks(_ size: Int) -> [[Element]] {
        stride(from: 0, to: self.count, by: size).map { ($0 ..< Swift.min($0 + size, self.count)).map { self[$0] } }
    }
    
    public var toPrint: String  {
        var str = ""
        for element in self {
            str += "\(element) "
        }
        return str
    }
}


extension String {
    
    mutating func formatDate(){
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter4.date(from: self) {
            formatter4.dateFormat = "dd, MMM yyyy HH:mm"
            self = formatter4.string(from: date)
        }
    }
    
    mutating func appedingEuro() {
        self = self + " €"
    }
}


public extension OrderData {
    
    func prettifyItems() -> String {
        var values = ""
        self.items.forEach { (prod) in
            values.append("*")
            values.append(" ")
            values.append(prod.quantity.description)
            values.append(" ")
            values.append(prod.name)
            values.append("\n")
        }
        
        return values
    }
    
    func getColor() -> String {
        let typeValue = OrderStatus.init(rawValue: self.status)
        
        switch typeValue {
        case .PROCESSING:
            return "#cddc39"
        case .COMPLETED:
            return "#4caf50"
        case .ONHOLD:
            return "#42a5f5"
        case .CANCELED:
            return "#e57373"
        default:
            return "#4dd0e1"
        }
    }
}
