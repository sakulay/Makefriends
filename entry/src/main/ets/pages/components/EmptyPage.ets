@Component
export struct EmptyPage {
  @Prop H: string = '100%'
  build() {
    Column() {
      Image($r('app.media.ic_empty'))
        .width(200)
        .height(200)
    }
    .justifyContent(FlexAlign.Center)
    .height(this.H)
    .width('100%')
  }
}