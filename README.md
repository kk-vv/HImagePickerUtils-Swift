#Swift-照片选取和拍照

### Tips

---

- 支持照片选取和拍照
- 支持Block回调

### 使用方法  
---
- 定义全局常量
	
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
	imagePicker.pickPhotoEnd = {(a:UIImage?,b:HTakeStatus,c:String?) -> Void in
            if b == HTakeStatus.Success {
                self.image.image = a
            }else{
				print(c)
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
<br />
![](https://github.com/iFallen/HImagePickerUtils-Swift/raw/master/ScreenShots/screenShot1.png "效果图")
