//
//  ForumClientStub.swift
//  ForumApi
//
//  Created by Martin Trajkovski on 3.9.23.
//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime


public class ForumClientStub {
    public static func create(_ middlewares: [ClientMiddleware]) -> ForumClient {
        .init(with: middlewares, MockClient())
    }
}

struct MockClient: APIProtocol {
    
    private var data = ForumDataStub()
    
    public init() {
    }
    
    public func getAllCommunities(_ input: Operations.getAllCommunities.Input) async throws -> Operations.getAllCommunities.Output {
        return .ok(.init(body: .json(
            .init(communities: data.communities.values.map { c in c.toShortResponse() }))))
    }
    
    public func createCommunity(_ input: Operations.createCommunity.Input) async throws -> Operations.createCommunity.Output {
        switch input.body {
            case .json(let json):
                let newCommunity: ForumDataStub.CommunityInternal = .init(name: json.name, description: json.description, category: [], image: nil)
                data.communities[newCommunity.name] = newCommunity
                data.communityPosts[newCommunity.name] = []
                return .ok(.init(body: .json(newCommunity.toResponse(data.communityPosts))))
        }
        
//        return .undocumented(statusCode: 400, .init())
    }
    
    public func getCommunityByUid(_ input: Operations.getCommunityByUid.Input) async throws -> Operations.getCommunityByUid.Output {
        if let community = data.communities[input.path.name] {
            print("fetching \(community) ")
            return .ok(.init(body: .json(community.toResponse(data.communityPosts))))
        }
        return .undocumented(statusCode: 404, .init())
    }
    
    public func updateCommunity(_ input: Operations.updateCommunity.Input) async throws -> Operations.updateCommunity.Output {
        .ok(.init(body: .json(data.communities.first!.value.toResponse(data.communityPosts))))
    }
    
    public func deleteCommunity(_ input: Operations.deleteCommunity.Input) async throws -> Operations.deleteCommunity.Output {
        data.communities.removeValue(forKey: input.path.name)
        return .ok(.init())
    }
    
    public func getCommunityModerators(_ input: Operations.getCommunityModerators.Input) async throws -> Operations.getCommunityModerators.Output {
        .ok(.init(body: .json(.init(users: []))))
    }
    
    public func Add_a_new_moderator_to_the_community(_ input: Operations.Add_a_new_moderator_to_the_community.Input) async throws -> Operations.Add_a_new_moderator_to_the_community.Output {
        .ok(.init())
    }
    
    public func removeModerator(_ input: Operations.removeModerator.Input) async throws -> Operations.removeModerator.Output {
        .ok(.init())
    }
    
    public func joinCommunity(_ input: Operations.joinCommunity.Input) async throws -> Operations.joinCommunity.Output {
        data.communities[input.query.community]?.joined = true
        
        return .ok(.init())
    }
    
    public func leaveCommunity(_ input: Operations.leaveCommunity.Input) async throws -> Operations.leaveCommunity.Output {
        data.communities[input.query.community]?.joined = false
        
        return .ok(.init())
    }
    
    public func getPosts(_ input: Operations.getPosts.Input) async throws -> Operations.getPosts.Output {
        return .ok(.init(body: .json(.init(posts: data.posts.values.compactMap { ps in ps } .compactMap { p in p.toShortResponse() } ))))
    }
    
    public func createCommunityPost(_ input: Operations.createCommunityPost.Input) async throws -> Operations.createCommunityPost.Output {
        switch input.body {
            case .json(let json):
                let createdPost: ForumDataStub.PostInternal = .init(name: json.title, content: json.title, username: "vangel", image: nil)
                data.communityPosts[input.query.community]?.append(createdPost)
                data.posts[createdPost.uid.uuidString] = createdPost
                data.postComments[createdPost.uid.uuidString] = [:]
                return .ok(.init(body: .json(createdPost.toResponse(data.postComments, data.commentReplies))))
        }
        
//        return .undocumented(statusCode: 400, .init())
    }
    
    public func getPost(_ input: Operations.getPost.Input) async throws -> Operations.getPost.Output {
        let post = data.posts[input.path.uid]?.toResponse(data.postComments, data.commentReplies)
        if let post = post {
            return .ok(.init(body: .json(post)))
        }
        return .undocumented(statusCode: 404, .init())
    }
    
    public func updatePost(_ input: Operations.updatePost.Input) async throws -> Operations.updatePost.Output {
        switch input.body {
            case .json(let json):
                data.posts[input.path.uid]?.name = json.title
                data.posts[input.path.uid]?.content = json.content
        }
        
        let post = data.posts[input.path.uid]?.toResponse(data.postComments, data.commentReplies)
        if let post = post {
            return .ok(.init(body: .json(post)))
        }
        return .undocumented(statusCode: 404, .init())
    }
    
    public func deletePost(_ input: Operations.deletePost.Input) async throws -> Operations.deletePost.Output {
        data.posts.removeValue(forKey: input.path.uid)
        return .ok(.init())
    }
    
    public func getCommentsForPost(_ input: Operations.getCommentsForPost.Input) async throws -> Operations.getCommentsForPost.Output {
        .ok(.init(body: .json(.init(comments: data.postComments[input.query.post]!.map { c in c.value } .map { c in c.toResponse(data.commentReplies[c.uid.uuidString] ?? [:]) } ))))
    }
    
    public func getCommentReplies(_ input: Operations.getCommentReplies.Input) async throws -> Operations.getCommentReplies.Output {
        .ok(.init(body: .json(.init(comments: data.commentReplies[input.path.uid]?.map { c in c.value } .map { r in r.toResponse(data.commentReplies[input.path.uid] ?? [:]) } ?? [] ))))
    }
    
    public func replyToComment(_ input: Operations.replyToComment.Input) async throws -> Operations.replyToComment.Output {
        switch input.body {
            case .json(let json):
                let comment = data.comments[input.path.uid]!
                let createdReply: ForumDataStub.CommentInternal = .init(content: json.content, username: "vangel", parent: comment.uid, post: nil)
                if data.commentReplies[input.path.uid] == nil {
                    data.commentReplies[input.path.uid] = [:]
                }
                
                data.commentReplies[input.path.uid]![createdReply.uid.uuidString] = createdReply
                data.comments[createdReply.uid.uuidString] = createdReply
                return .ok(.init(body: .json(createdReply.toResponse([:]))))
                
            case .none:
                return .undocumented(statusCode: 404, .init())
        }
        
    }
    
    public func updateComment(_ input: Operations.updateComment.Input) async throws -> Operations.updateComment.Output {
        switch input.body {
            case .json(let json):
                guard let comment = data.comments[input.path.uid] else { return .badRequest(.init()) }
                guard let commentPost = comment.post else { return .badRequest(.init()) }
                
                if let parentUid = comment.parent {
                    data.commentReplies[parentUid.uuidString]?[comment.uid.uuidString]?.content = json.content
                } else {
                    data.postComments[commentPost]?[comment.uid.uuidString]?.content = json.content
                }
                
                data.comments[input.path.uid]?.content = json.content
                
                if let comment = data.comments[input.path.uid]?.toResponse(data.commentReplies[input.path.uid] ?? [:]) {
                    return .ok(.init(body: .json(comment)))
                }
            case .none:
                return .badRequest(.init())
        }
        
        return .badRequest(.init())
    }
    
    public func deleteComment(_ input: Operations.deleteComment.Input) async throws -> Operations.deleteComment.Output {
        let removedComment = data.comments.removeValue(forKey: input.path.uid)
        if let parent = removedComment?.parent {
            data.commentReplies[parent.uuidString]?.removeValue(forKey: input.path.uid)
        }
        
        if let postUid = removedComment?.post {
            data.postComments[postUid]?.removeValue(forKey: input.path.uid)
        }
        
        return .ok(.init())
    }
    
    public func getAllCategories(_ input: Operations.getAllCategories.Input) async throws -> Operations.getAllCategories.Output {
        .ok(.init(body: .json(.init(categories: data.categories.map { c in c.toResponse() }))))
    }
    
    public func createCategory(_ input: Operations.createCategory.Input) async throws -> Operations.createCategory.Output {
        .ok(.init())
    }
    
    public func commentOnPost(_ input: Operations.commentOnPost.Input) async throws -> Operations.commentOnPost.Output {
        switch input.body {
            case .json(let json):
                let newComment: ForumDataStub.CommentInternal = .init(content: json.content, username: "vangel", parent: nil, post: input.query.post)
                if data.postComments[input.query.post] == nil {
                    data.postComments[input.query.post] = [:]
                }
                data.postComments[input.query.post]![newComment.uid.uuidString] = newComment
                data.comments[newComment.uid.uuidString] = newComment
                data.commentReplies[newComment.uid.uuidString] = [:]
                return .ok(.init(body: .json(newComment.toResponse([:]))))
        }
    }
}


class ForumDataStub {
    
    var categories: [CategoryInternal]
    var communities: [String: CommunityInternal]
    var posts: [String: PostInternal]
    var communityPosts: [String: [PostInternal]]
    var postComments: [String: [String:CommentInternal]]
    var commentReplies: [String: [String:CommentInternal]]
    var comments: [String: CommentInternal]
    
    init() {
        categories = Self.createCategories()
        communities = Self.createCommunities(categories).reduce([:]) { result, community in
            return result.merging([community.name: community]) { l, r in
                return r
            }
        }
        communityPosts = Self.createPosts(communities.map { c in c.value })
        posts = communityPosts.flatMap { p in  p.value }.reduce([:]) { result, post in
            result.merging([post.uid.uuidString: post]) { lp, rp in rp }
        }
        postComments = Self.createComments(posts.compactMap { p in p.value })
        comments = postComments.values.flatMap { p in p.values } .reduce([:]) { result, comment in
            result.merging([comment.uid.uuidString: comment ]) { lp, rp in rp }
        }
        let (replies, otherComments) = Self.createReplies(postComments.values.flatMap { c in c.values })
        commentReplies = replies
        comments.merge(Self.toCommentMap(otherComments)) { lp, rp in rp }
    }
    
    private static func createCommunities(_ categories: [CategoryInternal]) -> [CommunityInternal] {
        [
            .init(name: "Name", description: "Description", category: [categories[0], categories[1]], image: nil),
            .init(name: "Name1", description: "Description", category: [categories[1], categories[2]], image: nil),
            .init(name: "Name2", description: "Description", category: [categories[1], categories[2]], image: nil)
        ]
    }
    
    private static func createPosts(_ communities: [CommunityInternal]) -> [String: [PostInternal]] {
        [
            communities[0].name: [
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil)
            ],
            communities[1].name: [
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil)
            ],
            communities[2].name: [
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil),
                PostInternal(name: "First", content: "Desc", username: "vangel", image: nil)
            ],
        ]
    }
    
    private static func createComments(_ posts: [PostInternal]) -> [String: [String: CommentInternal]] {
        let comments: [CommentInternal] = [
            .init(content: "Comment1", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment2", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment3", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment4", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment5", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment6", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment7", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment8", username: "vangel", parent: nil, post: posts[0].uid.uuidString),
            .init(content: "Comment9", username: "vangel", parent: nil, post: posts[0].uid.uuidString)
        ]
        
        return [
            posts[0].uid.uuidString: comments.reduce([:]) { result, comment in
                result.merging([comment.uid.uuidString:comment]) { lc, rc in rc }
            }
        ]
    }
    
    private static func createReplies(_ comments: [CommentInternal]) -> ([String: [String:CommentInternal]], [CommentInternal]) {
        let comments1: [CommentInternal] = [
            .init(content: "Comment1", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment2", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment3", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment4", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment5", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment6", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment7", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment8", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment9", username: "vangel", parent: nil, post: comments[0].post),
        ]
        
        let comments2: [CommentInternal] = [
            .init(content: "Comment1", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment2", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment3", username: "vangel", parent: nil, post: comments[0].post),
        ]
        
        let comments3: [CommentInternal] = [
            .init(content: "Comment1", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment2", username: "vangel", parent: nil, post: comments[0].post),
            .init(content: "Comment3", username: "vangel", parent: nil, post: comments[0].post),
        ]
        
        return ([
            comments[0].uid.uuidString: comments1.reduce([:], {r, c in r.merging([c.uid.uuidString:c]) { lc,rc in rc } }),
            comments1[0].uid.uuidString: comments2.reduce([:], {r, c in r.merging([c.uid.uuidString:c]) { lc,rc in rc } }),
            comments2[0].uid.uuidString: comments3.reduce([:], {r, c in r.merging([c.uid.uuidString:c]) { lc,rc in rc } })
        ], comments1 + comments2 + comments3)
    }
    
    private static func createCategories() -> [CategoryInternal] {
        [
            CategoryInternal(name: "Tag1"),
            CategoryInternal(name: "Tag2"),
            CategoryInternal(name: "Tag3"),
            CategoryInternal(name: "Tag4"),
            CategoryInternal(name: "Tag5"),
        ]
    }
    
    private static func toCommentMap(_ comments: [CommentInternal]) -> [String: CommentInternal] {
        comments.reduce([:]) { result, comment in
            return result.merging([comment.uid.uuidString: comment]) { lp, rp in rp }
        }
    }
    
    struct CategoryInternal {
        let uid = UUID()
        let name: String
        
        func toResponse() -> Components.Schemas.Category {
            .init(uid: self.uid.uuidString, name: self.name)
        }
    }
    
    
    
    struct CommunityInternal {
        let name: String
        let description: String
        let category: [CategoryInternal]
        let image: String?
        var joined = false
        let created: Date = .now
        
        func toResponse(_ posts: [String: [PostInternal]]) -> Components.Schemas.Community {
            .init(
                value1: self.toShortResponse(),
                value2: .init(
                    admin: .init(username: "Admin"),
                    categories: [],
                    posts: posts[self.name]?.map { p in p.toShortResponse()} ?? [],
                    joined: self.joined,
                    moderators: [],
                    created: created
                )
            )
        }
        
        func toShortResponse() -> Components.Schemas.ShortCommunity {
            .init(name: self.name, description: self.description, image: image, categories: self.category.map { c in c.toResponse() })
        }
    }
    
    struct PostInternal {
        let uid = UUID()
        var name: String
        let created: Date = .now
        var content: String
        let username: String
        let image: String?
        
        func toResponse(_ comments: [String: [String: CommentInternal]], _ commentReplies: [String: [String: CommentInternal]]) -> Components.Schemas.Post {
            .init(
                value1: self.toShortResponse(),
                value2: .init(
                    content: self.content,
                    comments: comments[self.uid.uuidString]?.map { c in c.value } .map { c in c.toResponse(commentReplies[c.uid.uuidString] ?? [:]) } ?? [],
                    modified: created
                )
            )
        }
        
        
        func toShortResponse() -> Components.Schemas.ShortPost {
            .init(
                uid: self.uid.uuidString,
                title: self.name,
                created: self.created,
                user: .init(username: username)
            )
        }
        
        
    }
    
    struct CommentInternal {
        let uid = UUID()
        var content: String
        let username: String
        let parent: UUID?
        let post: String?
        let created: Date = .now
        let modified: Date = .now
        
        func toResponse(_ replies: [String: CommentInternal]) -> Components.Schemas.Comment {
            .init(
                uid: self.uid.uuidString,
                content: self.content,
                created: created,
                replies: .init(count: replies.count),
                modified: modified,
                user: .init(username: username)
            )
        }
    }
}

