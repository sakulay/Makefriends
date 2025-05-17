import { router } from "@kit.ArkUI"

@Entry
@Component
struct SecurityCenter {
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .onClick(() => {
            router.back();
          })
        Text('安全中心')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 12 })
        Blank()
      }
      .width('100%')
      .height(48)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 功能列表
      Column() {
        // 修改密码
        Row() {
          Text('修改密码')
            .fontSize(16)
            .fontColor('#333333')
          Blank()
          Image($r('app.media.ic_right_arrow'))
            .width(16)
            .height(16)
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/mine/ChangePassword'
          })
        })

        Divider()
          .color('#F5F5F5')
          .width('100%')
          .height(1)

        // 注销账号
        Row() {
          Text('注销账号')
            .fontSize(16)
            .fontColor('#FF6B6B')
          Blank()
          Image($r('app.media.ic_right_arrow'))
            .width(16)
            .height(16)
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/mine/DeleteAccount'
          })
        })
      }
      .width('100%')
      .margin({ top: 12 })
      .borderRadius(16)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
  }
} 