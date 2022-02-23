//
//  ContentView.swift
//  Quotes
//
//  Created by Jacobo de Juan Millon on 2022-02-22.
//

import SwiftUI

struct ContentView: View {
    // MARK: Stored properties
    @State var currentQuote: Quote = Quote(quoteText: "",
                                           quoteAuthor: "")
    @State var favourites: [Quote] = []
    @State var currenQuoteAddedToFavourites = false
    // MARK: Computed properties
    var body: some View {
        VStack {
            VStack{
                Text(currentQuote.quoteText)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                HStack {
                    Spacer()
                    Text("-")
                    Text(currentQuote.quoteAuthor)
                        .font(.body)
                        .italic()
                        .minimumScaleFactor(0.5)
                }
                .padding(10)
            }
            .overlay(
                Rectangle()
                    .stroke(Color.primary, lineWidth: 4)
            )
            .padding(10)
            Image(systemName: "heart.circle")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(currenQuoteAddedToFavourites ? .red : .secondary)
                .onTapGesture {
                    if !currenQuoteAddedToFavourites {
                        favourites.append(currentQuote)
                        currenQuoteAddedToFavourites = true;
                    }
                }
            Button(action: {
                Task {
                    await loadNewQuote()
                }
            }, label: {
                Text("Another one!")
            })
                .buttonStyle(.bordered)
            HStack {
                Text("Favourites")
                    .bold()
                Spacer()
            }
            List(favourites, id: \.self) { currentQuote in
                VStack{
                    Text(currentQuote.quoteText)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                    HStack {
                        Spacer()
                        Text("-")
                        Text(currentQuote.quoteAuthor)
                            .italic()
                    }
                }
            }
            Spacer()
            
        }
        // When the app opens, get a new joke from the web service
        .task {
            await loadNewQuote()
        }
        .navigationTitle("Quotes")
        .padding()
    }
    func loadNewQuote() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://api.forismatic.com/api/1.0/?method=getQuote&key=457653&format=json&lang=en")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new joke
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentQuote"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentQuote = try JSONDecoder().decode(Quote.self, from: data)
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
