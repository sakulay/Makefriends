import { getUnreadList, MessageModel, Unread } from "../../model/MessageModel"
import { router } from "@kit.ArkUI"
import { getAppChatUnreads } from "../../api/chatApi"
import { getStudentId } from "../../utils/utils"
import { dealImageResMsg } from "../../utils/MessageUtils"
import { MessageBase, SpanItem } from "../../model/Message"
import { SpanType } from "../../common/ChatConstants"

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
      // 同步到AppStorage
      AppStorage.set("unread", res)
    }).catch((err: string)=>{
      console.log(this.TAG, "获取未读消息列表失败", err)
    })
  }

  @Builder
  unreadListBuilder() {
    ForEach(this.unreadListLink, (item: Unread)=>{
      Row() {
        Image(item.avatar)
          .width(56)
          .height(56)
          .borderRadius(28)
          .border({ width: 1, color: '#E8E8E8' })
          .shadow({ radius: 4, color: '#0000000A', offsetX: 0, offsetY: 2 })
        Column() {
          Text(item.nickname)
            .fontSize(17)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
            .margin({ bottom: 4 })

          Row() {
            Text(undefined) {
              ForEach(this.processContent(item.latestContent), (spanItem: SpanItem) => {
                if (spanItem.spanType === SpanType.IMAGE) {
                  ImageSpan($rawfile(spanItem.imgSrc))
                    .width(22)
                    .height(22)
                    .verticalAlign(ImageSpanAlignment.BOTTOM)
                    .margin({ right: 4 })
                } else if (spanItem.spanType === SpanType.TEXT) {
                  Span(spanItem.text)
                }
              })
            }
            .fontSize(15)
            .fontColor('#666666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
          }
          .width('100%')
          .constraintSize({
            minHeight: 22,
            maxWidth: '100%'
          })
        }
        .margin({ left: 12 })
        .height(56)
        .layoutWeight(1)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)

        if(item.unreadCount != '0') {
          Column() {
            Text(item.unreadCount)
              .fontSize(13)
              .fontColor(Color.White)
              .fontWeight(FontWeight.Medium)
          }
          .width(22)
          .height(22)
          .borderRadius(11)
          .justifyContent(FlexAlign.Center)
          .backgroundColor('#FF3B30')
          .shadow({ radius: 4, color: '#FF3B3033', offsetX: 0, offsetY: 2 })
        }
      }
      .width('100%')
      .padding({left: 16, right: 16, top: 12, bottom: 12})
      .backgroundColor(Color.White)
      .margin({top: 1, bottom: 1})
      .onClick(()=>{
        AppStorage.set("selectedChat", item.sender)
        router.pushUrl({url: 'pages/chat/ChatPage'})
      })
    })
  }

  private processContent(content: string): Array<SpanItem> {
    const msgBase = new MessageBase(true, '', '', 0);
    dealImageResMsg(msgBase, content);
    return msgBase.spanItems;
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Scroll() {
        Column() {
          this.unreadListBuilder()
        }
        .layoutWeight(1)
        .width('100%')
        .padding({left: 0, right: 0})
        .justifyContent(FlexAlign.Start)
        .backgroundColor('#F5F5F5')
      }
      .layoutWeight(1)
      .scrollBarWidth(0)
      .margin({top: 56})

      // 顶部导航栏
      Row() {
        Text("消息")
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .fontColor('#333333')
        Row()
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({left: 16, right: 16})
      .shadow({ radius: 8, color: '#0000000A', offsetX: 0, offsetY: 2 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        this.onPageShow()
      } else if (currentRatio == 0.0) {
      }
    })
  }
}