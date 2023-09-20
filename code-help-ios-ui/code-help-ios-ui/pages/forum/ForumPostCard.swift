//
//  ForumPostCard.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 30.8.23.
//

import SwiftUI

class ForumPostCardModel: Identifiable {
    let id: String
    let userName: String
    let userImage: String?
    let title: String
    let description: String
    let created: Date
    let modified: Date?
    let imageUrl: URL?
    
    init(id: String, userName: String, userImage: String? = nil, title: String, description: String, created: Date, modified: Date? = nil, imageUrl: URL? = nil) {
        self.id = id
        self.userName = userName
        self.userImage = userImage
        self.title = title
        self.description = description
        self.created = created
        self.modified = modified
        self.imageUrl = imageUrl
    }
}


struct ForumPostCard: View {
    let post: ForumPostCardModel
    
    let delete: (() -> Void)?
    let update: (() -> Void)?
    
    init(post: ForumPostCardModel, delete: (() -> Void)? = nil, update: (() -> Void)? = nil) {
        self.post = post
        self.delete = delete
        self.update = update
    }
    
    var body: some View {
        VStack {
            UserDetailsHeader(
                image: post.userImage,
                userName: post.userName,
                created: post.created,
                modified: post.modified,
                delete: delete, update: update
            )
            
            HStack {
                Text(post.title)
                    .multilineTextAlignment(.leading)
                    .bold()
                    .font(Font.system(size: 22))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 1)
            
            if let imageUrl = post.imageUrl {
                HStack {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        AnimatedImagePlaceholder()
                    }
                }
                .clipped()
            } else {
                HStack {
                    Text(post.description)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.top, 0)
            }
        }
        .background(.secondaryBackground)
        .cornerRadius(10)
    }
}



struct UserDetailsHeader: View {
    @State private var presentingConfirmDelete = false

    let image: String?
    let userName: String
    let created: Date
    let modified: Date?
    
    let delete: (() -> Void)?
    let update: (() -> Void)?
    
    init(image: String? = nil, userName: String, created: Date, modified: Date? = nil, delete: (() -> Void)? = nil, update: (() -> Void)? = nil) {
        self.image = image
        self.userName = userName
        self.created = created
        self.modified = modified
        self.delete = delete
        self.update = update
    }
    
    
    var body: some View {
        HStack {
            if let image = image {
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(.infinity)
                    .frame(width: 36, height: 36)
                
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(.infinity)
                    .frame(maxHeight: 48)
            }
            VStack(alignment: .leading) {
                Text(userName)
                    .bold()
                    .multilineTextAlignment(.leading)
                Text("\(created.timeAgo()) ago")
                    .font(Font.system(.caption))
                    .multilineTextAlignment(.leading)
            }
            .multilineTextAlignment(.leading)
            Spacer()
            
            if let update = update {
                Button {
                    update()
                } label: {
                    Image(systemName: "pencil")
                }
            }
            
            if let delete = delete {
                Button(role: .destructive) {
                    presentingConfirmDelete.toggle()
                } label: {
                    Image(systemName: "trash")
                }
                .confirmationDialog("Delete?", isPresented: $presentingConfirmDelete) {
                    Button(role: .destructive) {
                        delete()
                        presentingConfirmDelete.toggle()
                    } label: {
                        Text("Delete")
                    }
                } message: {
                    Text("This action cannot be undone")
                }
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .padding(.bottom, 10)
    }
}

struct ForumPostCard_Previews: PreviewProvider {
    static var previews: some View {
        ForumPostCard(
            post: .init(
                id: UUID().uuidString,
                userName: "userName",
                title: "Title",
                description: "Lorem ipsum dolor sit amet consectetur. Mauris convallis velit adipiscing proin nibh nunc.",
                created: .now,
                modified: .now,
                imageUrl: URL(string: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg")
            )
        )
        ForumPostCard(
            post: .init(
                id: UUID().uuidString,
                userName: "userName",
                title: "Title",
                description: "Lorem ipsum dolor sit amet consectetur. Mauris convallis velit adipiscing proin nibh nunc.",
                created: .now,
                modified: .now
            )
        )
    }
}
