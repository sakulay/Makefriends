import { getRecPostList, PostModel, PostQuery } from '../../api/postApi'
import { showBottomError, showBottomToast } from '../../utils/toast'
import { EmptyPage } from '../components/EmptyPage'
import { PostCard } from '../components/PostCard'
import { router } from '@kit.ArkUI'
import { getStudentId } from '../../utils/utils'

@Entry
@Component
export struct MinePost {
  @State postList: PostModel[] = []
  @State scrollPosition: number = 0
  @State buttonOpacity: number = 0.9
  @State buttonShow: boolean = true
  @State page: number = 1
  @State isNone: boolean = false
  @State isLoading: boolean = false
  onPageShow(): void {
    this.getList()
  }

  aboutToAppear() {
  }

  getList() {
    this.isLoading = true
    const id = getStudentId()
    const queryParam = new PostQuery(this.page, 10, 1, Number(id))
    getRecPostList(queryParam).then((res) => {
      if(res.list.length > 0) {
        console.log('获取推荐帖子成功: ', JSON.stringify(res))
        // 去重处理
        const newPosts = res.list.filter(newPost => 
          !this.postList.some(existingPost => existingPost.id === newPost.id)
        )
        this.postList.push(...newPosts)
        this.postList.forEach((item: PostModel) => {
          console.log(`文章${item.id}的图片列表：`, JSON.stringify(item.imageList))
          console.log(`文章${item.id}的用户信息：`, JSON.stringify(item.userInfo))
        })
      } else {
        this.isNone = true
      }
      this.isLoading = false
    }).catch((err: string) => {
      console.error('获取推荐帖子失败: ', err)
      showBottomError(this.getUIContext(), err)
    })
  }

  @Builder
  MyPostList() {
    ForEach(this.postList, (item: PostModel, index: number)=>{
      PostCard({item: item})
    }, (item: PostModel) => item.id.toString())
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
          .backgroundColor('#fff8f7f7')
        }
      }
      .scrollBarWidth(0)
      .onWillScroll((xOffset: number, yOffset: number, scrollState: ScrollState, scrollSource: ScrollSource) => {
        if(yOffset > 0) {
          this.buttonShow = false
          if(this.buttonOpacity > 0) {
            this.buttonOpacity -= 0.10
          }
        } else {
          if(this.buttonOpacity < 0.6) {
            this.buttonOpacity += 0.20
          } else {
            this.buttonShow = true
            this.buttonOpacity = 0.9
          }
        }
      })
      .onScrollEdge((event)=>{
        if(event == 2){
          if(!this.isNone) {
            this.page++
            this.getList()
          } else {
            showBottomToast(this.getUIContext(), '没有更多了')
          }
        }
      })

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