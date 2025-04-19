import { router } from '@kit.ArkUI';

@Entry
@Component
struct EntryPage {
  @State message: string = 'Hello World';

  aboutToAppear(): void {
    setTimeout(() => {
      router.pushUrl({url: 'pages/Login'})
      router.clear()
    }, 3000)
  }
  build() {
    Column() {
      Image($r('app.media.ic_makefriends'))
        .width(200)
        .height(200)
      Text("校园交友平台")
        .fontSize(30)
        .fontWeight(500)
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}