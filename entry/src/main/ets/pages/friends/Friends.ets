import { router } from "@kit.ArkUI"
import { it } from "@ohos/hypium"
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel"
import { getFriendsList } from "../../api/friendsApi"
import { PersonalInfo } from "../../utils/Mock"
import { getStudentId } from "../../utils/utils"


@Entry
@Component
export struct Friends {
  private LOG = "[Friends] "
  @State friends: Array<UserSimpleInfo> = [
    new UserSimpleInfo('','','','')
  ]

  async aboutToAppear(): Promise<void> {
    // const info = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
    // console.log('获取个人信息成功: ', JSON.stringify(info))
  }

  // async onPageShow(): Promise<void> {
  //   console.log(`${this.LOG} 页面展示`)
  //   const studentId = getStudentId();
  //   // const studentId = "14"
  //   try{
  //     const res = await getFriendsList(studentId)
  //     console.log(this.LOG, '获取好友列表成功: ', JSON.stringify(res))
  //     this.friends = res.list
  //   }catch(err){
  //     console.error(this.LOG, '获取好友列表失败: ', err)
  //   }
  // }
  onPageShow() {
    console.log(`${this.LOG} 页面展示`)
    const studentId = getStudentId();
    // const studentId = "14"
    getFriendsList(studentId).then(res=>{
      console.log(this.LOG, '获取好友列表成功: ', JSON.stringify(res))
      this.friends = res.list
    }).catch((err: string)=>{
      console.error(this.LOG, '获取好友列表失败: ', err)
    })
  }

  @Builder
  friendsList() {
    ForEach(this.friends, (item: UserSimpleInfo, index)=>{
      Row() {
        Image(item.avatar)
          .width(50)
          .height(50)
          .borderRadius(25)
          .border({ width: 1, color: Color.Gray })
        Column() {
          Text(item.nickname)
            .fontSize(16)
            .fontWeight(FontWeight.Bold)

          Text(item.bio)
            .fontSize(14)
        }
        .margin({ left: '10' })
        .height(45)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.SpaceBetween)
      }
      .width('100%')
      .padding({left: 10, right: 10, top: 10, bottom: 5})
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
      // 顶部
      Row() {
        Text("好友列表")
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
        Row({space: 15}) {
          Image($r('app.media.ic_notices'))
            .width(27)
            .height(27)
            .margin({bottom: 3})
            .onClick(()=>{
              router.pushUrl({url: 'pages/friends/FriendRequest'})
            })
          Image($r('app.media.ic_add_friend_2'))
            .width(30)
            .height(30)
            .onClick(()=>{
              router.pushUrl({url: 'pages/friends/AddFriends'})
            })
        }

      }
      .height(50)
      .width('100%')
      // .backgroundColor(Color.Gray)
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(15)

      // 好友列表
      Scroll() {
        Column() {
          // 搜索栏
          Row() {
            Image($r('app.media.ic_search'))
              .width(30)
              .height(30)
            Text("搜索")
          }
          .width('100%')
          .backgroundColor('#f5f5f5')
          .justifyContent(FlexAlign.Center)
          .padding(5)
          // 加载好友列表
          // Text(JSON.stringify(this.friends))
          this.friendsList()
        }
        .justifyContent(FlexAlign.Start)
        .width('100%')
        .padding({bottom: 10})
        .constraintSize({minHeight: '100%'})
        // .backgroundColor(Color.Green)
      }
      // .backgroundColor(Color.Brown)
      .layoutWeight(1)


    }
    // .justifyContent(FlexAlign.Start)
    .height('100%')
    .width('100%')
    // 根据显示区域判断
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        // 调用自定义的show方法
        this.onPageShow()
      } else if (currentRatio == 0.0) {
        // 调用自定义的hide方法
      }
    })
  }
}