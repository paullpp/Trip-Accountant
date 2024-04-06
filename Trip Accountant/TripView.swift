//
//  TripView.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import SwiftUI

struct TripView: View {
    @State private var buyer: String = ""
    @State private var date: Date = Date()
    @State private var amount: String = ""
    @State private var location: String = ""
    @Binding var trip: Trip
    
    var body: some View {
        VStack {
            Form {
                TextField("Who paid?", text: $buyer)
                TextField("Location", text: $location)
                DatePicker(
                    "Date of Transaction",
                    selection: $date,
                    displayedComponents: [.date]
                )
                TextField("Amount", text: $amount)
                Button {
                    let transaction: Transaction = Transaction(buyer: buyer, amount: (amount as NSString).floatValue, location: location, date: date)
                    trip.transactions.append(transaction)
                    trip.total += (amount as NSString).floatValue
                    buyer = ""
                    date = Date()
                    amount = ""
                    location = ""
                } label: {
                    Text("submit")
                }
            }
            Text("Total $\(trip.total, specifier: "%.2f")")
            Divider()
            ForEach(trip.transactions.indices, id: \.self) { index in
                VStack {
                    HStack {
                        Text(trip.transactions[index].buyer)
                        Text(" - ")
                        Text(trip.transactions[index].date, style: .date)
                    }
                    HStack {
                        Text("$\(trip.transactions[index].amount, specifier: "%.2f")")
                        Text(" - ")
                        Text(trip.transactions[index].location)
                    }
                    Divider()
                }
            }
        }
    }
}

#Preview {
    TripView(trip: .constant(Trip(members: ["paul, john"], destination: "tahoe", date: Date(), comment: "none", total: 0, transactions: [])))
}
