//
//  Screen1.swift
//  ImageGallery
//
//  Created by Mark Wells on 11/15/23.
//

import SwiftUI
import Combine

struct FlickrSearchView: View {
    
    @ObservedObject var viewModel: FlickrSearchViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.images.count > 0 {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                            ForEach(viewModel.images) { image in
                                GeometryReader { proxy in
                                    NavigationLink(destination: FlickrImageDetailView(photo: image)) {
                                        ThumbnailView(size: proxy.size.width, photo: image)
                                    }
                                }
                                .cornerRadius(8.0)
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    }
                }
                else {
                    Text(viewModel.searchTerm.count > viewModel.minimumSearchTermCharacters ? "No matching items found" : "")
                        .padding()
                }
            }
            .navigationTitle("Flickr Search")
        }
        .searchable(text: $viewModel.searchTerm, prompt: "Enter search term (min \(viewModel.minimumSearchTermCharacters) chars)")
    }
}

#Preview {
    FlickrSearchView(viewModel: FlickrSearchViewModel())
}

class FlickrSearchViewModel: ObservableObject {
    
    @Published var images: [FlickrImage] = []
    @Published var searchTerm: String = ""
    
    let minimumSearchTermCharacters = 2
    
    private var debouncedSearchTerm: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    private var latestResponse: SearchResponse?
    
    init() {
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] term in
                if self?.debouncedSearchTerm != term {
                    self?.debouncedSearchTerm = term
                    self?.flickrSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    func flickrSearch() {
        images = []
        if debouncedSearchTerm.count >= minimumSearchTermCharacters {
            Task {
                if let response = await FlickrAPI.shared.search(debouncedSearchTerm) {
                    latestResponse = response
                    DispatchQueue.main.async { [weak self] in
                        self?.images.append(contentsOf: response.items)
                    }
                }
            }
        }
    }
}

struct ThumbnailView: View {
    
    let size: Double
    let photo: FlickrImage

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: photo.url) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size)
        }
    }
}
