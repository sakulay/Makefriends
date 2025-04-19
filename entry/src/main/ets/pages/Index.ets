import { TopSearch } from './components/TopSearch';
import { Friends } from './friends/Friends';
import { Home } from './post/Post';
import { LogInPage } from './LogInPage';
import { Messages } from './chat/Messages';
import { Mine } from './mine/Mine';
import { News } from './News';
import { BotItem, TopItem } from '../utils/Mock';
import { initMessage, MessageModel } from '../model/MessageModel';
import { initMineSimpleInfo } from '../viewmodel/UserProfileModel';
import { DownloadImagePage } from './Test';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State botSelect: number = 0
  @State topSelect: number = 1
  private topController: TabsController = new TabsController()
  private botController: TabsController = new TabsController()
  @State showLogIn: boolean = false
  @State logInHeight: string = '0'
  @State login: boolean = true
  @LocalStorageLink("unread") unreadListLink: Array<MessageModel> = []
  aboutToAppear(): void {
    initMessage()
    // this.unreadListLink = AppStorage.get("unread") as Array<MessageModel>
    initMineSimpleInfo()
    console.log("index: ", AppStorage.get("unread"))
  }
  @Builder
  TabBotBuilder(item: BotItem, index: number) {
    Column() {
      Image(this.botSelect === index ? item.icon_selected : item.icon_normal)
        .width(22)
        .height(22)
        .objectFit(ImageFit.Contain)
      Text(item.text)
        .fontSize(12)
        .fontColor(this.botSelect === index ? $r('app.color.blue_theme_2') : '#000')
        .margin({ top: 4 })
    }
    .border({ width: { top: 1 }, color: '#ffe9e9e9' })
    .backgroundColor(Color.White)
    .onClick(() => {
      if (index !== 4) {
        this.botSelect = index
      } else {
        if(this.login == false) {
          animateTo({
            duration: 200,
            curve: Curve.Linear
          }, () => {
            this.showLogIn = true
            this.logInHeight = '100%'
          })
        } else {
          this.botSelect = index
        }
      }
    })
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
  }
  @Builder
  TabTopBuilder(item: TopItem, index: number) {
    Column() {
      Text(item.title)
        .fontSize(16)
        .fontColor(this.topSelect === index ? '#f04142' : '#000')
      Divider()
        .strokeWidth(2)
        .color('#f04142')
        .width(20)
        .opacity(this.topSelect === index ? 1 : 0)
        .margin({ top: 3 })
      Divider()
        .strokeWidth(1)
        .color(Color.Grey)
        .width('100%')
        .opacity(0.3)
    }
    .width(50)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.topSelect = index
    })
  }

  @Builder
  ShopLogIn() {
    Column() {
      Image($r('app.media.anquan'))
        .height(50)
        .width(50)
      Text('您还没有登录头条账号')
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 15 })
        .fontColor(Color.Black)
      Text('登录头条账号进入商城， 可领取更多权益')
        .fontColor('#999')
        .fontSize(12)
        .margin({ bottom: 80 })
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text('立即登录').fontColor(Color.White)
          .fontSize(14)
      }
      .width('100%')
      .height(36)
      .backgroundColor('#f04142')
      .onClick(() => {
        animateTo({
          duration: 200,
          curve: Curve.Linear
        }, () => {
          // this.showLogIn = true
          this.logInHeight = '100%'
        })
      })
    }
    .padding(20)
  }

  build() {
    Stack({ alignContent: Alignment.Bottom }) {
      Column() {
        Tabs({ barPosition: BarPosition.End, controller: this.botController, index: this.botSelect }) {
          TabContent() {
            Home()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_home'),
            icon_selected: $r('app.media.ic_public_home_click'),
            text: '首页',
          }, 0))

          TabContent() {
            // News()
            DownloadImagePage()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_news'),
            icon_selected: $r('app.media.ic_public_news_click'),
            text: '资讯',
          }, 1))

          TabContent() {
            Messages()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_message'),
            icon_selected: $r('app.media.ic_public_message_click'),
            text: '消息',
          }, 2))

          TabContent() {
            Friends()
          }
          .tabBar(this.TabBotBuilder({
            icon_normal: $r('app.media.ic_public_friends'),
            icon_selected: $r('app.media.ic_public_friends_click'),
            text: '好友',
          }, 3))

          TabContent() {
            Mine()
          }
          .tabBar(
            this.TabBotBuilder({
              icon_normal: $r('app.media.ic_public_mine'),
              icon_selected: $r('app.media.ic_public_mine_click'),
              text: '个人',
            }, 4)
          )
        }
        .scrollable(false)
        .onChange((index: number) => {
          this.botSelect = index
        })
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)

      LogInPage({showLogIn : this.showLogIn, logInHeight: this.logInHeight })
    }
    .margin({top: 0})
  }
}