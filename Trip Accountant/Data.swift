//
//  Data.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import Foundation
import SwiftUI

struct Trip: Codable, Hashable {
    let members: [String]
    let destination: String
    let date: Date
    let comment: String
    var total: Float
    var transactions: [Transaction]
    
    init(members: [String], destination: String, date: Date, comment: String, total: Float, transactions: [Transaction]) {
        self.members = members
        self.destination = destination
        self.date = date
        self.comment = comment
        self.total = total
        self.transactions = transactions
    }
    
    public static func ==(lh: Trip, rh: Trip) -> Bool{
        return
            lh.members == rh.members &&
            lh.destination == rh.destination &&
            lh.date == rh.date &&
            lh.comment == rh.comment &&
            lh.total == rh.total
    }
}

struct Transaction: Codable, Hashable {
    let buyer: String
    let amount: Float
    let location: String
    let date: Date
    
    init(buyer: String, amount: Float, location: String, date: Date) {
        self.buyer = buyer
        self.amount = amount
        self.location = location
        self.date = date
    }
}
