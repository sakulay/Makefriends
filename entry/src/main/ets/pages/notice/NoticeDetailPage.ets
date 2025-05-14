import { router } from '@kit.ArkUI';
import { NoticeDetailVO, getNoticeDetail } from '../../api/noticeApi';
interface NoticeParams {
  noticeId: string;
}
@Entry
@Component
struct NoticeDetailPage {
  @State noticeId: string = '';
  @State notice: NoticeDetailVO | null = null;
  @State loading: boolean = false;

  aboutToAppear() {
    this.loadNoticeDetail();
    let params = router.getParams() as NoticeParams;
    if(params.noticeId) {
      this.noticeId = params.noticeId;
    }
  }

  async loadNoticeDetail() {
    this.loading = true;
    try {
      const response = await getNoticeDetail(this.noticeId);
      this.notice = response;
    } catch (error) {
      console.error('加载通知详情失败:', error);
    } finally {
      this.loading = false;
    }
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back();
          })
        Text('通知详情')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 通知详情内容
      if (this.loading) {
        LoadingProgress()
          .width(24)
          .height(24)
          .margin({ top: 16 })
      } else if (this.notice) {
        Column() {
          Text(this.notice.title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ top: 16, bottom: 8 })

          Row() {
            Text(this.notice.publisherName)
              .fontSize(14)
              .fontColor('#666666')
            Text(this.notice.publishTime)
              .fontSize(14)
              .fontColor('#666666')
              .margin({ left: 16 })
          }
          .margin({ bottom: 16 })

          Text(this.notice.content)
            .fontSize(16)
            .fontColor('#333333')
            .margin({ top: 16 })
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
      } else {
        Text('暂无通知详情')
          .fontSize(16)
          .fontColor('#999999')
          .margin({ top: 16 })
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
} 