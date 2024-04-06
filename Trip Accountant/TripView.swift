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
    @State private var showPopOver: Bool = false
    @Binding var trip: Trip
    let promptText: String = "select"
    @State private var showAlert: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Form {
                        Picker("Who paid?", selection: $buyer) {
                            if (buyer == "") {
                                Text(promptText).tag(Optional<String>(nil))
                            }
                            ForEach(trip.members, id: \.self) {
                                Text($0)
                            }
                        }
                        TextField("Location", text: $location)
                        DatePicker(
                            "Date of Transaction",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        TextField("Amount", text: $amount)
                        Button {
                            if (buyer == "" || amount == "") {
                                showAlert = true
                            } else {
                                let transaction: Transaction = Transaction(buyer: buyer, amount: (amount as NSString).floatValue, location: location, date: date)
                                trip.transactions.append(transaction)
                                trip.total += (amount as NSString).floatValue
                                buyer = ""
                                date = Date()
                                amount = ""
                                location = ""
                            }
                        } label: {
                            Text("submit")
                        }
                        .alert("Buyer and Amount are required fields", isPresented: $showAlert) {
                            Button("Ok", role: .cancel) { }
                        }
                    }
                    VStack {
                        Text("Total $\(trip.total, specifier: "%.2f")")
                        Button {
                            showPopOver = true
                        } label: {
                            Text("Calculate Splits")
                        }
                    }
                    .frame(width: geometry.size.width * 0.82)
                    .padding()
                    .background(.white)
                    .cornerRadius(15)
                }
                .popover(isPresented: $showPopOver) {
                    SplitView(showPopOver: $showPopOver, trip: $trip)
                }
                Spacer()
                List {
                    VStack {
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
            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
        }
    }
}

#Preview {
    TripView(trip: .constant(Trip(members: ["paul, john"], destination: "tahoe", date: Date(), comment: "none", total: 0, transactions: [])))
}
