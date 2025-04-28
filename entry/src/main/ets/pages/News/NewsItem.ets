import { common } from "@kit.AbilityKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { promptAction, router } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { http } from "@kit.NetworkKit";
import { webview } from "@kit.ArkWeb";
import { NewsModel } from "../../api/newsApi";
import window from '@ohos.window';

interface WindowSize {
  width: number;
  height: number;
}

@Entry
@Component
export struct News {
  @State content: string = ''
  @State htmlContent: string = ''
  @State title: string = ''
  @State date: string = ''
  private webController: webview.WebviewController = new webview.WebviewController()
  @State isLoading: boolean = true
  @State windowWidth: number = 0
  @State windowHeight: number = 0
  private windowClass: window.Window | undefined = undefined

  aboutToAppear(): void {
    // 获取窗口信息
    window.getLastWindow(getContext(this)).then((windowClass) => {
      this.windowClass = windowClass;
      const rect = windowClass.getWindowProperties().windowRect;
      this.windowWidth = Number(rect.width);
      this.windowHeight = Number(rect.height);
    });

    const params = router.getParams() as NewsModel
    if(params) {
      this.content = params.content
      this.title = params.title
      this.date = params.date
      console.log('[NewsItem] content内容：', this.content)
      this.isLoading = false
      // 直接拼好完整的 HTML 并保存到 htmlContent
      this.htmlContent = `
        <html>
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
          <style>
            body { 
              font-size: 16px; 
              padding: 16px; 
              line-height: 1.6;
              color: #333;
              font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
              margin: 0;
              background: #fff;
              width: 100%;
              box-sizing: border-box;
            }
            .title-section {
              margin-bottom: 20px;
              padding-bottom: 16px;
              border-bottom: 1px solid #eee;
            }
            .title {
              font-size: 20px;
              font-weight: 500;
              margin-bottom: 12px;
              color: #333;
            }
            .date {
              font-size: 14px;
              color: #999;
              display: flex;
              align-items: center;
            }
            .date img {
              width: 16px;
              height: 16px;
              margin-right: 4px;
            }
            table { 
              border-collapse: collapse; 
              width: 100%; 
              margin: 16px 0;
              background: #fff;
              border-radius: 8px;
              overflow: hidden;
              box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }
            td, th { 
              border: 1px solid #eee; 
              padding: 12px; 
              text-align: left; 
            }
            th {
              background: #f5f5f5;
              font-weight: 500;
            }
            p { 
              margin: 12px 0;
              line-height: 1.8;
            }
            strong {
              color: #FF6B6B;
              font-weight: 500;
            }
            img {
              max-width: 100%;
              height: auto;
              border-radius: 8px;
              margin: 16px 0;
              display: block;
            }
            img:active {
              transform: scale(1.5);
              transition: transform 0.3s ease;
            }
            .content-wrapper {
              width: 100%;
              overflow-x: auto;
              -webkit-overflow-scrolling: touch;
            }
            @media screen and (max-width: 768px) {
              body {
                padding: 12px;
              }
              table {
                font-size: 14px;
                min-width: 100%;
              }
              td, th {
                padding: 8px;
                white-space: nowrap;
              }
            }
            @media screen and (orientation: landscape) {
              body {
                padding: 20px;
              }
              .title {
                font-size: 24px;
              }
              table {
                font-size: 16px;
              }
              td, th {
                padding: 12px;
              }
            }
          </style>
        </head>
        <body>
          <div class="title-section">
            <div class="title">${this.title}</div>
            <div class="date">
              <img src="app/media/ic_time.png" alt="time">
              ${this.date}
            </div>
          </div>
          <div class="content-wrapper">
            ${this.content}
          </div>
        </body>
        </html>
      `
    }
    console.log('[NewsItem] aboutToAppear拿到路由参数：', JSON.stringify(params))
  }

  onWindowSizeChange(size: WindowSize) {
    this.windowWidth = size.width;
    this.windowHeight = size.height;
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Row() {
          Image($r('app.media.ic_left_arrow'))
            .width(24)
            .height(24)
            .onClick(() => {
              router.back()
            })
        }
        .width(40)
        .height(40)
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        
        Text("资讯详情")
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .border({ width: { bottom: 0.5 }, color: '#e6e6e6' })

      if(this.isLoading) {
        LoadingProgress()
          .color('#FF6B6B')
      } else {
        Web({
          controller: this.webController,
          src: encodeURIComponent(this.htmlContent)
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
    .backgroundColor('#f5f5f5')
    .onAreaChange((oldValue: Area, newValue: Area) => {
      if (this.windowClass) {
        this.windowWidth = Number(newValue.width);
        this.windowHeight = Number(newValue.height);
      }
    })
  }
}