import { getNoticePage, NoticeModel, NoticePageQuery } from '../../api/noticeApi';
import { Page } from '../../api/friendsApi';
import { router } from '@kit.ArkUI';

@Entry
@Component
struct NoticeListPage {
  @State notices: NoticeModel[] = [];
  @State total: number = 0;
  @State currentPage: number = 1;
  @State pageSize: number = 10;
  @State loading: boolean = false;

  aboutToAppear() {
    this.loadNotices();
  }

  async loadNotices() {
    this.loading = true;
    try {
      const query = new NoticePageQuery(this.currentPage, this.pageSize);
      const response = await getNoticePage(query);
      this.notices = response.list;
      this.total = response.total;
    } catch (error) {
      console.error('加载通知失败:', error);
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
        Text('通知列表')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor('#FFFFFF')

      // 通知列表
      List() {
        ForEach(this.notices, (notice: NoticeModel) => {
          ListItem() {
            Column() {
              Row() {
                Text(notice.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                if (!notice.isRead) {
                  Circle()
                    .width(8)
                    .height(8)
                    .fill('#FF0000')
                    .margin({ left: 8 })
                }
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)

              Row() {
                Text(notice.publisherName)
                  .fontSize(14)
                  .fontColor('#666666')
                Text(notice.publishTime)
                  .fontSize(14)
                  .fontColor('#666666')
                  .margin({ left: 16 })
              }
              .width('100%')
              .margin({ top: 8 })
            }
            .width('100%')
            .padding(16)
            .backgroundColor('#FFFFFF')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/notice/NoticeDetailPage',
                params: { noticeId: notice.id }
              });
            })
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F5F5F5')
    }
    .width('100%')
    .height('100%')
  }
} 