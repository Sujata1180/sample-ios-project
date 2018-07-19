//
//  EditDataController.swift
//  sample-ios-project
//
//  Created by Rahmat Hidayat on 7/16/18.
//  Copyright © 2018 Rahmat Hidayat. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class EditDataController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imgAva: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnProcess: UIButton!
    
    let imgPicker = UIImagePickerController()
    var dataJson: JSON!
    var kind = 0 //1:Add, 2:Edit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        self.btnProcess.layer.cornerRadius = 4
        self.imgAva.layer.cornerRadius = self.imgAva.frame.height / 2
        self.imgAva.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imgAvaTapped(_:))))
        self.imgPicker.delegate = self
        
        if kind == 1 {
            self.btnProcess.setTitle("Add Member", for: .normal)
        }else{
            self.imgAva.loadImageUsingCacheWithUrlString(self.dataJson["avatar"].stringValue)
            self.txtFirstName.text = self.dataJson["first_name"].stringValue
            self.txtLastName.text = self.dataJson["last_name"].stringValue
            self.btnProcess.setTitle("Edit Member", for: .normal)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func imgAvaTapped(_ sender: UITapGestureRecognizer){
        let alert:UIAlertController=UIAlertController(title: "Select Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.modalPresentationStyle = .popover
        
        let cameraAction = UIAlertAction(title: "Kamera", style: UIAlertActionStyle.default) { UIAlertAction in
            self.cameraTapped()
        }
        let gallaryAction = UIAlertAction(title: "Galeri", style: UIAlertActionStyle.default) { UIAlertAction in
            self.libraryTapped()
        }
        let cancelAction = UIAlertAction(title: "Batal", style: UIAlertActionStyle.cancel) { UIAlertAction in }
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cameraTapped(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            self.imgPicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imgPicker.allowsEditing = false
            self.present(self.imgPicker, animated: true, completion: nil)
        } else {
            self.libraryTapped()
        }
    }
    
    func libraryTapped(){
        self.imgPicker.allowsEditing = false
        self.imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            pickedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            pickedImage = originalImage
        }
        self.imgAva.image = pickedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnProcessTapped(_ sender: UIButton) {
        self.btnProcess.loadingIndicator(true)
        if self.kind == 1 {
            self.addMember()
        }else{
            self.updateMember()
        }
    }
    
    func addMember(){
        let url = "\(Helper.baseUrl)users"
        let params = [
            "fisrt_name" : self.txtFirstName.text!,
            "last_name" : self.txtLastName.text!
            //"Image" Cuz Form-Data cant use for fake API, so we skip the upload image
        ]
        let heads = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method: .post, parameters: params, headers: heads)
            .responseJSON{response in
                if let _ = response.result.value {
                    if response.response!.statusCode == 201 {
                        self.showAlert("Member Added")
                    }
                }
        }
    }
    
    func updateMember(){
        let url = "\(Helper.baseUrl)users/\(self.dataJson["id"].intValue)"
        let params = [
            "fisrt_name" : self.txtFirstName.text!,
            "last_name" : self.txtLastName.text!
            //"Image" Cuz Form-Data cant use for fake API, so we skip the upload image
        ]
        let heads = [
            "Content-Type" : "application/x-www-form-urlencoded"
        ]
        Alamofire.request(url, method: .put, parameters: params, headers: heads)
            .responseJSON{response in
                if let _ = response.result.value {
                    if response.response!.statusCode == 200 {
                        self.showAlert("Member Updated")
                    }
                }
        }
    }
    
    func showAlert(_ msg: String){
        let alert = UIAlertController(title: "Success", message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.btnProcess.loadingIndicator(false)
            self.performSegue(withIdentifier: "backToListMembers", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
        
}
