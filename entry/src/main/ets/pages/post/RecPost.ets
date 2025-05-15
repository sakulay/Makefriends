import { Post } from '../../utils/Mock'
import { router } from '@kit.ArkUI'
import { PostCard } from '../components/PostCard'
import { getRecPostList, PostModel, PostQuery } from '../../api/postApi'
import { EmptyPage } from '../components/EmptyPage'
import { showBottomError, showBottomToast } from '../../utils/toast'
import { Loading } from '../components/Loading'
import { CustomDialogExample } from '../View/DialogBottom'
import { ReportForm } from '../../api/reportApi'
import { PostList } from "../../utils/Mock"
import { CategoryModel, CategoryQuery, getCategoryPage, mockCategories } from '../../api/categoryApi'

export interface PostParams {
  postId: number
  likeCount: number
  commentCount: number
  favoriteCount: number
}

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
  @State params: PostParams = {
    postId: 0,
    likeCount: 0,
    commentCount: 0,
    favoriteCount: 0
  }
  @State cardOpacity: number = 0
  @State selectedCategory: number = 0 // 当前选中的分类ID
  @State categories: CategoryModel[] = [new CategoryModel(0, '全部', '所有分类', 0, '')]
  aboutToAppear() {
    this.getCategories()
  }
  onPageShow() {
    console.log(`${this.LOG} aboutToAppear`)
    const params = router.getParams() as PostParams
    if (params) {
      this.params = params
      this.updatePostData()
    }
    // this.postList.push(JSON.parse(this.mock))
    this.getList()
    setTimeout(() => {
      this.cardOpacity = 1
    }, 100) // 模拟延迟显示
  }
  
  updatePostData() {
    const postId = this.params.postId
    const likeCount = this.params.likeCount
    const commentCount = this.params.commentCount
    const favoriteCount = this.params.favoriteCount
    
    if (postId) {
      const index = this.postList.findIndex(post => post.id === postId)
      if (index !== -1) {
        console.log(`${this.LOG} 更新前的帖子数据`, JSON.stringify(this.postList[index]))
        // 创建全新的数组
        const newPostList = this.postList.slice()
        const oldPost = this.postList[index]
        console.log(`${this.LOG} 更新前的帖子数据`, JSON.stringify(favoriteCount))
        const newPost = new PostModel(
          oldPost.id,
          oldPost.userId,
          oldPost.title,
          oldPost.content,
          oldPost.imageList,
          likeCount,
          commentCount,
          oldPost.createTime,
          oldPost.userInfo,
          favoriteCount
        )
        console.log(`${this.LOG} 更新后的帖子数据`, JSON.stringify(newPost.favoriteCount))
        newPostList[index] = newPost
        this.postList = newPostList
      }
    }
  }
  /**
   * 获取分类
   */
  getCategories() {
    this.isLoading = true
    let queryParams = new CategoryQuery(1, 50, 0)
    getCategoryPage(queryParams).then((res) => {
      console.log('获取分类成功: ', JSON.stringify(res))
      this.categories.push(...res.list)
      this.isLoading = false
    }).catch((err: string) => {
      console.error('获取分类失败: ', err)
      showBottomError(this.getUIContext(), err)
    })
  }
  /**
   * 获取帖子列表
   */
  getList() {
    this.isLoading = true
    
    // 创建查询参数对象，并添加分类ID
    const queryParam = new PostQuery(
      this.page, 
      10, 
      1, 
      undefined, 
      undefined, 
      undefined, 
      this.selectedCategory !== 0 ? this.selectedCategory : undefined
    )
    
    if (this.selectedCategory !== 0) {
      console.log(`${this.LOG} 按分类查询，分类ID: ${this.selectedCategory}`)
    }
    
    getRecPostList(queryParam).then((res) => {
      if(res.list.length > 0) {
        console.log('获取推荐帖子成功: ', JSON.stringify(res))
        
        // 更新现有帖子的数据
        res.list.forEach(newPost => {
          const existingPostIndex = this.postList.findIndex(post => post.id === newPost.id)
          if (existingPostIndex !== -1) {
            // 更新现有帖子的数据
            const existingPost = this.postList[existingPostIndex]
            existingPost.likeCount = newPost.likeCount
            existingPost.commentCount = newPost.commentCount
          } else {
            // 添加新帖子
            this.postList.push(newPost)
          }
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
      PostCard({item: this.postList[index]})
        .opacity(this.cardOpacity)
        .gesture(LongPressGesture(
          {repeat: false}).onAction(() => {
          this.reportForm.complaintTargetId = item.id.toString()
          this.reportForm.complaintTargetType = 1
          this.dialogControllerBottom?.open()
        })
        )
    }, (item: PostModel) => item.id.toString())
  }

  @Builder
  CategoryBar() {
    Scroll() {
      Row({ space: 8 }) {
        ForEach(this.categories, (item: CategoryModel) => {
          Text(item.name)
            .fontSize(14)
            .fontWeight(this.selectedCategory === item.id ? FontWeight.Bold : FontWeight.Normal)
            .fontColor(this.selectedCategory === item.id ? '#2080f0' : '#666666')
            .backgroundColor(this.selectedCategory === item.id ? '#E6F2FF' : '#F5F5F5')
            .borderRadius(16)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .onClick(() => {
              this.switchCategory(item.id)
            })
        }, (item: CategoryModel) => item.id.toString())
      }
      .padding({ left: 10, right: 10 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .height(40)
    .backgroundColor(Color.White)
    .margin({bottom: 8})
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

  // 切换分类
  switchCategory(categoryId: number) {
    if (this.selectedCategory === categoryId) return

    this.selectedCategory = categoryId
    this.page = 1 // 重置页码
    this.postList = [] // 清空现有帖子列表
    this.isNone = false // 重置结束标记
    this.getList() // 重新获取帖子列表
  }

  build() {
    Stack() {
      Column() {
        // 添加分类选择栏
        this.CategoryBar()
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
            // .backgroundColor('#fff8f7f7')
            .backgroundColor('#f5f7fa') // 更柔和的白蓝色
            .padding({bottom: 55})
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
      }

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
        // Row()
        //   .width(56)
        //   .height(56)
        //   .borderRadius(28)
        //   .backgroundColor('linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)')
        //   .opacity(this.buttonOpacity)
        //   .shadow({
        //     radius: 12,
        //     color: '#aa000000',
        //     offsetX: 4,
        //     offsetY: 4
        //   })
        Row() {
          Blank()
            .width('50px')
            .height('50px')
            .borderRadius('50%')
            .backgroundColor('linear-gradient(to right, #ff8a00, #e52e71)')  // 渐变色背景
        }
        .width('50px')
        .height('50px')
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .opacity(this.buttonOpacity)
        Image($r('app.media.ic_plus'))
          .width(21)
          .height(21)
          .margin({ right: 1, top: 2})
          .opacity(this.buttonOpacity)
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