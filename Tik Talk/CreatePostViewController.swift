//
//  SecondViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import MobileCoreServices
import UIKit

import Firebase
import FirebaseStorage

struct Media {
    var data: Data?
    var url: URL?
    var contentType: String
    var fileExtension: String
}

class CreatePostViewController: UIViewController {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    var media: Media?
    
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
        picker.mediaTypes = [kUTTypeImage, kUTTypeMovie] as [String]
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

        let post = Post(id: Database.Posts.newModel().id,
                      body: self.textField.text,
                       url: nil,
                 creatorID: userID)
        
        Database.Posts.create(post, with: media, progress: { progress in
            print(progress)
        }, success: {
            
        }) { postError, uploadError in
            
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        media = nil

        picker.dismiss(animated: true, completion: nil)
        
        guard let mediaType = info[UIImagePickerControllerMediaType] as? String else { return }
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            attach(image: image)
            imageView.image = image
            return
        }
        
        if mediaType == kUTTypeMovie as String {
            guard let url = info[UIImagePickerControllerMediaURL] as? URL else { return }
            attach(video: url)
            return
        }
    }
    
    func attach(image: UIImage) {
        media = Media(data: UIImageJPEGRepresentation(image, 0.7),
                       url: nil,
               contentType: "image/jpeg",
             fileExtension: "")
    }
    
    func attach(video url: URL) {
        media = Media(data: nil,
                       url: url,
               contentType: "video/" + url.pathExtension.lowercased(),
             fileExtension: "." + url.pathExtension.lowercased())
    }
}

