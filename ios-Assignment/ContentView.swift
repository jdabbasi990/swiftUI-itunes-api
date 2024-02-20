//
//  ContentView.swift
//  ios-Assignment
//
//  Created by Jawwad Abbasi on 2024-02-19.
//

import SwiftUI

struct Track: Codable{
    var trackID: Int
    var trackName: String
    var collectionName: String
}

struct Album: Codable {
    var collectionType: String
    var artworkUrl100: String
    var collectionName: String
}

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
