import { TopItem } from "../../utils/Mock"
import { MinePost } from "./MinePost"
import { RecPost } from "./RecPost"

@Entry
@Component
export struct Home {
  @State topSelect: number = 1
  private topController: TabsController = new TabsController()
  @Builder
  TabTopBuilder(item: TopItem, index: number) {
    Column() {
      Text(item.title)
        .fontSize(this.topSelect === index ? 20 : 16)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.topSelect === index ? $r('app.color.blue_theme_2') : '#000')
      Divider()
        .strokeWidth(2)
        .color($r('app.color.blue_theme_2'))
        .width(20)
        .opacity(this.topSelect === index ? 1 : 0)
        .margin({ top: 3 })
    }
    .width(50)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.topSelect = index
    })
  }
  @Builder
  BarBuilder() {
    Row() {
      this.TabTopBuilder({title: "动态"}, 0)
      this.TabTopBuilder({title: "推荐"}, 1)
    }
  }
  example() {
    this.topController
  }
  build() {
    Column() {
      Stack({alignContent: Alignment.TopStart}) {
        Tabs({ barPosition: BarPosition.Start, controller: this.topController, index: this.topSelect }) {
          TabContent() {
            MinePost()
          }
          TabContent() {
            RecPost()
          }
        }
        .barHeight(0)
        .margin({ top: 38 })
        // .backgroundColor(Color.Brown)
        .scrollable(true)
        .onChange((index: number) => {
          this.topSelect = index
        })

        // 导航栏、搜索栏
        Row() {
          Row() {
            this.BarBuilder()
          }
          Row({space: 10}) {
            Image($r('app.media.ic_search'))
              .width(30)
              .height(30)
            Image($r('app.media.ic_email'))
              .width(25)
              .height(25)
          }
        }
        .width('100%')
        .height(40)
        .padding({ left: 10, right: 10 })
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor(Color.White)
      }
    }
    .backgroundColor('#f1f1f1')
  }
}