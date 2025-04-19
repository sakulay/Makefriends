import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { router } from '@kit.ArkUI';
import { showBottomError, showBottomToast } from '../utils/toast';
import { upload } from '../api/uploadApi';
import { common } from '@kit.AbilityKit';
import { AuthModel } from '../viewmodel/AuthModel';
import { register } from '../api/authApi';
import { Loading } from './components/Loading';

class Auth{
  studentId: string;
  password: string;
  authInfo: string;

  constructor(studentId: string, password: string, authInfo: string) {
    this.studentId = studentId;
    this.password = password;
    this.authInfo = authInfo;
  }
}
@Entry
@Component
struct Register {
  @State message: string = 'Hello World';
  @State focusOn: number = 0;
  @State auth: AuthModel = new AuthModel('', '', '')
  @State loading: boolean = false;
  // @State auth: AuthModel = new AuthModel(
  //   '',
  //   '',
  //   'http://111.230.102.82:40061/i/2025/04/10/x41yrm-0.jpg',
  //   0,
  //   'http://111.230.102.82:40061/app/del.php?hash=RWxYMmJaOXJlbmRGWWZMc0MveTBmUE9ML25SQjE4RVB3TUk9'
  // );
  // @State uri: string = 'http://111.230.102.82:40061/i/2025/04/10/x41yrm-0.jpg';
  @State uri: string = '';
  @State studentIdError: string = '';
  @State confirm: string = '';
  @State passwordError: string = '';
  @State confirmError: string = '';
  async addPic() {
    try {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      // 设置图片类型为图片
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      // 设置最多可选择的图片数量为1
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker
        .select(PhotoSelectOptions)
        .then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
          console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
          if (PhotoSelectResult.photoUris.length > 0) {
            this.uri = PhotoSelectResult.photoUris[0]
          }
        }).catch((err: BusinessError) => {
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  // 方法：检查输入是否为数字
  private checkIfNumber(value: string): boolean {
    const regex = /^\d+$/;
    return regex.test(value);
  }
  @Builder
  studentId() {
    Stack({alignContent: Alignment.TopStart}) {
      // 学号
      TextInput({text: this.auth.studentId})
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .margin({top: 10, bottom: 10})
        .border({ width: 2, color: this.focusOn == 1? '#ff008bcb' : Color.Gray })
        .borderRadius(13)
        .showError(this.studentIdError)
        .onFocus(() => {
          this.focusOn = 1
        })
        .onChange((value: string) => {
          this.auth.studentId = value
          if(this.checkIfNumber(value)) {
            this.studentIdError = ''
          } else {
            this.studentIdError = '请输入正确的学号'
          }
        })
      Column() {
        Text("学号")
          .fontSize(15)
          .fontColor(this.focusOn == 1 ? '#ff008bcb' : Color.Gray)
      }
      .width(40)
      .height(20)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .offset({x: 15})
    }
  }

  @Builder
  password() {
    Stack({alignContent: Alignment.TopStart}) {
      // 密码
      Column() {
        TextInput()
          .width('90%')
          .height(50)
          .backgroundColor(Color.White)
          .margin({top: 10, bottom: 10})
          .border({ width: 2, color: this.focusOn == 2? '#ff008bcb' : Color.Gray })
          .borderRadius(13)
          .type(InputType.Password)
          .showPasswordIcon(true)
          .showError(this.passwordError)
          .onFocus(() => {
            this.focusOn = 2
          })
          .onChange((value: string)=>{
            this.auth.password = value
            if(this.confirm != '' && this.confirm != this.auth.password) {
              this.confirmError = '两次密码不一致'
              this.passwordError = '两次密码不一致'
            } else {
              this.confirmError = ''
              this.passwordError = ''
            }
          })
      }
      .alignItems(HorizontalAlign.End)
      Column() {
        Text("密码")
          .fontSize(15)
          .fontColor(this.focusOn == 2 ? '#ff008bcb' : Color.Gray)
      }
      .width(40)
      .height(20)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .offset({x: 15})
    }
  }
  @Builder
  valPassword() {
    Stack({alignContent: Alignment.TopStart}) {
      // 确认密码
      Column() {
        TextInput()
          .width('90%')
          .height(50)
          .backgroundColor(Color.White)
          .margin({top: 10, bottom: 10})
          .border({ width: 2, color: this.focusOn == 3? '#ff008bcb' : Color.Gray })
          .borderRadius(13)
          .type(InputType.Password)
          .showPasswordIcon(true)
          .showError(this.confirmError)
          .onFocus(() => {
            this.focusOn = 3
          })
          .onChange((value: string)=>{
            this.confirm = value
            console.log("varify: ", this.confirm)
            console.log("password: ", this.auth.password +" confirm: "+ this.confirm)
            if(this.confirm != this.auth.password) {
              this.confirmError = '两次密码不一致'
            } else {
              this.confirmError = ''
            }
          })
          .onDidInsert(()=>{
          })
      }
      .alignItems(HorizontalAlign.End)
      Column() {
        Text("确认密码")
          .fontSize(15)
          .fontColor(this.focusOn == 3 ? '#ff008bcb' : Color.Gray)
      }
      .width(70)
      .height(20)
      .justifyContent(FlexAlign.Center)
      .backgroundColor(Color.White)
      .offset({x: 15})
    }
  }

  @Builder
  authInfo() {
    Column() {
      if(this.uri == '') {
        Image($r('app.media.ic_upload'))
          .width(80)
          .height(60)
          .opacity(0.5)
        Text("学生认证")
          .fontColor(Color.Gray)
          .margin({top: 10})
      } else {
        Image(this.uri)
          .width('90%')
          .height(200)
          .borderRadius(10)
          .objectFit(ImageFit.Contain)
      }


    }
    .width('90%')
    .height(200)
    .borderRadius(10)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#f1f1f1')
    .border({ width: 1, color: Color.Gray })
    .margin({left: 10, top: 10})
    .onClick(() => {
      this.addPic()
    })
  }
  /**
   * 验证表单
   */
  vaildateForm(): boolean {
    if(this.auth.studentId == '') {
      showBottomError(this.getUIContext(), "请输入学号")
    } else if(this.auth.password == ''){
      showBottomError(this.getUIContext(), "请输入密码")
    } else if(this.confirm == '') {
      showBottomError(this.getUIContext(), "请输入确认密码")
    } else if(this.uri == '') {
      showBottomError(this.getUIContext(), "请上传学生认证信息")
    } else {
      return true
    }
    return false
  }

  /**
   * 注册账号
   */
  async register() {
    this.loading = true
    // 1、先上传学生认证信息，获取到url
    try{
      // 如果头像是file://开头，则上传图片
      if(this.uri.startsWith("file:")) {
        // 上传头像获取url
        const u = await upload(this.uri, getContext(this) as common.UIAbilityContext)
        console.log(`上传图片成功`, JSON.stringify(u))
        this.uri = u.url
        this.auth.authInfo = u.url
        this.auth.deleteUrl = u.del
      }
      this.loading = false
    } catch (err) {
      this.loading = false
      console.error("出错：", err)
    }
    // 2、提交表单
    register(this.auth).then((res) => {
      console.log(JSON.stringify(res))
      showBottomToast(this.getUIContext(), res)
      router.pushUrl({url: 'pages/Register'})
      router.clear()
    }).catch((err: string) => {
      console.error("注册失败", err)
      showBottomError(this.getUIContext(), err)
    })
  }


  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Column() {
        this.studentId()
        this.password()
        this.valPassword()
        this.authInfo()
        Button('注册')
          .width('50%')
          .height(50)
          .backgroundColor('#ff008bcb')
          .borderRadius(13)
          .margin({top: 10})
          .fontSize(20)
          .fontColor(Color.White)
          .onClick(() => {
            if(this.vaildateForm()) {
              this.register()
            }
          })
        Row() {
          Text('已有账号？')
            .fontSize(15)
            .fontColor(Color.Gray)
            .onClick(() => {
              console.info('注册账号')
            })
          Text('立即登录')
            .fontSize(15)
            .fontColor('#ff008bcb')
            .onClick(() => {
              router.pushUrl({url: 'pages/Login'})
              router.clear()
            })
        }
        .margin({top: 10})
      }
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center)

      if(this.loading) {
        Loading({h: "15%"})
      }
    }

  }

  pageTransition() {
    PageTransitionEnter({ duration: 100 })
      .slide(SlideEffect.Bottom) //Right
    // PageTransitionExit({ duration: 200 })
    //   .slide(SlideEffect.Right) //Right
  }
}