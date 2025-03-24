import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Mine {
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
          Image($r('app.media.apple'))
            .width(70)
            .height(70)
            .borderRadius(25)
        }
        // 用户名、学号
        Column() {
          // 昵称
          Text('林键超')
            .fontSize(25)
          // 学号
          Text('学号：2101510218')
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
      .height(140)
      .padding(15)
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/mine/MineDetail'
        })
      })
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
        Button("111111")
          .onClick(()=>{
            router.pushUrl({url: 'pages/mine/MineDetail',params: {}})
          })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .margin({top: 15})
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f0f0')

  }
}