import { router } from "@kit.ArkUI"
import { logout } from "../../api/authApi"
import { disconnect } from "../../model/MessageModel"
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel"

@Entry
@Component
export struct Mine {
  private LOG = "[Mine] "
  @State userSimpleInfo: UserSimpleInfo = new UserSimpleInfo('2101510218', '林键超', 'http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg','')
  aboutToAppear(): void {
    const info = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
    console.log(this.LOG,"aboutToAppear拿到个人数据：", JSON.stringify(info))
    if(info) this.userSimpleInfo = info
  }

  onPageShow(): void {
    const params = router.getParams()
    console.log('[Mine] onPageShow拿到路由参数：', JSON.stringify(params))
    if(params) {
      const info = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
      if(info) this.userSimpleInfo = info
    }
  }

  @Builder
  Default() {
    Row() {
      Column() {
        Image($r('app.media.ic_favorite'))
          .height(33)
          .width(33)
        Text('我的动态')
      }
      Column() {
        Image($r('app.media.ic_favorite'))
          .height(33)
          .width(33)
        Text('我的评论')
      }
      Column() {
        Image($r('app.media.ic_favorite'))
          .height(33)
          .width(33)
        Text('我的收藏')
      }
      Column() {
        Image($r('app.media.ic_favorite'))
          .height(33)
          .width(33)
        Text('稍后再看')
      }
    }
    .width('100%')
    .height(60)
    .padding(15)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      // 顶部
      Row(){
        // 头像展示
        Column() {
          Image(this.userSimpleInfo.avatar)
            .width(70)
            .height(70)
            .borderRadius(25)
        }
        // 用户名、学号
        Column() {
          // 昵称
          Text(this.userSimpleInfo.nickname)
            .fontSize(25)
          // 学号
          Text('学号：' + this.userSimpleInfo.studentId)
        }
        .width(220)
        .height(70)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        // .margin({ left: 10, right : 10})
        // .backgroundColor(Color.Green)
        // 箭头按钮
        Column() {
          Image($r('app.media.ic_right_arrow'))
            .width(20)
            .height(15)
        }
        // .width(10)00
        .height(70)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(100)
      .padding(15)
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/mine/MineDetail',
          params: {
            studentId: this.userSimpleInfo.studentId
          }
        })
      })
      Row() {
        Text("个性签名：" + this.userSimpleInfo.bio)
      }
      .width('100%')
      .height(50)
      .padding(15)
      .backgroundColor(Color.White)
      .margin({top: 1})
      // 中间
      Column() {
        this.Default()
      }
      .width('100%')
      .height(80)
      .backgroundColor(Color.White)
      .margin({top: 15})
      // 底部
      Column() {
        Row() {
          Text("退出登录")
            .onClick(()=>{
              logout().then((res)=>{
                console.log('退出登录成功', res)
                AppStorage.delete('auth')
                disconnect()
                router.pushUrl({url: 'pages/Login'})
                router.clear()
              })
            })
        }
        .padding(10)
        .height(50)
      }
      .width('100%')
      .backgroundColor(Color.White)
      .margin({top: 15})
      .padding({left: 10})
      .alignItems(HorizontalAlign.Start)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f0f0')
    // 根据显示区域判断
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        // 调用自定义的show方法
        this.onPageShow()
      } else if (currentRatio == 0.0) {
        // 调用自定义的hide方法
      }
    })
  }
}