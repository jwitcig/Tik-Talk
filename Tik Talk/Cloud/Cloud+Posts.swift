//
//  Cloud+Posts.swift
//  Tik Talk
//
//  Created by Developer on 11/20/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import Foundation

import Firebase

extension Cloud {
    class Posts {        
        static func create(_ post: Post, with media: Media? = nil,
                           progress: ((Float)->Void)? = nil,
                           success: (Callback)? = nil,
                           failure: ((Error?, Error?)->Void)? = nil) {
            // failure(post error, upload error)
            
            let savePost: (String?)->Void = { mediaURL in
                Firestore.reference(for: post).setData(post) {
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
        
        static func live(success: @escaping ListCallback<Post>, failure: @escaping ErrorCallback) {
            Firestore.posts.whereField("votes.takeDownTime", isGreaterThan: Date())
                           .getDocuments(completion: callback(success, failure))
        }
        
        static func all(for user: UserReference, success: @escaping ListCallback<Post>, failure: @escaping ErrorCallback) {
            Firestore.posts.whereField("creatorID", isEqualTo: user.id)
                           .getDocuments(completion: callback(success, failure))
        }
    }
}
