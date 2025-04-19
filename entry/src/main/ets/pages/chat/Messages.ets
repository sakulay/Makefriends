import { getUnreadList, MessageModel, Unread } from "../../model/MessageModel"
import { router } from "@kit.ArkUI"
import { getAppChatUnreads } from "../../api/chatApi"
import { getStudentId } from "../../utils/utils"

@Entry
@Component
export struct Messages {
  private TAG = "[Messages]"
  // @State unreadList: Array<Unread> = getUnreadList()
  @StorageLink("unread") unreadListLink: Array<Unread> = []

  onPageShow(): void {
    getAppChatUnreads(getStudentId()).then((res: Array<Unread>)=>{
      console.log(this.TAG, "获取未读消息列表成功", JSON.stringify(res))
      this.unreadListLink = res
    }).catch((err: string)=>{
      console.log(this.TAG, "获取未读消息列表失败", err)
    })
  }
  @Builder
  unreadListBuilder() {
    ForEach(this.unreadListLink, (item: Unread)=>{
      Row() {
        Image(item.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)
          .border({ width: 1, color: Color.Gray })
        Column() {
          Text(item.nickname)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          Text(item.latestContent)
            .fontSize(14)
        }
        .margin({ left: '10' })
        .height(45)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
        if(item.unreadCount != '0') {
          Column() {
            Text( item.unreadCount )
              .fontSize(15)
              .fontColor(Color.White)
          }
          .width(19)
          .height(19)
          .borderRadius(9)
          .justifyContent(FlexAlign.Center)
          .backgroundColor(Color.Red)
        }
      }
      .width('100%')
      .padding({left: 10, right: 10, top: 10, bottom: 5})
      .backgroundColor(Color.White)
      .margin({top: 2, bottom: 12})
      .onClick(()=>{
        AppStorage.set("selectedChat", item.sender)
        router.pushUrl({url: 'pages/chat/ChatPage'})
      })
    })
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Scroll() {
        Column() {
          this.unreadListBuilder()
        }
        .layoutWeight(1)
        .width('100%')
        .padding({left: 10, right: 10})
        .justifyContent(FlexAlign.Start)
        // .backgroundColor('#f1f1f1')
      }
      .layoutWeight(1)
      .scrollBarWidth(0)
      .margin({top: 50})

      // 顶部
      Row() {
        Text("消息列表")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Row()
      }
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(15)
    }
    .width('100%')
    .height('100%')
    // 根据显示区域判断
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        // 调用自定义的show方法
        this.onPageShow()
      } else if (currentRatio == 0.0) {
        // 调用自定义的hide方法
      }
    })
    // .backgroundColor('#f1f1f1')
  }
}