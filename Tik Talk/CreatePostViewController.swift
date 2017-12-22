//
//  SecondViewController.swift
//  Tik Talk
//
//  Created by Developer on 11/5/17.
//  Copyright © 2017 JwitApps. All rights reserved.
//

import MobileCoreServices
import UIKit

import Cartography
import UIDropDown

struct Media {
    var data: Data?
    var url: URL?
    var contentType: String
    var fileExtension: String
}

class CreatePostViewController: UIViewController, ValidatesPosts {

    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var imageView: UIImageView!

    var dropdown: UIDropDown?

    var media: Media?
    
    var selectedGroup: GroupReference?
    
    var model: Post { return post }
    var post: Post {
        return Post(body: textField.text, url: nil, creator: User.current, group: selectedGroup)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cloud.Groups.all(containing: User.current, success: { groups in
            let dropdown = UIDropDown()
            dropdown.placeholder = "Group"
            dropdown.options = groups.map { $0.name }
            dropdown.didSelect { option, index in
                self.selectedGroup = groups[index]
                _ = dropdown.resign()
            }
            self.view.addSubview(dropdown)
            
            constrain(dropdown, self.view) {
                $0.centerX == $1.centerX
                $0.centerY == $1.centerY * 1.5
                $0.width == $1.width / 2
                $0.height == 44
            }
        }, failure: {
            print("Error fetching user's groups: \($0)")
        })
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
        guard let post = validate() else { return }
        
        Cloud.Posts.create(post, with: media, progress: {
            print($0)
        }, success: {
            print("Posted!")
        }) {
            print("Post Error: \(String(describing: $0))")
            print("Upload Error: \(String(describing: $1))")
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

