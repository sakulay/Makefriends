import { friends, friendsList, PersonalInfo } from "../utils/Mock"
import { router } from "@kit.ArkUI"
import { it } from "@ohos/hypium"

@Entry
@Component
export struct Friends {

  @Builder
  friendsList(friendsList: friends[]) {
      ForEach(friendsList, (item: friends, index)=>{
        Row() {
          Image(item.img)
            .width(50)
            .height(50)
            .borderRadius(25)
            .border({ width: 1, color: Color.Gray })
          Column() {
            Text(item.nickname)
              .fontSize(16)
              .fontWeight(FontWeight.Bold)

            Text(item.bio)
              .fontSize(14)
          }
          .margin({ left: '10' })
          .height(45)
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .padding({left: 10, right: 10, top: 10, bottom: 5})
        .onClick(()=>{
          router.pushUrl({url: 'pages/friends/InfoCard', params:
            new PersonalInfo(1,item.img,item.nickname,item.bio, 1)
          })
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

      // 好友列表
      Scroll() {
        Column() {
          // 搜索栏
          Row() {
            Image($r('app.media.ic_search'))
              .width(30)
              .height(30)
            Text("搜索")
          }
          .width('100%')
          .backgroundColor('#f5f5f5')
          .justifyContent(FlexAlign.Center)
          .padding(5)
          this.friendsList(friendsList)
        }
        .width('100%')

      }
      .layoutWeight(1)

    }
    .height('100%')
    .width('100%')
  }
}