import { Post, PostList } from '../../utils/Mock'
import { router } from '@kit.ArkUI'
import { PostCard } from '../components/PostCard'
import { getRecPostList, PostModel, PostQuery } from '../../api/postApi'
import { EmptyPage } from '../components/EmptyPage'
import { showBottomError } from '../../utils/toast'

@Entry
@Component
export struct RecPost {
  private LOG = "[RecPost]"
  @State postList: PostModel[] = []
  @State scrollPosition: number = 0
  @State buttonOpacity: number = 0.9
  @State buttonShow: boolean = true

  onPageShow() {
    const queryParam = new PostQuery(1, 10, 1)
    getRecPostList(queryParam).then((res) => {
      console.log('获取推荐帖子成功: ', JSON.stringify(res))
      this.postList = res.list
      this.postList.forEach((item: PostModel) => {
        console.log(`文章${item.id}的图片列表：`, JSON.stringify(item.imageList))
        console.log(`文章${item.id}的用户信息：`, JSON.stringify(item.userInfo))
      })
    }).catch((err: string) => {
      console.error('获取推荐帖子失败: ', err)
      showBottomError(this.getUIContext(), err)
    })
  }

  @Builder
  MyPostList() {
    ForEach(this.postList, (item: PostModel, index: number)=>{
      PostCard({item: item})
    }, (item: Post) => item.id.toString())
  }

  build() {
    Stack() {
      Scroll() {
        if(this.postList.length == 0) {
          EmptyPage()
        } else {
          Column() {
            this.MyPostList()
          }
          .width('100%')
          .constraintSize({minHeight: '100%'})
          .backgroundColor('#f1f1f1')
        }
      }
      .scrollBarWidth(0)
      .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
        if(yOffset > 0) {
          // 向下滚动
          this.buttonShow = false
          if(this.buttonOpacity > 0) {
            this.buttonOpacity = 0
          }
        } else {
          this.buttonShow = true
          this.buttonOpacity = 0.95
          // if(this.buttonOpacity < 0.6) {
          //   this.buttonOpacity += 0.30
          // } else {
          // }
        }
      })
      /**
       * 添加按钮
       */
      Stack() {
        Row()
          .width(50)
          .height(50)
          .justifyContent(FlexAlign.Center)
          .borderRadius(25)
          .backgroundColor('#ff09a2de')
          .opacity(this.buttonOpacity)
          .shadow({
            radius: 10, // 阴影模糊半径
            color: '#a4000040', // 阴影颜色，这里使用半透明黑色
            offsetX: 5, // 阴影水平偏移量
            offsetY: 5 // 阴影垂直偏移量
          })
        Image($r('app.media.ic_plus'))
          .width(21)
          .height(21)
          .margin({ right: 1, top: 2})
          .opacity(this.buttonOpacity)
        //0
      }
      .position({ bottom: 30, right: 30})
      // 根据显示区域判断
      .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
        if (isVisible && currentRatio == 1.0) {
          // 调用自定义的show方法
          this.onPageShow()
        } else if (currentRatio == 0.0) {
          // 调用自定义的hide方法
        }
      })
      .onClick(() => {
        if(this.buttonShow) {
          router.pushUrl({
            url: 'pages/post/AddPost',
          })
        }
      })

    }
  }
}