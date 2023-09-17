//
//  ForumPostView.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 30.8.23.
//

import SwiftUI
import ForumApi
import Authentication


struct ForumPostView: View {
    @EnvironmentObject private var webClient: ClientContainer
 
    @State private var cachedPost: Components.Schemas.Post? = nil
    
    let postUid: String
    
    var body: some View {
        StyledNavigationBar {
            RequestDataFallback { post, refresh  in
                ForumPostScroll(post: post.toPostCardModel(), comments: post.getComments(), refresh: refresh)
            } suplier: {
                return try await webClient.forumClient.getPost(with: postUid)
            }
        }
    }
}

struct ForumPostScroll: View {
    typealias RefreshTrigger = () -> Void

    @EnvironmentObject private var webClient: ClientContainer

    @State private var show: Bool = false
    @State private var text: String = ""
    @State private var dialogType: CommentDialogType = .new
    @State private var editingComment: PostComment? = nil
    
    let post: ForumPostCardModel
    let comments: [PostComment]
    let refresh: RefreshTrigger

    func openDialog(for comment: PostComment?) {
        dialogType = comment == nil ? .new : .reply
        editingComment = comment
        show.toggle()
    }
    
    func openEditDialog(for comment: PostComment?) {
        openDialog(for: comment)
        dialogType = .edit
        text = comment?.content ?? ""
    }
    
    func closeDialog() {
        editingComment = nil
        text = ""
    }
    
    func handleDialogSubmit(for comment: PostComment?, with text: String, type: CommentDialogType) async -> Any? {
        do {
            switch type {
                case .new:
                    let _ = try await webClient.forumClient.createComment(on: post.id, with: .init(content: text))
                case .edit:
                    let _ = try await webClient.forumClient.updateComment(for: comment!.id, with: .init(content: text))
                case .reply:
                    let _ = try await webClient.forumClient.replyTo(commentWith: comment!.id, with: .init(content: text))
            }
            await MainActor.run {
                refresh()
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForumPostCard(post: post)
                
                Spacer(minLength: 20)
                
                LabelSeparator(label: "Comments", iconName: "plus") {
                    openDialog(for: nil)
                }
                
                Spacer(minLength: 20)
                
                ForEach(comments, id: \.id) { comment in
                    Comment(with: comment, nest: 3) { comment in
                        openDialog(for: comment)
                    } onEdit: { comment in
                        openEditDialog(for: comment)
                    } onDelete: {
                        refresh()
                    }
                    .equatable()
                }
                
            }
            .padding()
        }
        .refreshable {
            refresh()
        }
        .overlay {
            CommentModalDialog(
                show: $show,
                text: $text,
                type: $dialogType,
                comment: editingComment
            ) { text, comment, type in
                Task(priority: .background) {
                    let response = await handleDialogSubmit(for: comment, with: text, type: type)
                    closeDialog()
                }
            }
        }
    }
}

struct LabelSeparator: View {
    typealias Action = () -> Void

    @EnvironmentObject private var authenticationService: AuthenticationService
    
    let label: String
    let iconName: String
    let action: Action?
    
    var body: some View {
        VStack {
            HStack {
                Text(label)
                    .bold()
                    .multilineTextAlignment(.leading)
                Spacer()
                if let action = action {
                    Button {
                        action()
                    } label: {
                        Image(systemName: iconName)
                    }
                    .disabled(!authenticationService.state.isAuthorized)
                }
            }
            .padding()
        }
        .background(.secondaryBackground)
        .cornerRadius(10)
    }
}

struct ForumPostView_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationTitleView {
                ForumPostView(
                    postUid: "7d64eb34-d9d0-46f4-bd74-453f9d4c6781"
                )
            }
        }
    }
}
