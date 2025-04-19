import { PromptAction, router } from '@kit.ArkUI';
import { addFriendRequest, FriendRequestForm, searchFriend } from '../../api/friendsApi';
import { PersonalInfo } from '../../utils/Mock';
import { showBottomError } from '../../utils/toast';
import { AuthenticationToken } from '../../viewmodel/AuthModel';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';

@Entry
@Component
struct AddFriends {
  // @State status: number = 2
  @State text: string = '添加'
  // @State info: PersonalInfo = new PersonalInfo(2101510218, 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '林键超', '我自横刀向天笑，去留肝胆两昆仑', 1)
  @State info: UserSimpleInfo = new UserSimpleInfo('2101510218','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1)
  // @State info?: UserSimpleInfo = undefined
  @State studentId: string = '14'
  @State friendId: string = ''
  private uiContext: UIContext = this.getUIContext()
  private promptAction: PromptAction = this.uiContext.getPromptAction()

  aboutToAppear(): void {
    const auth = AppStorage.get("auth") as AuthenticationToken
    if(auth) this.studentId = auth.studentId
  }

  onPageShow(): void {
    console.log('onPageShow')
    let params = router.getParams() as UserSimpleInfo;
    if (params) {
      console.log("add"+ JSON.stringify(params))
      this.info = params // 更新 A 页面状态
      // this.status = params.status
      this.info.status = params.status
      this.text = '待处理'
    }
  }
  // 根据状态计算颜色
  computedColor(status: number): Color {
    if(status == 0) {
      return Color.Gray
    } else if(status == 1) {
      return Color.Gray
    } else {
      return Color.Black
    }
  }
  computedText(status: number) {
    if(status == 0) {
      return '待处理'
    } else if(status == 1) {
      return '已添加'
    } else {
      return '添加'
    }
  }
  // 处理添加按钮点击事件
  handleClick() {
    if(this.info) {
      if(this.info.status == 0) {
        this.showToast('已提交好友申请，请勿重复申请')
      } else if(this.info.status == 1) {
        this.showToast('对方已是你的好友，不能重复添加')
      } else {
        addFriendRequest(new FriendRequestForm(this.studentId, this.info.studentId)).then(()=>{
          this.info.status = 0
          this.text = "待处理"
          this.showToast('已发送好友申请')
        }).catch((error: string) => {
          showBottomError(this.getUIContext(), error)
        })
      }
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

  // 方法：检查输入是否为数字
  private checkIfNumber(value: string): boolean {
    const regex = /^\d+$/;
    return regex.test(value);
  }

  @Builder
  TopBar() {
    Row({space: 10}) {
      Image($r('app.media.ic_left_arrow'))
        .width(25)
        .height(25)
        .onClick(()=>{
          router.back()
        })
      TextInput({text: this.friendId, placeholder: '学号'})
        .onChange((value: string) => {
          this.friendId = value;
        })
        .layoutWeight(1)
      Text("搜索")
        .fontColor(Color.Blue)
        .onClick(() => {
          // 检查输入学号是否合法
          if(this.checkIfNumber(this.friendId)) {
            searchFriend(this.studentId, this.friendId).then((res: UserSimpleInfo)=>{
              this.info = res
            }).catch((error: string) => {
              showBottomError(this.getUIContext(), error)
            })
          } else {
            showBottomError(this.getUIContext(), '请输入正确的学号')
          }
        })
    }
    .width('100%')
    .padding(10)
    .backgroundColor(Color.White)
  }

  @Builder
  NoMore() {
    Row() {
      Text("没有更多了")
        .fontColor('#ff8a8a8a')
    }
    .height(60)
  }

  @Builder
  SearchItem() {
    if(this.info) {
      Row(){
        // 头像展示
        Column() {
          Image(this.info.avatar)
            .width(70)
            .height(70)
            .borderRadius(25)
        }
        // 昵称、学号
        Column() {
          Text(this.info.nickname)
            .fontSize(25)
          Text(this.info.studentId.toString())
        }
        .layoutWeight(1)
        .height(60)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .margin({top: 7, left: 10})
        // .backgroundColor(Color.Green)
        // 右侧
        Column() {
          Image($r('app.media.ic_right_arrow'))
            .width(20)
            .height(15)
          // .margin({bottom: 5})
          // 如果查询对象是自己，则不显示按钮
          if(this.info.studentId != this.studentId) {
            Row() {
              Text(this.computedText(this.info.status as number))
                .fontColor(this.computedColor(this.info.status as number))
                .onClick(()=>{
                  this.handleClick()
                })
            }
            .width(60)
            .height(30)
            .margin({top: 15})
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#f1f1f1')
            .border({width: 1, color: Color.Gray})
          }
        }
        .height(80)
        // .backgroundColor(Color.Brown)
        .justifyContent(FlexAlign.Center)
      }
      .width('93%')
      .height(110)
      .padding(15)
      .margin({top: 15})
      .backgroundColor(Color.White)
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.SpaceBetween)
      .borderRadius(10)
      .onClick(()=>{
        // this.info.status = this.status
        router.pushUrl({
          url: 'pages/friends/InfoCard',
          params: this.info
        })
      })
    }
  }
  build() {
    Column() {
      this.TopBar()
      this.SearchItem()
      this.NoMore()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f1f1')
  }
}