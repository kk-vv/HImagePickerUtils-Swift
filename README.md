# Swift-照片选取和拍照

### Tips

---

- 支持照片选取和拍照
- 支持Closure回调

### 使用方法  
---

- 定义为类的成员变量

```
let imagePicker: HImagePickerUtils!
//不能为临时变量，临时变量销毁时，UIImagePickerController代理方法不会回调
```
- 对象初始化

```
imagePicker = HImagePickerUtils()
```

- 设置闭包回调
	
```
imagePicker.pickPhotoEnd = {(image:UIImage?,status:HTakeStatus,errorMsg:String?) -> Void in
    if status == HTakeStatus.Success {
        self.image.image = image
    }else{
		print(errorMsg)
    }
}
```
- 拍一张

```
imagePicker.takePhoto(self)//self is UIViewController
```
- 从相册取

```
imagePicker.choosePhoto(self)
```

### 效果图
---

>
![](https://github.com/iFallen/HImagePickerUtils-OC/raw/master/ScreenShot/1.png)
