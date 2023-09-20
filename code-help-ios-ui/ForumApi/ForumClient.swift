//
//  ForumClient.swift
//  ForumApi
//
//  Created by Martin Trajkovski on 1.9.23.
//

import Foundation
import OpenAPIURLSession
import OpenAPIRuntime

enum ForumClientError: Error {
    case CouldNotCreateCommunity
    case CouldNoUpdateCommunity
    case CouldNotDeleteCommunity
    case CommunityNotFound

    case CouldNotCreatePost
    case CouldNotUpdatePost
    case CouldNotDeletePost
    case PostNotFound
    case PostsNotFound
    case PostNotModified
    
    case CouldNotCreateComment
    case CouldNotUpdateComment
    case CouldNotDeleteComment
    case CommentNotFound
    case CommentNotModified
    
    case CouldNotCreateCategory

}

public struct ForumClient {

    private var middlewares: [ClientMiddleware] = []
    private var client: (any APIProtocol)? = nil
    
    public init(with middleware: [ClientMiddleware]) {
        self.middlewares.append(contentsOf: middleware)
    }
    
    init(with middleware: [ClientMiddleware], _ client: some APIProtocol) {
        self.middlewares.append(contentsOf: middleware)
        self.client = client
    }
    
    public func getAllCommunities() async -> [Components.Schemas.ShortCommunity] {
        do {
            let client = try createClient()
            let response = try await client.getAllCommunities(.init())
            
            switch response {
                case .ok(let okResponse):
                    switch okResponse.body {
                        case .json(let json):
                            return json.communities
                    }
                case .undocumented:
                    print(response)
                    return []
            }
            
        } catch {
            return []
        }
    }
    
    public func createCommunity(with name: String, description: String) async throws -> Components.Schemas.Community {
            let client = try createClient()
            let response = try await client.createCommunity(.init(body: .json(.init(name: name, description: description))))
            
            switch response {
                case .ok(let okResponse):
                    switch okResponse.body {
                        case .json(let json):
                            return json
                    }
                case .undocumented:
                    throw ForumClientError.CouldNotCreateCommunity
            }
    }

    public func getCommunity(for name: String) async throws -> Components.Schemas.Community {
        let client = try createClient()
        let response = try await client.getCommunityByUid(.init(path: .init(name: name)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw ForumClientError.CommunityNotFound
        }
    }
    
    public func updateCommunity(for name: String, with data: Components.Schemas.CommunityRequest) async throws -> Components.Schemas.Community {
        let client = try createClient()
        let response = try await client.updateCommunity(.init(path: .init(name: name), body: .json(data)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw ForumClientError.CouldNoUpdateCommunity
        }
    }
    
    public func deleteCommunity(for name: String, with data: Components.Schemas.CommunityRequest) async throws {
        let client = try createClient()
        let response = try await client.deleteCommunity(.init(path: .init(name: name)))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CouldNotDeleteCommunity
        }
    }
    
    public func joinCommunity(with name: String) async throws {
        let client = try createClient()
        let response = try await client.joinCommunity(.init(query: .init(community: name)))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CommunityNotFound
            case .badRequest:
                throw ForumClientError.CommunityNotFound
        }
    }
    
    public func leaveCommunity(with name: String) async throws {
        let client = try createClient()
        let response = try await client.leaveCommunity(.init(query: .init(community: name)))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CommunityNotFound
            case .badRequest:
                throw ForumClientError.CommunityNotFound
        }
    }
    
    public func getPosts(in community: String? = nil) async throws -> [Components.Schemas.ShortPost] {
            let client = try createClient()
            let response = try await client.getPosts(.init(query: .init(community: community)))
        
            switch response {
                case .ok(let okResponse):
                    switch okResponse.body {
                        case .json(let json):
                            return json.posts ?? []
                    }
                case .undocumented:
                    throw ForumClientError.PostsNotFound
            }
        
    }
    
    public func createPost(in community: String, from data: Components.Schemas.PostRequest) async throws -> Components.Schemas.Post {
        let client = try createClient()
        let response = try await client.createCommunityPost(.init(query: .init(community: community), body: .json(data)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw  ForumClientError.CouldNotCreatePost
        }
    }
    
    public func getPost(with uid: String) async throws -> Components.Schemas.Post {
        let client = try createClient()
        let response = try await client.getPost(.init(path: .init(uid: uid)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw ForumClientError.PostNotFound
        }
    }
    
    public func updatePost(for uid: String, with data: Components.Schemas.PostRequest) async throws -> Components.Schemas.Post {
        let client = try createClient()
        let response = try await client.updatePost(.init(path: .init(uid: uid), body: .json(data)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw ForumClientError.CouldNotUpdatePost
            case .notModified(_):
                throw ForumClientError.PostNotModified
            case .badRequest(_):
                throw ForumClientError.CouldNotUpdatePost
        }
    }
    
    public func deletePost(with uid: String) async throws {
        let client = try createClient()
        let response = try await client.deletePost(.init(path: .init(uid: uid)))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CouldNotDeletePost
            case .badRequest(_):
                throw ForumClientError.CouldNotDeletePost
        }
    }
    
    public func getComments(for postUid: String) async throws -> [Components.Schemas.Comment] {
        do {
            let client = try createClient()
            let response = try await client.getCommentsForPost(.init(query: .init(post: postUid)))
            
            switch response {
                case .ok(let okResponse):
                    switch okResponse.body {
                        case .json(let json):
                            return json.comments ?? []
                    }
                case .undocumented:
                    return []
            }
        } catch {
            return []
        }
    }

    public func createComment(on post: String, with data: Components.Schemas.CommentRequest) async throws -> Components.Schemas.Comment {
        let client = try createClient()
        let response = try await client.commentOnPost(.init(query: .init(post: post), body: .json(data)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw  ForumClientError.CouldNotCreateComment
            case .badRequest(_):
                throw ForumClientError.CouldNotCreateComment
        }
    }

    public func getCommentReplies(for comment: String) async throws -> [Components.Schemas.Comment] {
        let client = try createClient()
        let response = try await client.getCommentReplies(.init(path: .init(uid: comment)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json.comments ?? []
                }
            case .undocumented:
                throw  ForumClientError.PostNotFound
        }
    }
    
    public func replyTo(commentWith uid: String, with comment: Components.Schemas.CommentRequest) async throws -> Components.Schemas.Comment {
        let client = try createClient()
        let response = try await client.replyToComment(.init(path: .init(uid: uid), body: .json(comment)))

        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw  ForumClientError.CouldNotCreateComment
        }
    }
    
    public func updateComment(for uid: String, with data: Components.Schemas.CommentRequest) async throws -> Components.Schemas.Comment {
        let client = try createClient()
        let response = try await client.updateComment(.init(path: .init(uid: uid), body: .json(data)))
        
        switch response {
            case .ok(let okResponse):
                switch okResponse.body {
                    case .json(let json):
                        return json
                }
            case .undocumented:
                throw  ForumClientError.CouldNotUpdateComment
            case .notModified(_):
                throw ForumClientError.CommentNotModified
            case .badRequest(_):
                throw  ForumClientError.CouldNotUpdateComment
        }
    }

    public func deleteComment(with uid: String) async throws {
        let client = try createClient()
        let response = try await client.deleteComment(.init(path: .init(uid: uid)))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CouldNotDeleteComment
            case .badRequest(_):
                throw ForumClientError.CouldNotDeleteComment
        }
    }
    
    public func getAllCategories() async throws -> [Components.Schemas.Category] {
        do {
            let client = try createClient()
            let response = try await client.getAllCategories(.init())
            
            switch response {
                case .ok(let okResponse):
                    switch okResponse.body {
                        case .json(let json):
                            return json.categories
                    }
                case .undocumented:
                    return []
            }
        } catch {
            return []
        }
    }
    
    public func createCategory(with name: String) async throws {
        let client = try createClient()
        let response = try await client.createCategory(.init(body: .json(.init(name: name))))
        
        switch response {
            case .ok:
                return;
            case .undocumented:
                throw ForumClientError.CouldNotCreateCategory
        }
    }
    
    private func createClient() throws -> APIProtocol {
        if let client = client {
            return client
        }
        return Client(
            serverURL: try Servers.server3(),
            transport: URLSessionTransport(),
            middlewares: middlewares
        )
    }
}
