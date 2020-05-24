//
//  File.swift
//  
//
//  Created by Diogo Ribeiro on 24/05/2020.
//

import Foundation


extension String {
    
    mutating func formatDate(){
        let formatter4 = DateFormatter()
        formatter4.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter4.date(from: self) {
            formatter4.dateFormat = "dd, MMM yyyy HH:mm"
            print(self)
            self = formatter4.string(from: date)
            print(self)
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
}
