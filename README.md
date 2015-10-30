# HImagePickerUtils-Swift

![image](https://github.com/iFallen/HImagePickerUtils-Swift/raw/master/ScreenShots/screenShot1.png)

使用：

weak var weakSelf = self

imagePicker = HImagePickerUtils()// HImagePickerUtils 对象必须为全局变量，不然UIImagePickerController代理方法不会执行

imagePicker.pickPhotoEnd = {a,b,c in

    if b == HTakeStatus.Success {
    
        imageView.image = a
        
    }else{
    
        let alert = UIAlertController(title: "Info", message: c, preferredStyle: UIAlertControllerStyle.Alert)
        
        let action = UIAlertAction(title: "好的", style: UIAlertActionStyle.Default, handler: nil)
        
        alert.addAction(action)
        
        weakSelf?.presentViewController(alert, animated: true, completion: nil)
        
    }
    
}


从相册取:

imagePicker.choosePhoto(self)

拍一张:

imagePicker.takePhoto(self)
