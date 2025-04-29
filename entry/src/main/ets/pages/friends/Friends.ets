import router from '@ohos.router'
import { getFriendsList } from '../../api/friendsApi'
import { getStudentId } from '../../utils/utils'
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel'


@Entry
@Component
export struct Friends {
  private LOG = "[Friends] "
  @State friends: Array<UserSimpleInfo> = [
    new UserSimpleInfo('','','','')
  ]
  @State searchText: string = ''
  @State isSearching: boolean = false
  @State filteredFriends: Array<UserSimpleInfo> = []
  @State isSearchActive: boolean = false  // 控制搜索状态
  // 创建一个引用，用来控制 TextInput
  controller: TextInputController = new TextInputController()
  //焦点控制的key
  private focusKey: string = "oneKey";
  @State searchWidth: number = 0.8  // 控制搜索框宽度比例
  @State searchPosition: number = 0.5  // 控制搜索框位置，0.5表示居中，0表示靠左


  async aboutToAppear(): Promise<void> {
    this.onPageShow()
  }

  onPageShow() {
    console.log(`${this.LOG} 页面展示`)
    const studentId = getStudentId();
    getFriendsList(studentId).then(res=>{
      console.log(this.LOG, '获取好友列表成功: ', JSON.stringify(res))
      this.friends = res.list
      this.filteredFriends = res.list
    }).catch((err: string)=>{
      console.error(this.LOG, '获取好友列表失败: ', err)
    })
  }

  // 搜索好友
  searchFriends(text: string) {
    this.searchText = text
    if (!text) {
      this.filteredFriends = this.friends
      return
    }
    this.filteredFriends = this.friends.filter(friend => 
      friend.nickname.toLowerCase().includes(text.toLowerCase()) ||
      friend.bio?.toLowerCase().includes(text.toLowerCase())
    )
  }

@Builder
SearchBar() {
  Stack() {
    Row() {
      Row() {
        Image($r('app.media.ic_search'))
          .width(20)
          .height(20)
          .opacity(0.4)
        TextInput({
          placeholder: this.isSearchActive ? '' : '搜索好友',
          controller: this.controller
        })
          .width('100%')
          .height(40)
          .backgroundColor('transparent')
          .fontSize(14)
          .fontColor('#333')
          .placeholderColor('#999')
          .enableKeyboardOnFocus(true)
          .key(this.focusKey)
          .onFocus(() => {
            this.isSearchActive = true
          })
          .onBlur(() => {
            if (!this.searchText) {
              this.isSearchActive = false
            }
          })
          .onChange((value: string) => {
            this.searchFriends(value)
          })
      }
      .width('100%')
      .height(40)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .position({ x: this.isSearchActive ? 0 : '40%' })
      .animation({
        duration: 300,
        curve: Curve.EaseOut
      })
    }
    .width('100%')
    .height(40)
    .backgroundColor('#F5F5F5')
    .borderRadius(20)
    .padding({ left: 0, right: 16 })
    .margin({ top: 12, bottom: 12 })
  }
  .width('100%')
  .height(64)
  .onClick(() => {
    if (!this.isSearchActive) {
      this.controller.getCaretOffset()
      console.log(this.LOG, "statck")
      focusControl.requestFocus(this.focusKey)
      this.isSearchActive = true
    }
  })
}

  @Builder
  friendsList() {
    ForEach(this.filteredFriends, (item: UserSimpleInfo, index)=>{
      Row() {
        Stack() {
          Circle()
            .width(52)
            .height(52)
            .stroke('#E0E0E0')
            .strokeWidth(1)
          Image(item.avatar)
            .width(50)
            .height(50)
            .borderRadius(25)
            .backgroundColor('#F5F5F5')
        }
        Column() {
          Text(item.nickname)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333')
          Text(item.bio || '这个人很懒，什么都没写~')
            .fontSize(14)
            .fontColor('#999')
            .margin({ top: 4 })
        }
        .margin({ left: 12 })
        .height(50)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height(70)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .borderRadius(8)
      .margin({ bottom: 8 })
      .animation({
        duration: 300,
        curve: Curve.EaseOut,
        delay: index * 50
      })
      .onClick(()=>{
        router.pushUrl({
          url: 'pages/friends/InfoCard',
          params: item
        })
      })
    })
  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Text("好友列表")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333')
        Row({space: 20}) {
          Image($r('app.media.ic_notices'))
            .width(24)
            .height(24)
            .onClick(()=>{
              router.pushUrl({url: 'pages/friends/FriendRequest'})
            })
          Image($r('app.media.ic_add_friend_2'))
            .width(24)
            .height(24)
            .onClick(()=>{
              router.pushUrl({url: 'pages/friends/AddFriends'})
            })
        }
      }
      .height(56)
      .width('100%')
      .backgroundColor(Color.White)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding({ left: 16, right: 16 })

      // 主体内容
      Scroll() {
        Column() {
          // 搜索栏容器
          Row() {
            this.SearchBar()
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)

          // 搜索结果提示
          if (this.searchText && this.filteredFriends.length === 0) {
            Row() {
              Text('未找到相关好友')
                .fontSize(14)
                .fontColor('#999')
            }
            .width('100%')
            .height(40)
            .justifyContent(FlexAlign.Center)
            .margin({ bottom: 12 })
          }

          // 好友列表
          this.friendsList()
        }
        .width('100%')
        .constraintSize({minHeight: '100%'})
        .padding({ left: 12, right: 12, bottom: 12 })
      }
      .width('100%')
      .layoutWeight(1)
      .scrollBar(BarState.Off)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
    .onClick(() => {
      if (this.isSearchActive && !this.searchText) {
        this.controller.stopEditing()
        this.isSearchActive = false
      }
    })
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        this.onPageShow()
      }
    })
  }
}