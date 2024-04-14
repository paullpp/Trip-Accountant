//
//  TripView.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import SwiftUI

struct TripView: View {
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    @State private var buyer: String = ""
    @State private var date: Date = Date()
    @State private var amount: String = ""
    @State private var location: String = ""
    @State private var showPopOver: Bool = false
    @Binding var trip: Trip
    let promptText: String = "select"
    @State private var showAlert: Bool = false
    @FocusState private var keyboardFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text(trip.destination)
                    .font(.system(size: 28))
                    .font(.custom("AmericanTypewriter", size: 22))
                    .fontWeight(.bold)
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
                            .focused($keyboardFocused)
                        DatePicker(
                            "Date of Transaction",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        TextField("Amount", text: $amount)
                            .focused($keyboardFocused)
                        Button {
                            keyboardFocused = false
                            if (buyer == "" || amount == "") {
                                showAlert = true
                            } else {
                                var trips: [Trip] = []
                                if let objects = UserDefaults.standard.value(forKey: "trips") as? Data {
                                    if let decoded = try? decoder.decode(Array.self, from: objects) as [Trip] {
                                        trips = decoded
                                     }
                                }
                                let transaction: Transaction = Transaction(buyer: buyer, amount: (amount as NSString).floatValue, location: location, date: date)
                                for (idx, element) in trips.enumerated() {
                                    if (trips[idx] == trip) {
                                        trips[idx].transactions.append(transaction)
                                        trip.transactions.append(transaction)
                                        trips[idx].total += (amount as NSString).floatValue
                                        trip.total += (amount as NSString).floatValue
                                    }
                                }
                                
                                
                                if let encoded = try? encoder.encode(trips){
                                    userDefaults.set(encoded, forKey: "trips")
                                }
                                buyer = ""
                                date = Date()
                                amount = ""
                                location = ""
                            }
                        } label: {
                            Text("Create Transaction")
                        }
                        .alert("Buyer and Amount are required fields", isPresented: $showAlert) {
                            Button("Ok", role: .cancel) { }
                        }
                    }
                    .frame(height: 300)
                }
                VStack {
                    Text("Total $\(trip.total, specifier: "%.2f")")
                    Button {
                        showPopOver = true
                    } label: {
                        Text("Calculate Splits")
                    }
                    .frame(width: geometry.size.width * 0.82)
                    .cornerRadius(15)
                    .padding(2)
                    .popover(isPresented: $showPopOver) {
                        SplitView(showPopOver: $showPopOver, trip: $trip)
                    }
                    List {
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
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    TripView(trip: .constant(Trip(members: ["paul, john"], destination: "tahoe", date: Date(), comment: "none", total: 0, transactions: [])))
}
