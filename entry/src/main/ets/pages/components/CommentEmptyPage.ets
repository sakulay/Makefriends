@Component
export struct CommentEmptyPage {
  @Prop H: string = '100%'
  build() {
    Column() {
      Image($r('app.media.ic_empty_comment'))
        .width(100)
        .height(100)
      Text("评论区空空如也")
        .fontWeight(FontWeight.Bold)
        .fontColor('#53c4e6')
    }
    .justifyContent(FlexAlign.Center)
    .height(this.H)
    .width('100%')
  }
}