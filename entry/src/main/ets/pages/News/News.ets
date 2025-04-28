import { getAppNewsPage, NewsModel, NewsQuery } from '../../api/newsApi'
import { router } from '@kit.ArkUI'
import { Page } from '../../api/friendsApi'
import { Loading } from '../components/Loading'
import { showBottomToast, showTopToast } from '../../utils/toast'

@Entry
@Component
struct News {
  private TAG = '[News]'
  @State isLoading: boolean = true
  @State page: number = 1
  @State pageSize: number = 10
  @State isNone: boolean = false
  @State isLoadingMore: boolean = false
  @State lastScrollY: number = 0
  @State scrollEnd: number = 0 // Scroll 内容总高度
  @State viewportHeight: number = 0 // 可视区域高度

  @State newsList: Array<NewsModel> = [
    // new NewsModel('2025-02-25', '广西机电设备招标有限公司关于桂林电子科技大学花江校区商业街AB区门面招租（GXJD-25133CC020143）招租公告', '<p>内容1</p>'),
    // new NewsModel('2025-02-25', '桂林电子科技大学等离子球磨机询价采购公告', '<p><strong>桂电门面招租</strong></p>')
  ]

  onPageShow() {
    console.log('获取新闻列表成功')
    this.getNewsList()
  }
  getNewsList() {
    this.isLoading = true
    getAppNewsPage(new NewsQuery(this.page, this.pageSize)).then((res: Page<NewsModel>)=>{
      console.log(this.TAG, '获取新闻列表成功', JSON.stringify(res.list))
      if(res.list.length > 0) {
        this.newsList.push(...res.list)
      } else {
        this.isNone = true
      }
      this.isLoading = false
    }).catch((err: string)=>{
      console.log(this.TAG, '获取新闻列表失败', err)
      this.isLoading = false
    })
  }
  @Builder
  newsListBuilder() {
    ForEach(this.newsList, (item: NewsModel)=>{
      Column() {
        Row() {
          // 左侧装饰条
          Column()
            .width(4)
            .height(40)
            .backgroundColor('#FF6B6B')
            .borderRadius(2)
            .margin({ right: 12 })

          // 右侧内容区
          Column() {
            // 标题
            Text(item.title)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333333')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ bottom: 8 })

            // 底部信息栏
            Row() {
              // 日期
              Row() {
                Image($r('app.media.ic_time'))
                  .width(14)
                  .height(14)
                  .margin({ right: 4 })
                Text(item.date)
                  .fontSize(12)
                  .fontColor('#999999')
              }

              Blank()

              // 阅读更多
              Row() {
                Text('阅读更多')
                  .fontSize(12)
                  .fontColor('#FF6B6B')
                Image($r('app.media.ic_right_arrow'))
                  .width(12)
                  .height(12)
                  .margin({ left: 4 })
              }
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }
          .layoutWeight(1)
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }
      .width('94%')
      .constraintSize({minHeight: 90})
      .padding({left: 16, right: 16, top: 16, bottom: 16})
      .backgroundColor(Color.White)
      .shadow({
        radius: 8,
        color: 'rgba(0, 0, 0, 0.08)',
        offsetX: 0,
        offsetY: 2
      })
      .borderRadius(12)
      .margin({top: 8, bottom: 8})
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/News/NewsItem',
          params: item
        })
      })
    })
  }

  loadMoreData() {
    this.isLoadingMore = true
    showTopToast(this.getUIContext(), '加载更多')
  }

  build() {
    Stack({alignContent: Alignment.Bottom}) {
      Stack({alignContent: Alignment.TopStart}) {
        Scroll() {
          Column() {
            this.newsListBuilder()
            if(this.isLoading) {
              Loading({h: "10%", text: ''})
                .offset({bottom: 0})
            }
          }
          .constraintSize({minHeight: "100%"})
          .width('100%')
        }
        .layoutWeight(1)
        .scrollBarWidth(0)
        .margin({top: 60})
        .onScrollEdge((event)=>{
          if(event == 2){
            if(!this.isNone) {
              this.page++
              this.getNewsList()
            } else {
              showBottomToast(this.getUIContext(), '没有更多了')
            }
          }
        })
        // 顶部
        Row() {
          Text("校园资讯")
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
          Row()
        }
        .width('100%')
        .backgroundColor(Color.White)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(15)
        .border({width: {bottom: 1}, color: '#ffb5b5b5'})
      }
      .width('100%')
      .height('100%')
      // .backgroundColor('#fff8f7f7')
      .backgroundColor('#fff8f7f7')
      // 根据显示区域判断
      .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
        if (isVisible && currentRatio == 1.0) {
          // 调用自定义的show方法
          this.onPageShow()
        } else if (currentRatio == 0.0) {
          // 调用自定义的hide方法
        }
      })



    }
    .width('100%')
    .height('100%')


  }
}

export { News }
