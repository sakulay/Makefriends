import { router } from '@kit.ArkUI'
import { ComplaintItem, getComplaintList } from '../../api/complaintApi'
import { getRecPostList } from '../../api/postApi'
import { showBottomError } from '../../utils/toast'
import { EmptyPage } from '../components/EmptyPage'
import { PostQuery } from '../../api/postApi'
import { PostModel } from '../../api/postApi'

@Entry
@Component
struct Complaints {
  private LOG = "[Complaints] "
  @State complaints: ComplaintItem[] = []

  onPageShow(): void {
    console.log(this.LOG + 'onPageShow')
    getComplaintList().then((res) => {
      console.log(this.LOG + 'getComplaintList: ' + JSON.stringify(res.list))
      this.complaints = res.list
    }).catch((e: string) => {
      showBottomError(this.getUIContext(), e)
    })
  }

  @Builder
  TopBar() {
    Row({space: 10}) {
      Image($r('app.media.ic_left_arrow'))
        .width(24)
        .height(24)
        .onClick(()=>{
          router.back()
        })
      Text('我的举报')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .fontColor('#333333')
      Row().width('10%')
    }
    .width('100%')
    .height(56)
    .padding({left: 16, right: 16})
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
    .shadow({ radius: 8, color: '#0000000A', offsetX: 0, offsetY: 2 })
  }

  @Builder
  ComplaintItem(item: ComplaintItem) {
    Column() {
      Row() {
        Text(item.complaintTargetType === 1 ? '帖子' : '评论')
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
        
        Text(this.getStatusText(item.status))
          .fontSize(14)
          .fontColor(this.getStatusColor(item.status))
          .margin({left: 8})
      }
      .width('100%')
      .margin({bottom: 8})

      Row({space: 5}) {
        Text("举报描述：")
          .fontSize(14)
          .fontColor('#999999')
        Text(item.complaintDescription)
          .fontSize(14)
          .fontColor('#333333')
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .margin({ top: 8 })
      .justifyContent(FlexAlign.Start)
      Row() {
        Text(item.createTime)
          .fontSize(13)
          .fontColor('#999999')
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
    }
    .width('100%')
    .padding(16)
    .backgroundColor(Color.White)
    .margin({top: 1})
  }

  handleClick(type: number, targetId: string) {
    if(type == 1) {
      // 跳转到帖子详情
      getRecPostList(new PostQuery(1, 10, undefined, undefined, undefined, [Number(targetId)]))
        .then((res) => {
          if(res.list.length > 0) {
            const post = res.list[0]
            console.log(this.LOG + '跳转参数：' + JSON.stringify(post))
            // 跳转到帖子详情页
            router.pushUrl({
              url: 'pages/post/PostPage',
              params: post
            })
          }
        })
        .catch((e: string) => {
          showBottomError(this.getUIContext(), e)
        })
    }
  }

  private getStatusText(status: number): string {
    switch(status) {
      case 0: return '待处理'
      case 1: return '已处理'
      case 2: return '已拒绝'
      case 3: return '已关闭'
      default: return '未知'
    }
  }

  private getStatusColor(status: number): string {
    switch(status) {
      case 0: return '#FF9500'
      case 1: return '#34C759'
      case 2: return '#FF3B30'
      case 3: return '#8E8E93'
      default: return '#999999'
    }
  }

  build() {
    Column() {
      this.TopBar()
      if(this.complaints.length === 0) {
        EmptyPage()
      } else {
        List() {
          ForEach(this.complaints, (item: ComplaintItem) => {
            ListItem() {
              this.ComplaintItem(item)
            }
            .onClick(() => {
              this.handleClick(item.complaintTargetType, item.complaintTargetId)
            })
          })
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
} 