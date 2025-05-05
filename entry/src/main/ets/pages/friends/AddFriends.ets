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
  // @State info: UserSimpleInfo = new UserSimpleInfo('2101510218','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1)
  @State info?: UserSimpleInfo = undefined
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
          this.info!.status = 0
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
        .width(24)
        .height(24)
        .onClick(()=>{
          router.back()
        })
      TextInput({text: this.friendId, placeholder: '请输入学号'})
        .onChange((value: string) => {
          this.friendId = value;
        })
        .layoutWeight(1)
        .height(40)
        .backgroundColor('#F5F5F5')
        .borderRadius(20)
        .padding({left: 16, right: 16})
        .fontSize(16)
      Text("搜索")
        .fontColor('#007AFF')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
        .onClick(() => {
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
    .padding({left: 16, right: 16, top: 12, bottom: 12})
    .backgroundColor(Color.White)
    .shadow({ radius: 8, color: '#0000000A', offsetX: 0, offsetY: 2 })
  }

  @Builder
  NoMore() {
    Row() {
      Text("没有更多了")
        .fontColor('#999999')
        .fontSize(14)
    }
    .height(60)
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  SearchItem() {
    if(this.info) {
      Row(){
        Image(this.info.avatar)
          .width(64)
          .height(64)
          .borderRadius(32)
          .border({ width: 1, color: '#E8E8E8' })
          .shadow({ radius: 4, color: '#0000000A', offsetX: 0, offsetY: 2 })
        
        Column() {
          Text(this.info.nickname)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
          Text(this.info.studentId.toString())
            .fontSize(14)
            .fontColor('#666666')
            .margin({top: 4})
        }
        .layoutWeight(1)
        .height(64)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.Start)
        .margin({left: 12})

        Column() {
          Image($r('app.media.ic_right_arrow'))
            .width(16)
            .height(16)
            .opacity(0.5)
          
          if(this.info.studentId != this.studentId) {
            Row() {
              Text(this.computedText(this.info.status as number))
                .fontColor(this.computedColor(this.info.status as number))
                .fontSize(14)
                .fontWeight(FontWeight.Medium)
                .onClick(()=>{
                  this.handleClick()
                })
            }
            .width(70)
            .height(32)
            .margin({top: 12})
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F5F5F5')
            .borderRadius(16)
            .border({width: 1, color: '#E8E8E8'})
          }
        }
        .height(64)
        .justifyContent(FlexAlign.SpaceBetween)
        .alignItems(HorizontalAlign.End)
      }
      .width('100%')
      .height(96)
      .padding({left: 16, right: 16, top: 16, bottom: 16})
      .backgroundColor(Color.White)
      .margin({top: 1})
      .onClick(()=>{
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
    .backgroundColor('#F5F5F5')
  }
}