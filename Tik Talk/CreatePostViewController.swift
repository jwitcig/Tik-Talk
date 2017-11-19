//
//  SecondViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import UIKit

import Firebase
import FirebaseStorage

class CreatePostViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var media: Data?
    
    var isFormValid: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showImagePicker(forType type: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func takePicturePressed(sender: Any) {
        showImagePicker(forType: .camera)
    }
    
    @IBAction func selectPicturePressed(sender: Any) {
        showImagePicker(forType: .photoLibrary)
    }
    
    @IBAction func submitPressed(sender: Any) {
        guard isFormValid else { return }
        guard let userID = User.currentUser?.id else { return }
        
        let postDoc = Firestore.posts.document()
        
        let savePost: (String?)->Void = { mediaUrl in
            let post = Post(id: postDoc.documentID,
                            body: self.textField.text,
                            url: mediaUrl,
                            timestamp: Date(),
                            creatorID: userID)
            
            let batch = postDoc.firestore.batch()
            batch.setData(post.dictionary, forDocument: postDoc)
            batch.commit {
                guard $0 == nil else {
                    print("Error: \($0!)")
                    return
                }
            }
        }
        
        guard let data = media else {
            savePost(nil)
            return
        }
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        Storage.post(withID: postDoc.documentID).putData(data, metadata: meta, completion: { metadata, error in
    
            guard error == nil else {
                self.view.backgroundColor = .red
                return
            }
            savePost(nil)
            self.view.backgroundColor = .green
        })
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        media = UIImageJPEGRepresentation(image, 0.7)
        
        imageView.image = image
    }
}

