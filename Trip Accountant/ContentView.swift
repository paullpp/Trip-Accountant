//
//  ContentView.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    let userDefaults = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var guests: String = ""
    @State private var comment: String = ""
    @State private var trips: [Trip]
    @State private var showAlert: Bool = false
    @FocusState private var keyboardFocused: Bool
    
    init() {
        if let objects = UserDefaults.standard.value(forKey: "trips") as? Data {
            if let decoded = try? decoder.decode(Array.self, from: objects) as [Trip] {
                _trips = State(initialValue: decoded)
             } else {
                 _trips = State(initialValue: [])
             }
        } else {
            _trips = State(initialValue: [])
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Trip Accountant")
                    .font(.system(size: 30))
                    .font(.custom("AmericanTypewriter", size: 30))
                    .fontWeight(.bold)
                VStack {
                    Form {
                        TextField("Enter the destination", text: $destination)
                            .focused($keyboardFocused)
                        TextField("Enter the list of guests", text: $guests)
                            .focused($keyboardFocused)
                        DatePicker(
                            "Date of Trip",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        TextField("Enter a comment", text: $comment)
                            .focused($keyboardFocused)
                        Button {
                            keyboardFocused = false
                            if (destination == "" || guests == "") {
                                showAlert = true
                            } else {
                                let trip: Trip = Trip(members: guests.components(separatedBy: ", "), destination: destination, date: date, comment: comment, total: 0, transactions: [])
                                trips.append(trip)
                                if let encoded = try? encoder.encode(trips){
                                    userDefaults.set(encoded, forKey: "trips")
                                }
                                destination = ""
                                date = Date()
                                guests = ""
                                comment = ""
                            }
                        } label: {
                            Text("Create Trip")
                        }
                        .alert("Destination and Guests are required fields", isPresented: $showAlert) {
                            Button("Ok", role: .cancel) { }
                        }
                    }
                    .frame(height: 300)
                }
                if (trips.count >= 1) {
                    VStack {
                        Text("Trips")
                            .padding(0)
                            .font(.system(size: 22))
                            .font(.custom("AmericanTypewriter", size: 22))
                            .fontWeight(.bold)
                        List {
                            ForEach(trips.indices, id: \.self) { index in
                                NavigationLink(destination: TripView(trip: $trips[index])) {
                                    VStack {
                                        HStack {
                                            Text(trips[index].destination)
                                            Text(" - ")
                                            Text(trips[index].date, style: .date)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        Text(trips[index].members.joined(separator: ", "))
                                            .multilineTextAlignment(.leading)
                                            .padding([.top], 2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .onDelete(perform: { indexSet in
                                trips.remove(atOffsets: indexSet)
                                if let encoded = try? encoder.encode(trips){
                                    userDefaults.set(encoded, forKey: "trips")
                                }
                            })
                        }
                    }
                } else {
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
