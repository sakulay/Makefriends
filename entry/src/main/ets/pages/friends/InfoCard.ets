import { PromptAction, router } from "@kit.ArkUI"
import { PersonalInfo } from "../utils/Mock"

@Entry
@Component
export struct InfoCard {
  @State status: number = 1
  @State text: string = '发消息'
  @State info: PersonalInfo = new PersonalInfo(2101510218, 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '林键超', '我自横刀向天笑，去留肝胆两昆仑', 1)
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()

  aboutToAppear(): void {
    let params = router.getParams() as PersonalInfo
    console.log(JSON.stringify(params))
    this.status = params.status
    this.info = params
    this.handleStatus()
  }
  // 处理状态
  handleStatus() {
    if(this.status == 0) {
      this.text = '待处理'
    } else if(this.status == 1) {
      this.text = '发消息'
    } else {
      this.text = '添加好友'
    }
  }
  // 显示提示信息
  showToast(msg: string) {
    this.promptAction.showToast({
      message: msg,
      duration: 1000,
      alignment: Alignment.Top,
      shadow: ShadowStyle.OUTER_FLOATING_SM
    })
  }
  // 处理点击事件
  handleClick() {
    if(this.status == 0) {
      this.showToast('已提交好友申请，请耐心等待')
    } else if(this.status == 1) {
      this.showToast('跳转到发送消息页面')
    } else {
      this.status = 0
      this.info.status = 0
      this.text = '待处理'
      this.showToast('添加好友成功')

    }
  }
  @Builder
  Info() {
    // 顶部
    Row(){
      // 头像展示
      Column() {
        Image(this.info.img)
          .width(70)
          .height(70)
          .borderRadius(25)
      }
      // 用户名、学号
      Column() {
        // 昵称
        Text(this.info.nickname)
          .fontSize(25)
        // 学号
        Text(this.info.id.toString())
      }
      .width(220)
      .height(70)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height(120)
    .padding({top: 45, left: 15, right: 15})
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    // 个性签名
    Row() {
      Text(this.info.bio)
        .backgroundColor(Color.White)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.Brown)
    .padding(15)
  }

  @Builder
  bottom() {
    Row(){
      Row(){
        Text(this.text)
      }
      .width("80%")
      .height(40)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f1f1f1')
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .onClick(()=>{
      this.handleClick()
    })
  }

  @Builder
  top() {
    Row() {
      Image($r("app.media.ic_left_arrow"))
        .width(25)
        .height(25)
        .onClick(()=>{
          router.back(Number(router.getLength())-1, this.info)
          // router.replaceUrl({url: 'pages/friends/AddFriends', params: this.info})
        })
    }
    .padding(10)
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Column() {
        Scroll() {
          Column() {
            // 个人信息
            this.Info()
            // 图文动态
            Column()
              .height(1050)
              .backgroundColor(Color.White)
              .margin({top: 15})
          }
          .justifyContent(FlexAlign.Start)
        }
        .layoutWeight(1)
        /** 底部 */
        this.bottom()
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.Gray)
      .justifyContent(FlexAlign.SpaceBetween)

      // 顶部返回按钮
      this.top()
    }
  }
}