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
                            let trip: Trip = Trip(members: guests.components(separatedBy: ","), destination: destination, date: date, comment: comment, total: 0, transactions: [])
                            trips.append(trip)
                            destination = ""
                            date = Date()
                            guests = ""
                            comment = ""
                        } label: {
                            Text("submit")
                        }
                    }
                }
                VStack {
                    ForEach(trips.indices, id: \.self) { index in
                        NavigationLink(destination: TripView(trip: $trips[index])) {
                            VStack {
                                HStack {
                                    Text(trips[index].destination)
                                    Text(" - ")
                                    Text(trips[index].date, style: .date)
                                    Button {
                                        trips.remove(at: index)
                                    } label: {
                                        Text("🗑️")
                                    }
                                }
                                Text(trips[index].members.joined(separator: ", "))
                                   .multilineTextAlignment(.trailing)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
