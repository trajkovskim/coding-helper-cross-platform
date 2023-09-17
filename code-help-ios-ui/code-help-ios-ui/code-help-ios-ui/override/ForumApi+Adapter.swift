//
//  ForumApi+Adapter.swift
//  code-help-ios-ui
//
//  Created by Martin Trajkovski on 3.9.23.
//

import Foundation
import ForumApi

extension Components.Schemas.Post {
    func toPostCardModel() -> ForumPostCardModel {
        let shortPost = self.value1
        let user = shortPost.user
        let additionalData = self.value2
        
        return .init(
            id: shortPost.uid,
            userName: user.username,
            title: shortPost.title,
            description: additionalData.content,
            created: shortPost.created,
            modified: additionalData.modified,
            imageUrl: nil
        )
    }
    
    func getComments() -> [PostComment] {
        self.value2.comments.map { comment in
            comment.toPostComment()
        }
    }
}

extension Components.Schemas.Comment {
    func toPostComment() -> PostComment {
        PostComment(
            id: self.uid,
            userName: self.user.username,
            userImage: nil,
            content: self.content,
            created: self.created,
            replies: self.replies?.replies ?? [],
            replyCount: self.replies?.count ?? 0
        )
    }
}

extension PostComment {
    func getReplies() -> [PostComment] {
        self.replies.map { comment in
            comment.toPostComment()
        }
    }
}

extension Components.Schemas.ShortPost {
    func toPostCardModel() -> ForumPostCardModel {
        return .init(
            id: self.uid,
            userName: self.user.username,
            title: self.title,
            description: "",
            created: self.created,
            modified: nil,
            imageUrl: nil
        )
    }
}

extension Components.Schemas.ShortCommunity {
    func toDiscoverTileItem() -> CommunityDiscoverTile {
        return .init(
            image: nil,
            name: self.name,
            tags: self.categories?.map { tag in tag.name } ?? []
        )
    }
}
