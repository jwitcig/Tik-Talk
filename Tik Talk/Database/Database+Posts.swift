//
//  Database+Posts.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Database {
    class Posts {
        typealias ModelType = Post
        typealias PostReference = ModelReference

        static func newModel() -> PostReference {
            return Firestore.posts.document()
        }
        
        static func create(_ post: Post, with media: Media? = nil,
                           progress: ((Float)->Void)? = nil,
                           success: (()->Void)? = nil,
                           failure: ((Error?, Error?)->Void)? = nil) {
            // failure(post error, upload error)
            
            let document = Firestore.posts.document(post.id)
            
            let savePost: (String?)->Void = { mediaURL in
                document.setData(post.dictionary) {
                    guard $0 == nil else {
                        failure?($0, nil)
                        return
                    }
                    success?()
                }
            }
            
            guard let media = media else {
                savePost(nil)
                return
            }
            
            let meta = StorageMetadata()
            meta.contentType = media.contentType
            
            let ref = Storage.post(withID: post.id + media.fileExtension)
            
            var uploadTask: StorageUploadTask?
            if let data = media.data {
                uploadTask = ref.putData(data, metadata: meta)
            } else if let url = media.url {
                uploadTask = ref.putFile(from: url, metadata: meta)
            }
            
            uploadTask?.observe(.progress) {
                guard let fractionCompleted = $0.progress?.fractionCompleted else {  return }
                progress?(Float(fractionCompleted))
            }
            
            uploadTask?.observe(.success) {
                savePost($0.metadata?.downloadURL()?.absoluteString)
            }
            
            uploadTask?.observe(.failure) {
                failure?(nil, $0.error!)
            }
        }
        
        static func live(success: @escaping ([Post])->(), failure: @escaping (Error?)->()) {
            let present = Date().timeIntervalSince1970
            Firestore.posts.whereField("votes.takeDownTime", isGreaterThan: present).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Post.build(from: snapshot))
            }
        }
        
        static func all(for user: User, success: @escaping ([Post])->(), failure: @escaping (Error)->()) {
            Firestore.posts.whereField("creatorID", isEqualTo: user.id).getDocuments {
                guard let snapshot = $0 else {
                    failure($1!)
                    return
                }
                success(Post.build(from: snapshot))
            }
        }
    }
}
