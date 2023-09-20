//
//  CommentReplies.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 3.9.23.
//

import SwiftUI
import ForumApi

struct CommentReplies: View {
    typealias ReplyAction = (_ comment: PostComment) -> Void
    typealias EditAction = (_ comment: PostComment) -> Void
    typealias Action = () -> Void
    
    @State private var cachedReplies: [Components.Schemas.Comment]? = nil
    
    @EnvironmentObject private var webClient: ClientContainer
    
    private static let replyOffset = 10.0
    
    let maxLevel: Int
    let level: Int
    
    let commentId: String
    let onReply: ReplyAction?
    let onEdit: EditAction?
    let onDelete: Action?
    
    func calculateLevelPadding() -> CGFloat {
        CGFloat(maxLevel - (level - 1)) * Self.replyOffset
    }
    
    func cacheReplies() async throws -> [Components.Schemas.Comment] {
        if let cachedReplies = cachedReplies {
            return cachedReplies
        }
        
        cachedReplies = try await webClient.forumClient.getCommentReplies(for: commentId)
        return cachedReplies!
    }
    
    var body: some View {
        RequestDataFallback { replies, _ in
            ForEach(replies, id: \.uid) { reply in
                Comment(with: reply.toPostComment(), level: level - 1, nest: maxLevel, onReply: onReply, onEdit: onEdit, onDelete: onDelete)
                    .padding(.leading, calculateLevelPadding())
            }
        } timeout: {
            EmptyView()
        }
    suplier: {
        try await cacheReplies()
    }
    }
}

struct CommentReplies_Previews: PreviewProvider {
    static var previews: some View {
        AttachEnvironmentObjects {
            NavigationStack{
                ForumView()
            }
        }
    }
}
