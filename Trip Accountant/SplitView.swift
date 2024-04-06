//
//  SplitView.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import SwiftUI

private func getSplits(trip: Trip) -> [String: Float] {
    let split: Float = trip.total / Float(trip.members.count)
    var contributions: [String: Float] = [:]
    trip.transactions.forEach { item in
        if ((contributions[item.buyer]) == nil) {
            contributions[item.buyer] = 0
        }
        contributions[item.buyer]! += item.amount
    }
    trip.members.forEach { item in
        if ((contributions[item]) == nil) {
            contributions[item] = 0
        }
        contributions[item] = split - (contributions[item] ?? 0)
    }
    return contributions
}

struct SplitView: View {
    @Binding var showPopOver: Bool
    @Binding var trip: Trip
    
    var body: some View {
        VStack {
            List {
                ForEach(getSplits(trip: trip).sorted(by: >), id:\.key) { key, val in
                    Text("\(key) \(val < 0 ? "is owed" : "owes") $\(abs(val), specifier: "%.2f")")
                }
            }
            Button {
                showPopOver = false
            } label: {
                Text("Close")
            }
        }
    }
}

#Preview {
    SplitView(showPopOver: .constant(true), trip: .constant(Trip(members: ["paul, john"], destination: "tahoe", date: Date(), comment: "none", total: 0, transactions: [])))
}
