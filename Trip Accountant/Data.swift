//
//  Data.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import Foundation
import SwiftUI

struct Trip {
    let members: [String]
    let destination: String
    let date: Date
    let comment: String
    var total: Float
    var transactions: [Transaction]
}

struct Transaction {
    let buyer: String
    let amount: Float
    let location: String
    let date: Date
}
