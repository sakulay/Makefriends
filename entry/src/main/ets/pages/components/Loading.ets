// components/LoadingOverlay.ets
@Component
export struct Loading {
  private text: string = '加载中...';
  private h: string = '100%';
  build() {
    Column() {
      LoadingProgress()
        .width(40)
        .height(40)
        .color($r('app.color.blue_theme_2'))

      if (this.text) {
        Text('加载中...')
          .fontSize(14)
          .margin({ top: 10 })
          .fontColor($r('app.color.blue_theme_2'))
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(this.h)
    .backgroundColor(Color.Transparent) // 可选：添加轻微蒙层
  }
}
