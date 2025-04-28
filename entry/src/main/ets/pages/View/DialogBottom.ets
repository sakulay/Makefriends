import { ReportForm } from "../../api/reportApi"
import { ReportDialog } from "./report"

@CustomDialog
export struct CustomDialogExample {
  controller?: CustomDialogController
  @Prop reportForm: ReportForm
  @Builder
  picAndText(url: Resource, text: string) {
    Column() {
      Image(url)
        .width(30)
        .height(30)
      Text(text)
    }
    .onClick(()=>{
      if(text == '举报'){
        this.controller?.close()
        this.dialogControllerBottom?.open()
      }
    })
  }
  dialogControllerBottom: CustomDialogController | null = new CustomDialogController({
    builder: ReportDialog({reportForm: this.reportForm}),
    openAnimation: {
      curve: Curve.Friction,
      playMode: PlayMode.Alternate,
    },
    autoCancel: true,
    alignment: DialogAlignment.Center,
    width: '90%',
    height: "40%",
    // offset: { dx: 0, dy: -20 },
    gridCount: 2,
    customStyle: false,
    // backgroundColor: 0xd9ffffff,
    cornerRadius: 5,
  })

  build() {

    Row() {
      this.picAndText($r('app.media.ic_warn'), '举报')
      this.picAndText($r('app.media.ic_share'), '分享')
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("60%")
    // .backgroundColor(Color.Brown)
    .height('100%')
  }
}
