import { PromptAction, router } from "@kit.ArkUI"
import { PostCard } from "../components/PostCard"
import { PersonalInfo, Post, PostList } from "../../utils/Mock"
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel"
import { getRecPostList, PostModel, PostQuery } from "../../api/postApi"
import { EmptyPage } from "../components/EmptyPage"
import { showBottomError } from "../../utils/toast"
import { addFriendRequest, FriendRequestForm, Page, passFriendRequest, rejectFriendRequest } from "../../api/friendsApi"
import { getStudentId } from "../../utils/utils"

@Entry
@Component
export struct InfoCard {
  private LOG = "[InfoCard]"
  @State status: number = 1
  @State text: string = '发消息'
  // @State info: PersonalInfo = new PersonalInfo(2101510218, 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '林键超', '我自横刀向天笑，去留肝胆两昆仑', 1)
  @State info: UserSimpleInfo = new UserSimpleInfo('2101510218','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1)
  @State postList: PostModel[] = []
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()

  async aboutToAppear(): Promise<void> {
    let params = router.getParams() as UserSimpleInfo
    console.log(`${this.LOG} 传入参数：`, JSON.stringify(params))
    this.status = params.status as number
    this.info = params
    this.handleStatus()
    const queryParam = new PostQuery(1, 10, 1, Number(this.info.studentId))
    try {
      const res = await getRecPostList(queryParam) as Page<PostModel>
      console.log(`[InfoCard] 获取学生${this.info.studentId}帖子成功: `, JSON.stringify(res.list))
      this.postList = res.list
    } catch(err) {
      console.error(this.LOG, ' 获取推荐帖子失败: ', err)
      showBottomError(this.getUIContext(), err)
    }
  }
  // 判断是否是自己
  isMyself() {
    const isMyself:Boolean = this.info.studentId == getStudentId()
    console.log(`[InfoCard] 判断是否是自己： ${isMyself}`)
    return isMyself
  }
  // 处理状态
  handleStatus() {
    if(this.status == 0) {
      this.text = '待处理'
    } else if(this.status == 1) {
      this.text = '发消息'
    } else {
      this.text = '添加好友'
    }
  }
  // 显示提示信息
  showToast(msg: string) {
    this.promptAction.showToast({
      message: msg,
      duration: 1000,
      alignment: Alignment.Top,
      shadow: ShadowStyle.OUTER_FLOATING_SM
    })
  }
  // 处理点击事件
  handleClick() {
    if(this.status == 0) {
      this.showToast('已提交好友申请，请耐心等待')
    } else if(this.status == 1) {
      // this.showToast('跳转到发送消息页面')
      AppStorage.set("selectedChat", this.info.studentId)
      router.pushUrl({url: 'pages/chat/ChatPage'})
    } else {
      addFriendRequest(new FriendRequestForm(getStudentId(), this.info.studentId)).then(()=>{
        this.status = 0
        this.info.status = 0
        this.text = '待处理'
        this.showToast('添加好友成功')
      }).catch((error: string) => {
        showBottomError(this.getUIContext(), error)
      })
    }
  }
  // 处理同意按钮点击事件
  handlePassClick() {
    passFriendRequest(this.info.requestId as string).then(() => {
      this.status = 1
      this.handleStatus()
      this.showToast('已通过好友申请')
    }).catch((error: string) => {
      showBottomError(this.getUIContext(), error)
    })
  }
  // 处理拒绝按钮点击事件
  handleRejectClick() {
    rejectFriendRequest(this.info.requestId as string).then(() => {
      this.status = 2
      this.handleStatus()
      this.showToast('已拒绝好友申请')
    }).catch((error: string) => {
      showBottomError(this.getUIContext(), error)
    })

  }
  @Builder
  Info() {
    // 顶部
    Row(){
      // 头像展示
      Column() {
        Image(this.info.avatar)
          .width(70)
          .height(70)
          .borderRadius(25)
      }
      // 用户名、学号
      Column() {
        // 昵称
        Text(this.info.nickname)
          .fontSize(25)
        // 学号
        Text("学号：" + this.info.studentId.toString())
          .fontColor(Color.Gray)
      }
      .width(220)
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(HorizontalAlign.Start)
      .margin({left: 15})
    }
    .width('100%')
    .height(140)
    .padding({top: 45, left: 15, right: 15})
    .backgroundColor(Color.White)
    .alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start)
    // 个性签名
    Row() {
      Text(this.info.bio)
        .margin({left: 7})
        .backgroundColor(Color.White)
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
    .backgroundColor(Color.White)
    .margin({top: 5})
    .border({width: {top: 1}, color: '#ffe9e9e9'})
    .padding({top: 15, left: 15, right: 15, bottom: 10})
  }
  // 底部按钮
  @Builder
  bottom() {
    Row(){
      Row(){
        Text(this.text)
      }
      .width("80%")
      .height(40)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f1f1f1')
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .onClick(()=>{
      this.handleClick()
    })
  }

  @Builder
  requestBottom() {
    Row({space: 10}){
      Row(){
        Text("拒绝")
      }
      .width("40%")
      .height(40)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f1f1f1')
      .onClick(()=>{
        this.handleRejectClick()
      })
      Row(){
        Text("同意")
      }
      .width("40%")
      .height(40)
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#f1f1f1')
      .onClick(()=> {
        this.handlePassClick()
      })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
    .onClick(()=>{
    })
  }

  @Builder
  top() {
    Row() {
      Image($r("app.media.ic_left_arrow"))
        .width(25)
        .height(25)
        .onClick(()=>{
          // 检查info的status是否是4，如果是则替换成0返回
          if(this.info.status == 4) {
            this.info.status = 0
          }
          router.back(Number(router.getLength())-1, this.info)
          // router.replaceUrl({url: 'pages/friends/AddFriends', params: this.info})
        })
    }
    .padding(10)
  }

  @Builder
  myPostList() {
    ForEach(this.postList, (item: PostModel)=>{
      PostCard({item: item})
    }, (item: PostModel) => item.id.toString())
  }

  build() {
    Stack({alignContent: Alignment.TopStart}) {
      Column() {
        Scroll() {
          Column() {
            // 个人信息
            this.Info()
            // 图文动态
            if(this.postList.length == 0) {
              EmptyPage({H: "70%"})
            } else {
              Column() {
                this.myPostList()
              }
              .backgroundColor(Color.White)
              .margin({top: 15})
            }
          }
          .constraintSize({minHeight: '100%'})
          .justifyContent(FlexAlign.Start)
        }
        .scrollBarWidth(0)
        .layoutWeight(1)
        /** 底部
         * 如果是自己的信息，则不显示底部按钮
         * 如果status为4，则切换requestBottom
         * */
        if(!this.isMyself()) {
          if(this.status == 4) {
            this.requestBottom()
          } else {
            this.bottom()
          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#f1f1f1')
      .justifyContent(FlexAlign.SpaceBetween)


      // 顶部返回按钮
      this.top()
    }
  }
}