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

/// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行
class HImagePickerUtils: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var pickPhotoEnd: takeEndAction?
    
    func takePhoto(rootVC:UIViewController) {
        if self.isCameraAvailable() && self.doesCameraSupportTakingPhotos(){
            let controller = UIImagePickerController()
            controller.view.backgroundColor = UIColor.whiteColor()
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            controller.mediaTypes = [kUTTypeImage as String]
            controller.allowsEditing = true
            controller.delegate = self
            
            let sysVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
            if sysVersion >= 8.0{
                controller.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            }
            
            if !self.isAuthorized(){
                if sysVersion >= 8.0 {
                    let alertVC = UIAlertController(title: nil, message: "您阻止了相机访问权限", preferredStyle: UIAlertControllerStyle.Alert)
                    let openIt = UIAlertAction(title: "马上打开", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction) -> Void in
                        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                    })
                    alertVC.addAction(openIt)
                    rootVC.presentViewController(alertVC, animated: true, completion: nil)
                }else{
                    let alertVC = UIAlertController(title: "提示", message: "请在 '系统设置|隐私|相机|全城热麦' 中开启相机访问权限", preferredStyle: UIAlertControllerStyle.Alert)
                    rootVC.presentViewController(alertVC, animated: true, completion: nil)
                }
            }else{
                rootVC.presentViewController(controller, animated: true, completion: nil)
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
            controller.view.backgroundColor = UIColor.whiteColor()
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            var mediaTypes = [String]()
            if self.canUserPickPhotosFromPhotoLibrary(){
                mediaTypes.append(kUTTypeImage as String)
            }
            controller.allowsEditing = true
            controller.mediaTypes = mediaTypes
            if (UIDevice.currentDevice().systemVersion as NSString).floatValue >= 8.0{
                controller.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            }
            controller.delegate = self
            rootVC.presentViewController(controller, animated: true, completion: nil)
        }else{
            if self.pickPhotoEnd != nil{
                self.pickPhotoEnd?(nil,HTakeStatus.PhotoLibDisable,"该设备不支持资源选择")
            }
        }
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        if mediaType.isEqualToString(kUTTypeImage as String) {
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
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true) { () -> Void in
            if self.pickPhotoEnd != nil {
                self.pickPhotoEnd?(nil,HTakeStatus.Canceled,"取消选择")
            }
        }
    }
    
    //MARK: 用户是否授权
    func isAuthorized() -> Bool{
        let mediaType = AVMediaTypeVideo
        let authStatus = AVCaptureDevice.authorizationStatusForMediaType(mediaType)
        if authStatus == AVAuthorizationStatus.Restricted ||
            authStatus == AVAuthorizationStatus.Denied{
                return false
        }
        return true
    }
    
    //MARK: 相机功能是否可用
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    //MARK: 前置摄像头是否可用
    func isFrontCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Front)
    }
    
    //MARK: 后置摄像头是否可用
    func isRearCameraAvailable() -> Bool{
        return UIImagePickerController.isCameraDeviceAvailable(UIImagePickerControllerCameraDevice.Rear)
    }
    
    //MARK: 判断是否支持某种多媒体类型：拍照，视频
    func cameraSupportsMedia(paramMediaType:NSString, sourceType:UIImagePickerControllerSourceType) -> Bool {
        var result = false
        if paramMediaType.length == 0 {
            return false
        }
        let availableMediaTypes = NSArray(array: UIImagePickerController.availableMediaTypesForSourceType(sourceType)!)
        availableMediaTypes.enumerateObjectsUsingBlock { (obj:AnyObject, idx:NSInteger, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            let type = obj as! NSString
            if type.isEqualToString(paramMediaType as String) {
                result = true
                stop.memory = true
            }
        }
        return result
    }
    
    //MARK: 检查摄像头是否支持录像
    func doesCameraSupportShootingVides() -> Bool{
        return self.cameraSupportsMedia(kUTTypeMovie, sourceType: UIImagePickerControllerSourceType.Camera)
    }
    //MARK: 检查摄像头是否支持拍照
    func doesCameraSupportTakingPhotos() -> Bool{
        return self.cameraSupportsMedia(kUTTypeImage, sourceType: UIImagePickerControllerSourceType.Camera)
    }
    
    //MARK: 相册是否可用
    func isPhotoLibraryAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    //MARK: 是否可在相册中选择视频
    func canUserPickVideosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(kUTTypeMovie, sourceType: UIImagePickerControllerSourceType.PhotoLibrary)
    }
    
    //MARK: 是否可在相册中选择图片
    func canUserPickPhotosFromPhotoLibrary() -> Bool {
        return self.cameraSupportsMedia(kUTTypeImage, sourceType: UIImagePickerControllerSourceType.PhotoLibrary)
    }
}