import { addReport, ReportForm } from "../../api/reportApi"
import { showBottomToast, showTopToast } from "../../utils/toast"

@CustomDialog
export struct ReportDialog {
  controller?: CustomDialogController
  @Prop reportForm: ReportForm


  build() {

    Column() {
      Text("举报")
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
      Column() {
        Text("填写举报描述")
          .fontWeight(500)
        TextArea({text: $$this.reportForm.complaintDescription, placeholder: ""})
          .width('95%')
          .borderRadius(10)
          .constraintSize({minHeight: 100})
          .backgroundColor('#f1f1f1')
      }
      .alignItems(HorizontalAlign.Start)
      Row() {
        Text("提交")
          .fontColor(Color.Gray)
      }
      .justifyContent(FlexAlign.Center)
      .width('95%')
      .height(50)
      .borderRadius(5)
      .backgroundColor('#ffeaeaea')
      .onClick(() => {
        if(this.reportForm.complaintDescription.length == 0) {
          showBottomToast(this.getUIContext(), "请填写举报描述")
        } else {
          addReport(this.reportForm).then((res) => {
            this.controller?.close()
            showTopToast(this.getUIContext(), "举报成功, 我们将尽快受理")
          }).catch((err: string) => {
            this.controller?.close()
            showBottomToast(this.getUIContext(), `举报失败：${err}`)
          })
        }
      })

    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width("100%")
    .height('100%')
    .padding(10)
  }
}
