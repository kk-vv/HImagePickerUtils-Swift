//
//  HImagePickerUtils.swift
//  HSwiftTemp
//
//  Created by JuanFelix on 10/28/15.
//  Copyright © 2015 SKKJ-JuanFelix. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import MobileCoreServices

enum HTakeStatus{
    case Success, Canceled, CameraDisable, PhotoLibDisable, NotImage
}

enum HPhotoType{
    case TakePhoto, ChoosePhoto
}

typealias takeEndAction = (UIImage?,HTakeStatus,String?) -> Void

/// HImagePickerUtils
class HImagePickerUtils: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var pickPhotoEnd: takeEndAction?
    
    func takePhoto(rootVC:UIViewController) {
        if self.isCameraAvailable() && self.doesCameraSupportTakingPhotos(){
            let controller = UIImagePickerController()
            controller.view.backgroundColor = UIColor.white
            controller.sourceType = UIImagePickerControllerSourceType.camera
            controller.mediaTypes = [kUTTypeImage as String]
            controller.allowsEditing = true
            controller.delegate = self
            
            let sysVersion = (UIDevice.current.systemVersion as NSString).floatValue
            if sysVersion >= 8.0{
                controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            }
            
            if !self.isAuthorized(){
                if sysVersion >= 8.0 {
                    let alertVC = UIAlertController(title: nil, message: "您阻止了相机访问权限", preferredStyle: UIAlertControllerStyle.alert)
                    let openIt = UIAlertAction(title: "马上打开", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) -> Void in                        
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                    alertVC.addAction(openIt)
                    rootVC.present(alertVC, animated: true, completion: nil)
                }else{
                    let alertVC = UIAlertController(title: "提示", message: "请在 '系统设置|隐私|相机' 中开启相机访问权限", preferredStyle: UIAlertControllerStyle.alert)
                    rootVC.present(alertVC, animated: true, completion: nil)
                }
            }else{
                rootVC.present(controller, animated: true, completion: nil)
            }
        }else{
            if (self.pickPhotoEnd != nil){
                self.pickPhotoEnd?(nil,HTakeStatus.CameraDisable,"该设备不支持拍照")
            }
        }
    }
    
    func choosePhoto(rootVC:UIViewController){
        if self.isPhotoLibraryAvailable(){
            let controller = UIImagePickerController()
            controller.view.backgroundColor = UIColor.white
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
            var mediaTypes = [String]()
            if self.canUserPickPhotosFromPhotoLibrary(){
                mediaTypes.append(kUTTypeImage as String)
            }
            controller.allowsEditing = true
            controller.mediaTypes = mediaTypes
            if (UIDevice.current.systemVersion as NSString).floatValue >= 8.0{
                controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            }
            controller.delegate = self
            rootVC.present(controller, animated: true, completion: nil)
        }else{
            if self.pickPhotoEnd != nil{
                self.pickPhotoEnd?(nil,HTakeStatus.PhotoLibDisable,"该设备不支持资源选择")
            }
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let theImage : UIImage!
            if picker.allowsEditing{
                theImage = info[UIImagePickerControllerEditedImage] as! UIImage
            }else{
                theImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            }
            if self.pickPhotoEnd != nil {
                self.pickPhotoEnd?(theImage,HTakeStatus.Success,nil)
            }
        }else{
            if self.pickPhotoEnd != nil {
                self.pickPhotoEnd?(nil,HTakeStatus.NotImage,"获取的不是图片")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            if self.pickPhotoEnd != nil {
                self.pickPhotoEnd?(nil,HTakeStatus.Canceled,"取消选择")
            }
        }
    }
    
    //MARK: 用户是否授权
    func isAuthorized() -> Bool{
        let mediaType = AVMediaTypeVideo
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: mediaType)
        if authStatus == AVAuthorizationStatus.restricted ||
            authStatus == AVAuthorizationStatus.denied{
                return false
        }
        return true
    }
    
    //MARK: 相机功能是否可用
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    //MARK: 前置摄像头是否可用
    func isFrontCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.front)
    }
    
    //MARK: 后置摄像头是否可用
    func isRearCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.rear)
    }
    
    //MARK: 判断是否支持某种多媒体类型：拍照，视频
    func cameraSupportsMedia(paramMediaType:NSString, sourceType:UIImagePickerControllerSourceType) -> Bool {
        var result = false
        if paramMediaType.length == 0 {
            return false
        }
        let availableMediaTypes = NSArray(array: UIImagePickerController.availableMediaTypes(for: sourceType)!)
        availableMediaTypes.enumerateObjects({ (obj : Any, idx: Int, stop:UnsafeMutablePointer<ObjCBool>) in
            let type = obj as! NSString
            if type.isEqual(to: paramMediaType as String) {
                result = true
                stop[0] = true
            }

            
        })
        return result
    }
    
    //MARK: 检查摄像头是否支持录像
    func doesCameraSupportShootingVides() -> Bool{
        return self.cameraSupportsMedia(paramMediaType: kUTTypeMovie, sourceType: UIImagePickerControllerSourceType.camera)
    }
    //MARK: 检查摄像头是否支持拍照
    func doesCameraSupportTakingPhotos() -> Bool{
        return self.cameraSupportsMedia(paramMediaType: kUTTypeImage, sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    //MARK: 相册是否可用
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    //MARK: 是否可在相册中选择视频
    func canUserPickVideosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(paramMediaType: kUTTypeMovie, sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
    
    //MARK: 是否可在相册中选择图片
    func canUserPickPhotosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(paramMediaType: kUTTypeImage, sourceType: UIImagePickerControllerSourceType.photoLibrary)
    }
}
