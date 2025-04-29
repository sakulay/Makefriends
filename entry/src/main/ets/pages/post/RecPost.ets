import { Post, PostList } from '../../utils/Mock'
import { router } from '@kit.ArkUI'
import { PostCard } from '../components/PostCard'
import { getRecPostList, PostModel, PostQuery } from '../../api/postApi'
import { EmptyPage } from '../components/EmptyPage'
import { showBottomError, showBottomToast } from '../../utils/toast'
import { Loading } from '../components/Loading'
import { CustomDialogExample } from '../View/DialogBottom'
import { ReportForm } from '../../api/reportApi'

@Entry
@Component
export struct RecPost {
  private mock: string =
    `{"id":3,"userId":14,"title":"标题3","content":"内容3","imageList":[],"likeCount":50,"commentCount":60,"createTime":"2025-02-25 12:00:00",
    "userInfo":
    {"studentId":"14","nickname":"林键超","avatar":"http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg","gender":1,"bio":"我自横刀向天笑，去留肝胆两昆仑","deleteUrl":""}
    }`
  private LOG = "[RecPost]"
  @State postList: PostModel[] = []
  @State scrollPosition: number = 0
  @State buttonOpacity: number = 0.9
  @State buttonShow: boolean = true
  @State isNone: boolean = false
  @State page: number = 1
  @State isLoading: boolean = false
  @State reportForm: ReportForm = new ReportForm(1, "", "");
  onPageShow() {
    this.getList()
  }

  getList() {
    this.isLoading = true
    const queryParam = new PostQuery(this.page, 10, 1)
    getRecPostList(queryParam).then((res) => {
      if(res.list.length > 0) {
        console.log('获取推荐帖子成功: ', JSON.stringify(res))
        // 去重处理
        const newPosts = res.list.filter(newPost => 
          !this.postList.some(existingPost => existingPost.id === newPost.id)
        )
        this.postList.push(...newPosts)
        this.postList.forEach((item: PostModel) => {
          console.log(`文章${item.id}: 点赞数 ${JSON.stringify(item.likeCount)} 评论数 ${JSON.stringify(item.commentCount)}`)
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
        .gesture(LongPressGesture(
          {repeat: false}).onAction(() => {
          this.reportForm.complaintTargetId = item.id.toString()
          this.reportForm.complaintTargetType = 1
          this.dialogControllerBottom?.open()
        })
        )
    }, (item: Post) => item.id.toString())
  }

  dialogControllerBottom: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({reportForm: this.reportForm}),
    openAnimation: {
      curve: Curve.Friction,
      playMode: PlayMode.Alternate,
    },
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    width: '90%',
    height: "10%",
    gridCount: 2,
    customStyle: false,
    cornerRadius: 10,
  })

  build() {
    Stack() {
      Scroll() {
        if(this.postList.length == 0) {
          EmptyPage()
        } else {
          Column() {
            this.MyPostList()
            if(this.isLoading) {
              Loading({h: "10%", text: ''})
                .offset({bottom: 0})
            }
          }
          .width('100%')
          .constraintSize({minHeight: '100%'})
          .backgroundColor('#fff8f7f7')
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