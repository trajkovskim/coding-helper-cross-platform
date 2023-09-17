//
//  Comment.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 3.9.23.
//

import SwiftUI
import ForumApi
import Authentication

struct PostComment: Identifiable {
    let id: String
    let userName: String
    let userImage: String?
    let content: String
    let created: Date
    let replies: [Components.Schemas.Comment]
    let replyCount: Int
}

struct Comment: View, Equatable {
    
    typealias ReplyAction = (_ comment: PostComment) -> Void
    typealias EditAction = (_ comment: PostComment) -> Void
    typealias Action = () -> Void
    
    @EnvironmentObject private var authenticationService: AuthenticationService
    @EnvironmentObject private var webClient: ClientContainer
    
    @State private var deleteTask: Task<Void, Never>? = nil
    @State private var showReplies: Bool? = nil
    @State private var hideContent: Bool = false
    
    private let maxLevel: Int
    private let level: Int
    
    let comment: PostComment
    let onReply: ReplyAction?
    let onEdit: EditAction?
    let onDelete: Action?
    
    init(with comment: PostComment, nest maxLevel: Int, onReply: ReplyAction?, onEdit: EditAction?, onDelete: Action?) {
        self.comment = comment
        self.maxLevel = maxLevel
        self.level = maxLevel
        self.onReply = onReply
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    
    init(with comment: PostComment, level: Int, nest maxLevel: Int, onReply: ReplyAction?, onEdit: EditAction?, onDelete: Action?) {
        self.comment = comment
        self.level = level
        self.maxLevel = maxLevel
        self.onReply = onReply
        self.onEdit = onEdit
        self.onDelete = onDelete
    }
    
    func getDeleteComment(commentId: String, after postAction: (() -> Void)?) -> Action? {
        if !authenticationService.state.isAuthorized {
            return nil
        }
        
        return {
            deleteTask?.cancel()
            Task.detached {
                do {
                    let _ = try await webClient.forumClient.deleteComment(with: commentId)
                    postAction?()
                } catch {
                    print(error)
                }
                
                await deleteTask?.cancel()
            }
        }
    }
    
    var body: some View {
        VStack {
            UserDetailsHeader(
                image: comment.userImage,
                userName: comment.userName,
                created: comment.created,
                delete: getDeleteComment(commentId: comment.id, after: onDelete)
            )
            .frame(height: 52)
            .padding(hideContent ? .bottom : .init())
            
            if !hideContent {
                HStack {
                    Text(comment.content)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.top, 0)
                
                HStack {
                    Spacer()
                    
                    if let username = authenticationService.tokenState?.username, username == comment.userName {
                        Divider()
                        Button {
                            onEdit?(comment)
                        } label: {
                            Image(systemName: "pencil")
                        }
                        .disabled(!authenticationService.state.isAuthorized)
                    }

                    
                    Divider()
                    
                    Button {
                        onReply?(comment)
                    } label: {
                        Image(systemName: "arrow.turn.up.left")
                        Text("Reply")
                    }
                    .disabled(!authenticationService.state.isAuthorized)

                    Divider()
                    
                    Button {
                        if showReplies != nil {
                            showReplies?.toggle()
                        } else {
                            showReplies = level > 0 ? false : true
                        }
                    } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                        Text(comment.replyCount.description)
                    }

                    Divider()
                }
                .frame(height: 24)
                .padding(.horizontal)
                .padding(.bottom)
            }
            
        }
        .onTapGesture {
            hideContent.toggle()
            showReplies = !hideContent
        }
        .contentShape(Rectangle())
        .background(.secondaryBackground)
        .cornerRadius(10)
        .onDisappear {
            deleteTask?.cancel()
        }
        
        
        if comment.replyCount > 0 && ((level > 0 && showReplies == nil) || (showReplies != nil && showReplies!)) {
            CommentReplies(maxLevel: maxLevel, level: level, commentId: comment.id, onReply: onReply, onEdit: onEdit, onDelete: onDelete)
        }
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.comment.id == rhs.comment.id &&
        lhs.comment.content == rhs.comment.content &&
        lhs.comment.replyCount == rhs.comment.replyCount 
    }
}
struct Comment_Previews: PreviewProvider {
    static var previews: some View {
        AttachStubEnvironmentObjects {
            NavigationStack {
                ForumView()
            }
        }
    }
}
