//
//  ContentView.swift
//  Trip Accountant
//
//  Created by Paul Lipp on 4/6/24.
//

import SwiftUI

struct ContentView: View {
    @State private var destination: String = ""
    @State private var date: Date = Date()
    @State private var guests: String = ""
    @State private var comment: String = ""
    @State private var trips: [Trip] = []
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Trip Accountant")
                VStack {
                    Form {
                        TextField("Enter the destination", text: $destination)
                        TextField("Enter the list of guests", text: $guests)
                        DatePicker(
                            "Date of Trip",
                            selection: $date,
                            displayedComponents: [.date]
                        )
                        TextField("Enter a comment", text: $comment)
                        Button {
                            if (destination == "" || guests == "") {
                                showAlert = true
                            } else {
                                let trip: Trip = Trip(members: guests.components(separatedBy: ", "), destination: destination, date: date, comment: comment, total: 0, transactions: [])
                                trips.append(trip)
                                destination = ""
                                date = Date()
                                guests = ""
                                comment = ""
                            }
                        } label: {
                            Text("submit")
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
                            .font(.system(size: 32))
                            .font(.custom("AmericanTypewriter", size: 32))
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
                                        Text(trips[index].members.joined(separator: ", "))
                                            .multilineTextAlignment(.trailing)
                                        
                                    }
                                }
                            }
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
