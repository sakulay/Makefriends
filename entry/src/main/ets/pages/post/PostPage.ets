import { Post, PostList, TopItem } from '../utils/Mock';
import { PostComment } from './PostComment';
import { PostDetail } from './PostDetail';
import { promptAction, router } from '@kit.ArkUI';
import { CommentInputDialog } from '../View/CommentInputDialog';
import { NewsCommentData, NewsCommentModel } from '../../model/NewsCommentModel';
import { CommentPage } from '../View/CommentPage';
import { CommonConstants } from '../../common/CommonConstants';
import { mockData } from '../../mock/NewsDetailData';
import { util } from '@kit.ArkTS';
import { MyScroller } from '../View/Scroller';
@Entry
@Component
struct PostPage {
  // @State post: Post = new Post(1,1,'','','','',[],1,0,'')
  @State post: Post = PostList[0]
  @State topSelect: number = 0
  @State likeStatus: boolean = false
  @State starStatus: boolean = false

  @State curUser: string = 'yuyu';   // 当前用户
  @State replyUser: string = "";   // 被回复人昵称
  @State replyId: string = "";   // 被回复人id
  /**
   * 评论输入框
   */
  @State textInComment: string = "";   // 评论中的文字
  @State commentState: boolean = false;
  @State commentStatus: boolean = false; // true为回复评论，false为发布评论
  /**
   * 评论列表
   */
  private listScroller: Scroller = new Scroller(); // 初始化listScroller
  @State commentList: NewsCommentData = new NewsCommentData(); // 评论列表
  /**
   * 顶部导航栏
   */
  private topController: TabsController = new TabsController()
  @State isWebAtEnd: boolean = true; // web组件是否滚动到底部，ture到Web底部，false还未到底部。
  aboutToAppear(): void {
    let params = router.getParams() as Post
    if(params) {
      this.post = params
    }
    // 添加模拟数据
    this.commentList = mockData();
  }

  // 评论输入弹窗
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CommentInputDialog({
      textInComment: $textInComment,
      commentState: $commentState,
      placeholder: this.commentStatus? '回复 ' + this.replyUser : "参与讨论", // 回复样式为：@回复人昵称
      publish: () => this.publishComment()
    }),
    autoCancel: true,
    alignment: DialogAlignment.Bottom,
    customStyle: true,
    offset: {
      dx: 0,
      dy: -20
    }
  });

  // 评论区内容
  @Builder listBuilder() {
    List({ scroller: this.listScroller }) {
      LazyForEach(this.commentList, (item: NewsCommentModel) => {
        ListItem() {
          CommentPage({
            commonData: item,
            replyId: $replyId,
            replyUser: $replyUser,
            curUser: this.curUser,
            dialogController: this.dialogController,
            commentState: $commentState,
            commentStatus: $commentStatus,
          })
        }
      }, (item: NewsCommentModel) => item.id.toString())
    }
    .alignListItem(ListItemAlign.Center)
    .scrollBar(BarState.Off)
    .maintainVisibleContentPosition(false) // false: 显示区域上方插入或删除数据时可见内容位置会跟随变化。
    .enableScrollInteraction(false) // TODO：知识点：禁用List组件的手势
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .backgroundColor($r('app.color.container_nested_note_nested_list_bgc_color'))
    .id('commentList')
  }

  /**
   * 发布评论
   */
  publishComment(): void {
    // 生成评论id
    const uuid: string = util.generateRandomUUID();
    // 添加一条评论，包含评论id、头像、昵称、回复id、回复昵称、回复文本
    const comment: NewsCommentModel =
      new NewsCommentModel(uuid, $r('app.media.news_user_select'), this.curUser, this.replyId, this.replyUser,
        this.textInComment, new Date(), 0, new NewsCommentData());
    // 通过回复id获取该评论的父评论
    const parentComment = this.commentList.getParentData(this.replyId);
    // 如果获取到了父评论，则将该评论加到父评论下
    if (parentComment) {
      parentComment.replyList.addDataFirst(comment);
    } else {
      // 否则自己作为父评论
      this.commentList.addDataFirst(comment);
    }
    // 评论完成将回复人信息置空
    this.replyId = "";
    this.replyUser = "";
    // 滑动置顶
    this.listScroller.scrollToIndex(0, true, ScrollAlign.START);
  }




  /**
   * 顶部导航栏
   */
  @Builder
  TabTopBuilder(item: TopItem, index: number) {
    Column() {
      Text(item.title)
        .fontSize(this.topSelect === index ? 20 : 16)
        .fontColor(this.topSelect === index ? '#f04142' : '#000')
      Divider()
        .strokeWidth(2)
        .color('#f04142')
        .width(20)
        .opacity(this.topSelect === index ? 1 : 0)
        .margin({ top: 3 })
    }
    .width(50)
    .backgroundColor(Color.White)
    .onClick(() => {
      this.topSelect = index
    })
  }
  @Builder
  TopBar() {
    Stack({alignContent: Alignment.TopStart}) {
      Row() {
        this.TabTopBuilder({title: "正文"}, 0)
        this.TabTopBuilder({title: "评论"}, 1)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

      Image($r('app.media.ic_left_arrow'))
        .width(25)
        .height(25)
        .opacity(0.8)
        .margin({ left: 10 })
        .onClick(()=>{
          console.log("返回")
          router.back()
        })
    }


  }

  /**
   * 底部栏
  */
  @Builder
  BottomBar() {
    Row() {
      Row() {
        Text("参与讨论")
          .fontColor(Color.Gray)
      }
      .width('55%')
      .height(40)
      .margin({left: 10})
      .padding({left: 10})
      .borderRadius(8)
      .justifyContent(FlexAlign.Start)
      .backgroundColor('#f1f1f1')
      .onClick(() => {
        this.commentStatus = false
        this.dialogController?.open();
      })

      Row({space: 20}) {
        Column() {
          Image($r('app.media.ic_like'))
            .width(25)
            .height(25)
            .opacity(this.likeStatus ? 1 : 0.6)
            .onClick(() => {
              this.likeStatus = !this.likeStatus
            })
          Text('25')
            .fontColor(this.likeStatus? Color.Black : Color.Gray)
        }
        Column() {
          Image($r('app.media.ic_comment'))
            .width(25)
            .height(25)
            .opacity(0.6)
          Text('25')
            .fontColor(Color.Gray)
        }
        .padding({top: 2})
        Column() {
          Image($r('app.media.ic_star'))
            .width(25)
            .height(25)
            .opacity(this.starStatus ? 1 : 0.6)
            .onClick(() => {
              this.starStatus = !this.starStatus
            })
          Text('25')
            .fontColor(this.starStatus? Color.Black : Color.Gray)
        }
      }
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

    }
    .width('100%')
    .height(50)
    .padding({top: 5})
    .border({ width: { top: 1 }, color: '#ffe9e9e9' })
  }

  /**
   * 主体
   */
  @Builder
  Body() {
    Column() {
      // Scroll() {
      //   Column() {
      //     /**
      //      * 文章详情
      //      */
      //     PostDetail({post: this.post})
      //     Text("555")
      //     /**
      //      * 评论区
      //      */
      //     // PostComment()
      //     this.listBuilder()
      //   }
      //   // .height('100%')
      //   .width('100%')
      // }
      // .layoutWeight(1)
      MyScroller({
        detailBuilder: () => {this.PostDetailBuilder()},
        listBuilder: () => {this.listBuilder()},
        titleBuilder: () => {this.CommentTitle()},
        isWebAtEnd: $isWebAtEnd, // 传递Web组件是否滚动到下边界
        scrollList: (offset:number)=>{ this.scrollList(offset) }, // MyScroller组件滑动List
        getListOffset: ():number=>{ return this.getListOffset() },// MyScroller刷新List组件的yOffset
      })
        .layoutWeight(1)
      // 底部栏
      this.BottomBar()
    }
  }
  /**
   * 评论
   */
  @Builder
  Comment() {
    Column() {
      MyScroller({
        // webBuilder: () => {this.PostDetailBuilder()},
        listBuilder: () => {this.listBuilder()},
        titleBuilder: () => {this.CommentTitle()},
        isWebAtEnd: $isWebAtEnd, // 传递Web组件是否滚动到下边界
        scrollList: (offset:number)=>{ this.scrollList(offset) }, // MyScroller组件滑动List
        getListOffset: ():number=>{ return this.getListOffset() },// MyScroller刷新List组件的yOffset
      })
    }
  }
  /**
   * 文章详情
   */
  @Builder
  PostDetailBuilder() {
    PostDetail({post: this.post})
  }

  /**
   * 弹窗函数
   */
  showToast() {
    promptAction.showToast({
      message: $r('app.string.container_nested_only_show_for_ux')
    })
  }

  // 评论标题行
  @Builder
  CommentTitle() {
    Row() {
      Text($r('app.string.container_nested_comment_text'))
        .fontSize(CommonConstants.FONTSIZE_TWENTY)
        .fontWeight(FontWeight.Bold)

      Blank()

      Text($r('app.string.container_nested_comment1_text'))
        .fontSize(CommonConstants.FOUR_TEEN_FONTSIZE)
        .fontWeight(FontWeight.Bold)
    }
    .width(CommonConstants.NINETY_FIVE_PERCENT)
    .height(CommonConstants.ROW_HEIGHT)
    .onClick(()=>{
      this.showToast();
    })
  }

  /**
   * MyScroller组件滑动List
   */
  scrollList(offset:number){
    this.listScroller.scrollBy(0, offset);
  }

  /**
   * MyScroller获取List组件的yOffset
   */
  getListOffset():number{
    return this.listScroller.currentOffset().yOffset;
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Tabs({ barPosition: BarPosition.Start, controller: this.topController, index: this.topSelect }) {
        TabContent() {
          this.Body()
        }
        TabContent() {
          // PostComment()
          this.Comment()
        }
      }
      .barHeight(0)
      .margin({ top: 38 })
      // .backgroundColor(Color.Brown)
      .scrollable(true)
      .onChange((index: number) => {
        this.topSelect = index
      })

      this.TopBar()
    }
  }
}
