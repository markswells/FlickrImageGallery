//
//  SlingPhotoDetail.swift
//  ImageGallery
//
//  Created by Mark Wells on 11/15/23.
//

import SwiftUI

struct FlickrImageDetailView: View {
    
    let photo: FlickrImage
    @State var imageSize = CGSize(width: 0, height: 0)
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: photo.url) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .onAppear(perform: {
                        let renderer = ImageRenderer(content: image)
                        imageSize = renderer.uiImage?.size ?? CGSize(width: 0, height: 0)
                    })
            } placeholder: {
                ProgressView()
            }
            .padding(.bottom, 10)
            Text("Full title: \(photo.title)")
                .font(.caption)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            Text("Published: \(DateFormatters.shared.flickrImageDateFormatter.string(from: photo.datePublished))")
                .font(.caption)
            Text("Original image size: \(String.init(describing: imageSize))")
                .font(.caption)
            Spacer()
            VStack(alignment: .leading, content: {
                Text("Flickr tags associated with this photo:")
                    .fontWeight(.bold)
                Text(photo.tags)
            })
            .font(.caption)
        }
        .padding()
        .navigationTitle(photo.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

