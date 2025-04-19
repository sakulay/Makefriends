import { router } from '@kit.ArkUI';
import { login } from '../api/authApi';
import { showBottomToast, showTopToast } from '../utils/toast';
import { AuthenticationToken, AuthModel, LoginForm } from '../viewmodel/AuthModel';
import { Loading } from './components/Loading';

@Entry
@Component
struct Login {
  @State message: string = 'Hello World';
  @State focusOn: number = 0;
  @State loginForm: LoginForm = new LoginForm('14', '123');
  @State loading: boolean = false;
  @Builder
  studentId() {
    Stack({alignContent: Alignment.TopStart}) {
      // 学号
      TextInput({text: this.loginForm.studentId})
        .width('90%')
        .height(50)
        .backgroundColor(Color.White)
        .margin({top: 10})
        .border({ width: 2, color: this.focusOn == 1? '#ff008bcb' : Color.Gray })
        .borderRadius(13)
        .onChange((value: string) => {
          this.loginForm.studentId = value;
        })
        .onFocus(() => {
          this.focusOn = 1
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
        TextInput({text: this.loginForm.password})
          .width('90%')
          .height(50)
          .backgroundColor(Color.White)
          .margin({top: 10})
          .border({ width: 2, color: this.focusOn == 2? '#ff008bcb' : Color.Gray })
          .borderRadius(13)
          .type(InputType.Password)
          .showPasswordIcon(true)
          .onChange((value: string) => {
            this.loginForm.password = value; // 更新状态变量
          })
          .onFocus(() => {
            this.focusOn = 2
          })
        Text('忘记密码')
          .fontSize(15)
          .fontColor(Color.Gray)
          .margin({right: 10, top: 5})
          .onClick(() => {
            console.info('忘记密码?')
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

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Column() {
        // 学号
        this.studentId()
        // 密码
        this.password()
        // 登录按钮
        Button('登录')
          .width('50%')
          .height(50)
          .backgroundColor('#ff008bcb')
          .borderRadius(13)
          .margin({top: 10})
          .fontSize(20)
          .fontColor(Color.White)
          .onClick(async () => {
            this.loading = true;
            // console.log('登录: ', JSON.stringify(this.loginForm))
            try {
              const result: AuthenticationToken = await login<AuthenticationToken>(this.loginForm);
              result.studentId = this.loginForm.studentId;
              console.log('登录成功', JSON.stringify(result));
              console.log('登录成功', result.studentId)
              AppStorage.setOrCreate("auth", result)
              this.loading = false;
              showBottomToast(this.getUIContext(), "登录成功")
              router.pushUrl({url: 'pages/Index'})
              router.clear()
            } catch (errMsg) {
              console.error('登录失败，错误信息是：', errMsg);
              this.loading = false;
              showBottomToast(this.getUIContext(), errMsg)
            }
          })
        Row() {
          Text('还没有账号？')
            .fontSize(15)
            .fontColor(Color.Gray)
            .onClick(() => {
              console.info('注册账号')
            })
          Text('立即注册')
            .fontSize(15)
            .fontColor('#ff008bcb')
            .onClick(() => {
              router.pushUrl({url: 'pages/Register'})
              router.clear()
            })
        }
        .margin({top: 10})
      }
      .width('100%')
      .height('100%')
      .padding(15)
      .justifyContent(FlexAlign.Center)
      // .backgroundColor(Color.Gray)

      if(this.loading) {
        Loading({h: "40%"})
      }
    }

  }

  pageTransition() {
    //设置入场动效
    PageTransitionEnter({ duration: 100 })
      .slide(SlideEffect.Bottom)
  }
}