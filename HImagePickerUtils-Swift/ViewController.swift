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
    lazy var imagePicker = HImagePickerUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        image = UIImageView(frame: self.view.frame)
        image.contentMode = .scaleAspectFit
        self.view.addSubview(image)
        
        let center = self.view.center
        
        let btnPickPhoto = UIButton(type: UIButtonType.custom)
        btnPickPhoto.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        btnPickPhoto.setTitle("从相册中选", for: UIControlState.normal)
        btnPickPhoto.addTarget(self, action: #selector(ViewController.buttonAction(button:)), for: .touchUpInside)
        btnPickPhoto.center = CGPoint(x: center.x, y: center.y - 20)
        btnPickPhoto.tag = 110
        self.view.addSubview(btnPickPhoto)
        
        
        let btnTakePhoto = UIButton(type: UIButtonType.custom)
        btnTakePhoto.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
        btnTakePhoto.setTitle("拍一张", for: UIControlState.normal)
        btnTakePhoto.addTarget(self, action: #selector(ViewController.buttonAction(button:)), for: .touchUpInside)
        btnTakePhoto.center = CGPoint(x: center.x, y: center.y + 20)
        btnTakePhoto.tag = 112
        self.view.addSubview(btnTakePhoto)
    }
    
    func buttonAction(button:UIButton!){
        switch button.tag{
            case 110:
                imagePicker.choosePhoto(presentFrom: self, completion: { [unowned self] (image, status) in
                    if status == .success {
                        self.image.image = image
                    }else{
                        if status == .denied{
                            HImagePickerUtils.showTips(at: self,type: .choosePhoto)
                        }else{
                            let alert = UIAlertController(title: "提示", message: status.description(), preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                })
            case 112:
                imagePicker.takePhoto(presentFrom: self, completion: { [unowned self] (image, status) in
                    if status == .success {
                        self.image.image = image
                    }else{
                        if status == .denied{
                            HImagePickerUtils.showTips(at: self,type: .takePhoto)
                        }else{
                            let alert = UIAlertController(title: "提示", message: status.description(), preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                })
            default:
                break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

