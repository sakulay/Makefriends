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
          Text(item.title)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        Row() {
          Text(item.date)
        }
        .width('100%')
        .margin({top: 7, right: 5})
        .justifyContent(FlexAlign.End)
      }
      .width('94%')
      .constraintSize({minHeight: 80})
      .padding({left: 13, right: 13, top: 17, bottom: 10})
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)
      .shadow({
        radius: 12,         // 模糊多一点，看起来轻盈
        color: 'rgba(0, 0, 0, 0.06)',
        offsetX: 0,
        offsetY: 4           // 垂直轻微抬起
      })
      .borderRadius(12)
      .margin({top: 2, bottom: 12})
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
