import { UserSimpleInfo } from '../../../viewmodel/UserProfileModel'
import { router } from '@kit.ArkUI'
import { showBottomError, showTopToast } from '../../../utils/toast'
import { addFriendRequest, FriendRequestForm, passFriendRequest } from '../../../api/friendsApi'

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
        this.info.status = 1
        passFriendRequest(this.info.requestId as string).then(() => {
          this.info.status = 1
          showTopToast(this.getUIContext(), '已通过好友申请')
        }).catch((error: string) => {
          showBottomError(this.getUIContext(), error)
        })
      }
    }
  }

  build() {
    Column(){
      if(this.info) {
        Row(){
          Image(this.info.avatar)
            .width(64)
            .height(64)
            .borderRadius(32)
            .border({ width: 1, color: '#E8E8E8' })
            .shadow({ radius: 4, color: '#0000000A', offsetX: 0, offsetY: 2 })
          
          Column() {
            Text(this.info.nickname)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
            Text(this.info.studentId.toString())
              .fontSize(14)
              .fontColor('#666666')
              .margin({top: 4})
          }
          .layoutWeight(1)
          .height(64)
          .justifyContent(FlexAlign.SpaceBetween)
          .alignItems(HorizontalAlign.Start)
          .margin({left: 12})

          Column() {
            Row() {
              Text(this.computedText(this.info.status as number))
                .fontColor(this.computedColor(this.info.status as number))
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .onClick(()=>{
                  this.handleClick()
                })
            }
            .width(70)
            .height(32)
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F5F5F5')
            .borderRadius(16)
            .border({width: 1, color: '#E8E8E8'})
          }
          .height(64)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.End)
        }
        .width('100%')
        .height(96)
        .padding({left: 16, right: 16, top: 16, bottom: 16})
        .backgroundColor(Color.White)
        .margin({top: 1})
        .onClick(()=>{
          let info = this.info
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
    .width('100%')
  }
}