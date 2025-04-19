import { UserSimpleInfo } from '../../../viewmodel/UserProfileModel'
import { router } from '@kit.ArkUI'
import { showBottomError, showTopToast } from '../../../utils/toast'
import { addFriendRequest, FriendRequestForm } from '../../../api/friendsApi'

@Component
export struct FriendItem {
  private LOG = "[FriendItem]"
  @State text: string = '添加'
  @Prop info: UserSimpleInfo = new UserSimpleInfo('2101510218','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1)
  @State studentId: string = '14'


  // 根据状态计算颜色
  computedColor(status: number): Color {
    if(status == 1 || status == 2) {
      return Color.Gray
    } else {
      return Color.Black
    }
  }
  computedText(status: number) {
    if(status == 1) {
      return '已同意'
    } else if(status == 2){
      return '已拒绝'
    } else {
      return '同意'
    }
  }
  // 处理添加按钮点击事件
  handleClick() {
    if(this.info) {
      if(this.info.status == 0) {
        showTopToast(this.getUIContext(), '同意')
      }
    }
  }


  build() {
    Column(){
      if(this.info) {
        Row(){
          // 头像展示
          Column() {
            Image(this.info.avatar)
              .width(70)
              .height(70)
              .borderRadius(25)
          }
          // 昵称、学号
          Column() {
            Text(this.info.nickname)
              .fontSize(25)
            Text(this.info.studentId.toString())
          }
          .layoutWeight(1)
          .height(60)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(HorizontalAlign.Start)
          .margin({top: 7, left: 10})
          // .backgroundColor(Color.Green)
          // 右侧按钮部分
          Column() {
            Row() {
              Text(this.computedText(this.info.status as number))
                .fontColor(this.computedColor(this.info.status as number))
                .onClick(()=>{
                  this.handleClick()
                })
            }
            .width(60)
            .height(30)
            // .margin({top: 15})
            .justifyContent(FlexAlign.Center)
            // .backgroundColor('#f1f1f1')
            .borderRadius(6)
            .border({width: 1, color: Color.Gray})
          }
          .height(80)
          // .backgroundColor(Color.Brown)
          .justifyContent(FlexAlign.Center)
        }
        .width('93%')
        .height(110)
        .padding(15)
        .margin({top: 10})
        .backgroundColor(Color.White)
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.SpaceBetween)
        .borderRadius(10)
        .onClick(()=>{
          let info = this.info
          // 如果是待处理，更改状态为4，以便动态展示infocard底部栏
          if(info.status == 0) {
            info.status = 4
          }
          router.pushUrl({
            url: 'pages/friends/InfoCard',
            params: info
          })
        })
      }
    }
    // .height('100%')
    .width('100%')

  }
}