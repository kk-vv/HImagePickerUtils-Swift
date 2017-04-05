//
//  ViewController.swift
//  HImagePickerUtils-Swift
//
//  Created by JuanFelix on 10/30/15.
//  Copyright © 2015 SKKJ-JuanFelix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var image:UIImageView!
    /// HImagePickerUtils 对象不能为临时变量，不然UIImagePickerController代理方法不会执行
    var imagePicker: HImagePickerUtils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image = UIImageView(frame: self.view.frame)
        image.contentMode = .scaleAspectFit
        self.view.addSubview(image)
        
        weak var weakSelf = self
        imagePicker = HImagePickerUtils()
        
        imagePicker.pickPhotoEnd = {image,status,errorMsg in
            if status == HTakeStatus.Success {
                self.image.image = image
            }else{
                let alert = UIAlertController(title: "Info", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                weakSelf?.present(alert, animated: true, completion: nil)
            }
        }
        
        let center = self.view.center
        
        let btnPickPhoto = UIButton(type: UIButtonType.custom)
        btnPickPhoto.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        btnPickPhoto.backgroundColor = UIColor.purple
        btnPickPhoto.layer.cornerRadius = 5.0
        btnPickPhoto.setTitle("从相册中选", for: UIControlState.normal)
        btnPickPhoto.addTarget(self, action: #selector(ViewController.buttonAction(button:)), for: .touchUpInside)
        btnPickPhoto.center = CGPoint(x: center.x, y: center.y - 20)
        btnPickPhoto.tag = 110
        self.view.addSubview(btnPickPhoto)
        
        
        let btnTakePhoto = UIButton(type: UIButtonType.custom)
        btnTakePhoto.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        btnTakePhoto.backgroundColor = UIColor.purple
        btnTakePhoto.layer.cornerRadius = 5.0
        btnTakePhoto.setTitle("拍一张", for: UIControlState.normal)
        btnTakePhoto.addTarget(self, action: #selector(ViewController.buttonAction(button:)), for: .touchUpInside)
        btnTakePhoto.center = CGPoint(x: center.x, y: center.y + 20)
        btnTakePhoto.tag = 112
        self.view.addSubview(btnTakePhoto)
    }
    
    func buttonAction(button:UIButton!){
        switch button.tag{
        case 110:
            imagePicker.choosePhoto(rootVC: self)
        case 112:
            imagePicker.takePhoto(rootVC: self)
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

