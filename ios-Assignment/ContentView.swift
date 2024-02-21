//
//  ContentView.swift
//  ios-Assignment
//
//  Created by Jawwad Abbasi on 2024-02-19.
//

import SwiftUI
@propertyWrapper
struct IgnoreFailure<Value:Decodable>: Decodable{
    var wrappedValue: [Value] = []
    private struct _None: Decodable{}
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd{
            if let decoded = try?
                container.decode(Value.self){
                wrappedValue.append(decoded)
            } else {
                _ = try? container.decode(_None.self)
            }
        }
    }
}


// struct to get responses from URL
struct TrackResponse: Decodable {
    var resultCount: Int
    @IgnoreFailure
    var results: [Track]
}

struct AlbumResponse: Decodable {
    var resultCount: Int
    @IgnoreFailure
    var results: [Album]
}

// struct to get track and album
struct Track: Codable{
    var trackId: Int
    var trackName: String
    var collectionName: String
}

struct Album: Codable {
    var collectionType: String
    var artworkUrl100: String
    var collectionName: String
}

// Main content view
struct ContentView: View {
    @State private var tracks = [Track]()
    @State private var album = [Album]()
    @State private var albumArt = ""
    @State private var albumTitle = ""
    
    var body: some View {
        Text(albumTitle)
            .fontWeight(.bold)
            .font(.system(size: 20))
            .padding()
        AsyncImage(url: URL(string: albumArt), content: {image in
            image.resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .padding()
        }, placeholder: {
            Image(.greySquare)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(15)
                .padding()
        })
        List (tracks, id:\.trackId){ item in
            VStack(alignment: .leading) {
                Text(item.trackName)
                    .font(.headline)
                Text(item.collectionName)
            }
        }
        .task {
            await loadData()
        }
    }
    
    // function to load data from url
    func loadData() async {
        guard let url = URL(string: "https://itunes.apple.com/lookup?id=1710685602&entity=song") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResponse = try? JSONDecoder().decode(TrackResponse.self, from: data) {
                tracks = decodedResponse.results
            }
            if let decodedResponse = try? JSONDecoder().decode(AlbumResponse.self, from: data) {
                album = decodedResponse.results
                albumArt = (album[0].artworkUrl100).replacingOccurrences(of: "100x100bb.jpg", with: "800x800bb.jpg")
                albumTitle = album[0].collectionName
            }
        } catch {
            print("Invalid Data")
        }
    }
    
}

#Preview {
    ContentView()
}
