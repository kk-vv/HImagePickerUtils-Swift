# Swift-照片选取和拍照

### Tips

---

- 支持照片选取和拍照
- 支持Closure回调

### 使用方法  
---

- 定义为类的成员变量

```
lazy var imagePicker = HImagePickerUtils()
//不能为临时变量，临时变量销毁时，UIImagePickerController代理方法不会回调
```

- 拍一张

```
imagePicker.takePhoto(presentFrom: self, completion: { [unowned self] (image, status) in
    if status == .success {
        self.image.image = image
    }else{
        if status == .denied{
            HImagePickerUtils.showTips(at: self,type: .takePhoto)
        }else{
            print(status.description())
        }
    }
})

```
- 从相册取

```
imagePicker.choosePhoto(presentFrom: self, completion: { [unowned self] (image, status) in
    if status == .success {
        self.image.image = image
    }else{
        if status == .denied{
            HImagePickerUtils.showTips(at: self,type: .choosePhoto)
        }else{
            print(status.description())
        }
        
    }
})
```

### 效果图
---

>
![](https://github.com/iFallen/HImagePickerUtils-Swift/raw/master/ScreenShots/1.png)
