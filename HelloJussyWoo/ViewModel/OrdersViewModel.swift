//
//  OrdersViewModel.swift
//  HelloJussyWoo
//
//  Created by Diogo Ribeiro on 16/05/2020.
//  Copyright © 2020 Diogo Ribeiro. All rights reserved.
//

import Foundation
import Combine
import Data



class OrdersViewModel : ObservableObject{
    
    @Published var list = [OrderData]()
    @Published var isLoading: Bool = false
    
    init() {
        getAll()
    }
    
    func getAll() {
        isLoading = true
        repo.getOrders(){ values in
            self.isLoading = false
            self.list.removeAll()
            self.list.append(contentsOf: values)
        }
    }
    
    func getAll(status: OrderStatus) {
        isLoading = true
        let statusValue = status.rawValue
        
        repo.getOrders(status: statusValue){ values in
            self.isLoading = false
            self.list.removeAll()
            self.list.append(contentsOf: values)
        }
    }
    
    func changeStatus(status: OrderStatus, orderId: Int) {
        isLoading = true
        repo.changeStatus(orderId: orderId.description, newStatus: status) { (value) in
            print("changeStatus \(value)")
            self.getAll()
        }
    }
    
    
}



