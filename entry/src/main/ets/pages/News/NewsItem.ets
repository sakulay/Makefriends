import { common } from "@kit.AbilityKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { promptAction, router } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { http } from "@kit.NetworkKit";
import { webview } from "@kit.ArkWeb";
import { NewsModel } from "../../api/newsApi";

@Entry
@Component
export struct News {
  @State content: string = `
      <p><strong>桂电门面招租</strong></p>
      <p>欢迎符合条件的投标人参与</p>
      <table>
        <tr><th>门面编号</th><th>类别</th><th>面积</th></tr>
        <tr><td>D-101-1</td><td>奶茶店</td><td>65㎡</td></tr>
        <tr><td>D-101-2</td><td>文具店</td><td>74㎡</td></tr>
      </table>`
//   @State htmlContent: string = `
// <html>
//     <head>
//       <meta charset="UTF-8">
//       <style>
//         body { font-size: 16px; padding: 10px; }
//         table { border-collapse: collapse; width: 100%; margin-top: 10px; }
//         td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
//         p { margin: 8px 0; }
//       </style>
//     </head>
//     <body>
//       ${this.content}
//     </body>
//     </html>
//     `
  @State htmlContent: string = '' // 拼接好的完整HTML

  private webController: webview.WebviewController = new webview.WebviewController()
  @State isLoading: boolean = true

  aboutToAppear(): void {
    const params = router.getParams() as NewsModel
    if(params) {
      this.content = params.content
      console.log('[NewsItem] content内容：', this.content)
      this.isLoading = false
      // 直接拼好完整的 HTML 并保存到 htmlContent
      this.htmlContent = `
        <html>
        <head>
          <meta charset="UTF-8">
          <style>
            body { font-size: 16px; padding: 10px; }
            table { border-collapse: collapse; width: 100%; margin-top: 10px; }
            td, th { border: 1px solid #ccc; padding: 8px; text-align: left; }
            p { margin: 8px 0; }
          </style>
        </head>
        <body>
          ${this.content}
        </body>
        </html>
      `
    }
    console.log('[NewsItem] aboutToAppear拿到路由参数：', JSON.stringify(params))
  }

  build() {

    Column() {
      if(this.isLoading) {
        LoadingProgress()
      } else {
        Web({
          controller: this.webController,
          src: encodeURIComponent(this.htmlContent) // 空白页面占位符
        })
          .width('100%')
          .layoutWeight(1)
          .fileAccess(true)
          .javaScriptAccess(true)
          .domStorageAccess(true)
          .onlineImageAccess(true)
          .onAppear(() => {
            console.log("onAppear triggered, loading content...");
            try {
              this.webController.loadData(encodeURIComponent(this.htmlContent), 'text/html', 'utf-8');
              console.log("loadData: ", this.htmlContent)
            } catch (error) {
              console.error(`ErrorCode: ${(error as BusinessError).code},  Message: ${(error as BusinessError).message}`);
            }
          })
      }

    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}