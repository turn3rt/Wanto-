//
//  EditProfileViewController.swift
//  Wanto
//
//  Created by Turner Thornberry on 1/1/18.
//  Copyright © 2018 Turner Thornberry. All rights reserved.
//

import UIKit
import Firebase


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    //MARK: Database refs
    let userID: String = (Auth.auth().currentUser?.uid)!
    let storageRef = Storage.storage().reference()

    
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var profileImage: UIImageViewX!
    

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        getProfilePicture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getProfilePicture()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        //MARK: keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        self.imagePicker.delegate = self
    }
    

    
    @IBAction func addPicClick(_ sender: UIButtonX) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        
        /*
         The sourceType property wants a value of the enum named        UIImagePickerControllerSourceType, which gives 3 options:
         
         UIImagePickerControllerSourceType.PhotoLibrary
         UIImagePickerControllerSourceType.Camera
         UIImagePickerControllerSourceType.SavedPhotosAlbum
         
         */
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneClick(_ sender: UIButtonX) {
        
        
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func tapOffKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0{
            self.view.frame.origin.y -= 216
        }
        // }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y += 216
        }
        // }
    }
    
    // MARK: - ImagePicker Delegate
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            profileImage.contentMode = .scaleAspectFit
//            profileImage.image = pickedImage
//
//
//            let imageName = NSUUID().uuidString
//            let storageRef = Storage.storage().reference().child(userID).child("\(imageName).jpg")
//
//            if let profileImage = profileImage.image,let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
//
//                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
//
//                    if err != nil {
//                        print(err!)
//                        return
//                    }
//
//                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
//
//                        let values = ["name": name, "email": email, "profileImageUrl\(referenceNumber)": profileImageUrl]
//                        self.registerUserIntoDatabaseWithUID(uid: userID, values: values as [String : AnyObject])
//                    }
//                })
//            }
//
//
//        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImage.image = pickedImage
            var data = NSData()
            data = UIImageJPEGRepresentation(profileImage.image!, 0.8)! as NSData
            // set upload path
            let filePath = "Users/\(userID)/\("profilePic")" //sets filepath to unser id -> photo
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString //stores a URL for firebase to download later
                    //store downloadURL at database
                    Constants.refs.databaseUsers.child(self.userID).updateChildValues(["profilePic": downloadURL])
                }
                
            }
        }
        picker.dismiss(animated: true , completion: nil)
    }
    
        
    
    
    func getProfilePicture(){
        Constants.refs.databaseUsers.child(userID).observe(DataEventType.value, with: { (snapshot) in
            // check if user has photo
            if snapshot.hasChild("profilePic"){
                // set image locatin
                let filePath = "Users/\(self.userID)/\("profilePic")"
                // Assuming a < 10MB file, though mutable
                self.storageRef.child(filePath).getData(maxSize: 10*1024*1024, completion: { (data, error) in
                    
                    let userPhoto = UIImage(data: data!)
                    self.profileImage.image = userPhoto
                })
            }
        })
    }
//        func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
//            profileImage.image = image
//            dismiss(animated: true, completion: nil)
//
//            var data = NSData()
//            data = UIImageJPEGRepresentation(profileImage.image!, 0.8)! as NSData
//            // set upload path
//            let filePath = "\(userID)/\("userPhoto")"
//            let metaData = StorageMetadata()
//            metaData.contentType = "image/jpg"
//            self.storageRef.child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }else{
//                    //store downloadURL
//                    let downloadURL = metaData!.downloadURL()!.absoluteString
//                    //store downloadURL at database
//                    Constants.refs.databaseUsers.child(self.userID).updateChildValues(["userPhoto": downloadURL])
//                }
//
//            }
//        }

        
        
        /*
         
         Swift Dictionary named “info”.
         We have to unpack it from there with a key asking for what media information we want.
         We just want the image, so that is what we ask for.  For reference, the available options are:
         
         UIImagePickerControllerMediaType
         UIImagePickerControllerOriginalImage
         UIImagePickerControllerEditedImage
         UIImagePickerControllerCropRect
         UIImagePickerControllerMediaURL
         UIImagePickerControllerReferenceURL
         UIImagePickerControllerMediaMetadata
         
         */
//        dismiss(animated: true, completion: nil)
    
    
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        dismiss(animated: true, completion:nil)
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
