import { PromptAction, router } from '@kit.ArkUI';
import { text } from '@kit.ArkGraphics2D';
import { PersonalInfo } from '../utils/Mock';

@Entry
@Component
struct AddFriends {
  @State status: number = 2
  @State text: string = '添加'
  @State info: PersonalInfo = new PersonalInfo(2101510218, 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '林键超', '我自横刀向天笑，去留肝胆两昆仑', 1)
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()

  aboutToAppear(): void {

  }
  onPageShow(): void {
    console.log('onPageShow')
    let params = router.getParams() as PersonalInfo;
    if (params) {
      console.log("add"+ JSON.stringify(params))
      this.info = params // 更新 A 页面状态
      this.status = params.status
      this.text = '待处理'
    }
  }
  // 根据状态计算颜色
  computedColor(status: number): Color {
    if(status == 0) {
      return Color.Gray
    } else if(status == 1) {
      return Color.Gray
    } else {
      return Color.Black
    }
  }
  // 处理添加按钮点击事件
  handleClick() {
    if(this.status == 0) {
      this.showToast('已提交好友申请，请勿重复申请')
    } else if(this.status == 1) {
      this.showToast('对方已是你的好友，不能重复添加')
    } else {
      this.status = 0
      this.text = "待处理"
      this.showToast('已发送好友申请')
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
  @Builder
  TopBar() {
    Row({space: 10}) {
      Image($r('app.media.ic_left_arrow'))
        .width(25)
        .height(25)
        .onClick(()=>{
          router.back()
        })
      TextInput({placeholder: '学号'})
        .layoutWeight(1)
      Text("搜索")
        .fontColor(Color.Blue)
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
  }

  @Builder
  NoMore() {
    Row() {
      Text("没有更多了")
        .fontColor('#ff8a8a8a')
    }
    .height(60)
  }

  @Builder
  SearchItem() {
    Row(){
      // 头像展示
      Column() {
        Image(this.info.img)
          .width(70)
          .height(70)
          .borderRadius(25)
      }
      // 昵称、学号
      Column() {
        Text(this.info.nickname)
          .fontSize(25)
        Text(this.info.id.toString())
      }
      .layoutWeight(1)
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .margin({top: 7, left: 10})
      // .backgroundColor(Color.Green)
      // 右侧
      Column() {
        Image($r('app.media.ic_right_arrow'))
          .width(20)
          .height(15)
          // .margin({bottom: 5})
        Row() {
          Text(this.text)
            .fontColor(this.computedColor(this.status))
            .onClick(()=>{
              this.handleClick()
            })
        }
        .width(60)
        .height(30)
        .margin({top: 15})
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#f1f1f1')
        .border({width: 1, color: Color.Gray})
      }
      .height(80)
      // .backgroundColor(Color.Brown)
      .justifyContent(FlexAlign.Center)
    }
    .width('93%')
    .height(110)
    .padding(15)
    .margin({top: 15})
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.SpaceBetween)
    .borderRadius(10)
    .onClick(()=>{
      this.info.status = this.status
      router.pushUrl({
        url: 'pages/friends/InfoCard',
        params: this.info
      })
    })
  }
  build() {
    Column() {
      this.TopBar()
      this.SearchItem()
      Row({space: 10}) {
        Button("0")
          .width(50)
          .height(30)
          .onClick(()=>{
            this.status = 0
            this.text = "待处理"
          })
        Button("1")
          .width(50)
          .height(30)
          .onClick(()=>{
            this.status = 1
            this.text = "已添加"
          })
        Button("2")
          .width(50)
          .height(30)
          .onClick(()=>{
            this.status = 2
            this.text = "添加"
          })
        Text(this.status.toString())
        Text(this.text)
      }
      this.NoMore()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f1f1')
  }
}