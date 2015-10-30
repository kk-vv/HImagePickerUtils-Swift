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
    var imagePicker: HImagePickerUtils!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        image = UIImageView(frame: self.view.frame)
        image.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(image)
        
        weak var weakSelf = self
        imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行
        imagePicker.pickPhotoEnd = {a,b,c in
            if b == HTakeStatus.Success {
                self.image.image = a
            }else{
                let alert = UIAlertController(title: "Info", message: c, preferredStyle: UIAlertControllerStyle.Alert)
                let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
                alert.addAction(action)
                weakSelf?.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        let center = self.view.center
        
        let btnPickPhoto = UIButton(type: UIButtonType.Custom)
        btnPickPhoto.frame = CGRectMake(0, 0, 120, 30)
        btnPickPhoto.backgroundColor = UIColor.purpleColor()
        btnPickPhoto.layer.cornerRadius = 5.0
        btnPickPhoto.setTitle("从相册中选", forState: UIControlState.Normal)
        btnPickPhoto.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        btnPickPhoto.center = CGPointMake(center.x, center.y - 20)
        btnPickPhoto.tag = 110
        self.view .addSubview(btnPickPhoto)
        
        
        let btnTakePhoto = UIButton(type: UIButtonType.Custom)
        btnTakePhoto.frame = CGRectMake(0, 0, 120, 30)
        btnTakePhoto.backgroundColor = UIColor.purpleColor()
        btnTakePhoto.layer.cornerRadius = 5.0
        btnTakePhoto.setTitle("拍一张", forState: UIControlState.Normal)
        btnTakePhoto.addTarget(self, action: "buttonAction:", forControlEvents: .TouchUpInside)
        btnTakePhoto.center = CGPointMake(center.x, center.y + 20)
        btnTakePhoto.tag = 112
        self.view .addSubview(btnTakePhoto)
    }
    
    func buttonAction(button:UIButton!){
        switch button.tag{
        case 110:
            imagePicker.choosePhoto(self)
        case 112:
            imagePicker.takePhoto(self)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

