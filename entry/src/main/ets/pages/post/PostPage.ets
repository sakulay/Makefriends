import { Post, PostList, TopItem } from '../../utils/Mock';
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
import { PostModel } from '../../api/postApi';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';
import { showTopToast } from '../../utils/toast';
import { AddComment, CommentForm,
  CommentModel,
  CommentQuery, getCommentPageById, saveAppPostComment } from '../../api/commentApi';
import { Page } from '../../api/friendsApi';
import { it } from '@ohos/hypium';
import { getStudentId } from '../../utils/utils';
import { CommentEmptyPage } from '../components/CommentEmptyPage';
import { Loading } from '../components/Loading';

@Entry
@Component
struct PostPage {
  // @State post: Post = new Post(1,1,'','','','',[],1,0,'')
  @State loading: boolean = true
  private LOG = '[PostPage]'
  private index = 1000
  @State post: PostModel = new PostModel(
    3,
    14,
    '标题3',
    '内容3',
    [],
    50, 60, '2025-02-25 12:00:00',
    new UserSimpleInfo(
      '14',
      '林键超',
      'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg',
      '我自横刀向天笑，去留肝胆两昆仑',
      '',
      1
    ))
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
    let params = router.getParams() as PostModel
    if(params) {
      this.post = params
    }
    // 添加模拟数据
    // this.commentList = mockData();
    getCommentPageById(new CommentQuery(1, 10, this.post.id)).then((res: Page<CommentModel>) => {
      console.log(this.LOG, `获取评论列表成功 ${JSON.stringify(res.list)}`)
      // 将获取到的评论列表数据赋值给 commentList
      res.list.forEach((item: CommentModel) => {
        let comment = new NewsCommentModel(item.id, item.url, item.user, item.replyId, item.replyUser, item.text, item.commentTime, item.likeCount,
          new NewsCommentData()
        );
        if(item.replyList) {
          item.replyList.forEach((reply: CommentModel) => {
            let replyComment = new NewsCommentModel(reply.id, reply.url, reply.user, reply.replyId, reply.replyUser, reply.text, reply.commentTime, reply.likeCount,
              new NewsCommentData()
            );
            comment.replyList.pushData(replyComment)
         })
        }
        this.commentList.pushData(comment)
      })
      // 评论加载完成
      this.loading = false
    }).catch((err: string) => {
      // 评论加载完成
      this.loading = false
      console.log(this.LOG, `获取评论列表失败 ${JSON.stringify(err)}`)
    })
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
  @Builder listBuilder(height: string) {
    if(this.loading) {
      Loading({h: "60%"})
    } else if(this.commentList.totalCount() == 0) {
      CommentEmptyPage({H: "60%"})
    } else {
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
      // .height(CommonConstants.FULL_PERCENT)
      .height(height)
      .constraintSize({minHeight: "60%"})
      .backgroundColor($r('app.color.container_nested_note_nested_list_bgc_color'))
      .id('commentList')
    }
  }

  /**
   * 评论
   */
  @Builder
  Comment() {
    Column() {
      if(this.loading) {
        Loading()
      } else if(this.commentList.totalCount() == 0) {
        CommentEmptyPage()
      } else {
        MyScroller({
          listBuilder: () => {this.listBuilder("100%")},
          titleBuilder: () => {this.CommentTitle()},
          isWebAtEnd: $isWebAtEnd, // 传递Web组件是否滚动到下边界
          scrollList: (offset:number)=>{ this.scrollList(offset) }, // MyScroller组件滑动List
          getListOffset: ():number=>{ return this.getListOffset() },// MyScroller刷新List组件的yOffset
        })
      }
    }
  }

  /**
   * 发布评论
   */
  publishComment(): void {
    // 生成评论id
    // const uuid: string = util.generateRandomUUID();
    const uuid: string = this.index.toString();
    this.index++
    console.log(this.LOG, `uuid: ${uuid}`)
    // 添加一条评论，包含评论id、头像、昵称、回复id、回复昵称、回复文本
    const comment: NewsCommentModel =
      new NewsCommentModel(uuid, this.post.userInfo.avatar, this.post.userInfo.nickname, this.replyId, this.replyUser,
        this.textInComment, new Date(), 0, new NewsCommentData());
    // 通过回复id获取该评论的父评论
    console.log(this.LOG, this.replyId)
    const parentComment = this.commentList.getParentData(this.replyId);
    // 如果获取到了父评论，则将该评论加到父评论下
    if (this.replyId && parentComment) {
      console.log(`回复${this.replyId} ${this.replyUser} ${JSON.stringify(parentComment)}`)
      const form = new CommentForm(getStudentId(), this.replyId, this.post.id.toString(), this.textInComment, 1);
      saveAppPostComment(form).then((res: AddComment) => {
        console.log(this.LOG, `评论成功 ${JSON.stringify(res)}`)
        if (res.id) {
          comment.id = res.id;
          comment.userInfo = res.userInfo;
        }
        parentComment.replyList.addDataFirst(comment);
      }).catch((err: string) => {
        console.log(this.LOG, `评论失败 ${JSON.stringify(err)}`)
      })

    } else {
      // 否则自己作为父评论。回复id为文章id
      // this.replyId = this.post.id.toString();
      console.log(`评论${this.replyId} ${this.replyUser} ${JSON.stringify(parentComment)}`)
      const form = new CommentForm(getStudentId(), '', this.post.id.toString(), this.textInComment, 0);
      saveAppPostComment(form).then((res: AddComment) => {
        console.log(this.LOG, `评论成功 ${JSON.stringify(res)}`)
        if (res.id) {
          comment.id = res.id;
          comment.userInfo = res.userInfo;
        }
        this.commentList.addDataFirst(comment);
      }).catch((err: string) => {
        console.log(this.LOG, `评论失败 ${JSON.stringify(err)}`)
      })

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
        .fontWeight(FontWeight.Bold)
        .fontColor(this.topSelect === index ? $r('app.color.blue_theme_2') : '#000')
      Divider()
        .strokeWidth(2)
        .color($r('app.color.blue_theme_2'))
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
      MyScroller({
        detailBuilder: () => {this.PostDetailBuilder()},
        listBuilder: () => {this.listBuilder("auto")},
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
    if(this.listScroller.currentOffset()) {
      return this.listScroller.currentOffset().yOffset;
    }
    return 0;
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
