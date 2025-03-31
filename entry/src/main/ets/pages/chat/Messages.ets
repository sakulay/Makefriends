import { getUnreadList, MessageModel } from "../../model/MessageModel"
import { router } from "@kit.ArkUI"

@Entry
@Component
export struct Messages {
  @State unreadList: Array<MessageModel> = getUnreadList()

  @StorageLink("unread") unreadListLink: Array<MessageModel> = getUnreadList()

  aboutToAppear(): void {
    console.log("I am Messages")
  }

  @Builder
  unreadListBuilder() {
    ForEach(this.unreadListLink, (item: MessageModel)=>{
      Row() {
        Image($r('app.media.pic2'))
          .width(50)
          .height(50)
          .borderRadius(25)
          .border({ width: 1, color: Color.Gray })
        Column() {
          Text(item.sender)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          Text("有一句话不知道当讲不当讲")
            .fontSize(14)
        }
        .margin({ left: '10' })
        .height(45)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)

        Column() {
          Text(item.content)
            .fontSize(15)
            .fontColor(Color.White)
        }
        .width(19)
        .height(19)
        .borderRadius(9)
        .justifyContent(FlexAlign.Center)
        .backgroundColor(Color.Red)
      }
      .width('100%')
      .padding({left: 10, right: 10, top: 10, bottom: 5})
      .backgroundColor(Color.White)
      .margin({top: 10})
      .onClick(()=>{
        router.pushUrl({url: 'pages/chat/ChatPage'})
      })
    })
  }

  build() {
    Column() {
      // 顶部
      Row() {
        Text("好友列表")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Image($r('app.media.ic_public_add_filled'))
          .width(20)
          .height(20)
          .onClick(()=>{
            router.pushUrl({url: 'pages/friends/AddFriends'})
          })
      }
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(15)
      Scroll() {
        Column() {
          this.unreadListBuilder()
        }
        // .height('100%')
        .width('100%')
        .padding({left: 10, right: 10})
        .backgroundColor('#f1f1f1')
      }
      .layoutWeight(1)
      .scrollBarWidth(0)
    }
  }
}