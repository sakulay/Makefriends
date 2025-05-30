import { router } from "@kit.ArkUI"
import { logout } from "../../api/authApi"
import { disconnect } from "../../model/MessageModel"
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel"

@Entry
@Component
export struct Mine {
  private LOG = "[Mine] "
  @State userSimpleInfo: UserSimpleInfo = new UserSimpleInfo('2101510218', '林键超', 'http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg','')
  aboutToAppear(): void {
    const info = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
    console.log(this.LOG,"aboutToAppear拿到个人数据：", JSON.stringify(info))
    if(info) this.userSimpleInfo = info
  }

  onPageShow(): void {
    const params = router.getParams()
    console.log('[Mine] onPageShow拿到路由参数：', JSON.stringify(params))
    if(params) {
      const info = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
      if(info) this.userSimpleInfo = info
    }
  }

  @Builder
  Default() {
    Row() {
      Column() {
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill('#F5F5F5')
          Image($r('app.media.ic_post_bold'))
            .height(24)
            .width(24)
        }
        Text('我的帖子')
          .fontSize(13)
          .fontColor('#666')
          .margin({ top: 4 })
      }
      .onClick(() => {
        // 点击处理
        router.pushUrl({
          url: 'pages/post/MinePost'
        })
      })

      Column() {
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill('#F5F5F5')
          Image($r('app.media.ic_history_black'))
            .height(24)
            .width(24)
        }
        Text('浏览记录')
          .fontSize(13)
          .fontColor('#666')
          .margin({ top: 4 })
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/mine/BrowseRecord'
        });
      })

      Column() {
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill('#F5F5F5')
          Image($r('app.media.news_star'))
            .height(24)
            .width(24)
        }
        Text('我的收藏')
          .fontSize(13)
          .fontColor('#666')
          .margin({ top: 4 })
      }
      .onClick(() => {
        router.pushUrl({
          url: 'pages/mine/Favorites'
        })
      })

      Column() {
        Stack() {
          Circle()
            .width(48)
            .height(48)
            .fill('#F5F5F5')
          Image($r('app.media.ic_report_bold'))
            .height(24)
            .width(24)
            .opacity(0.7)
        }
        Text('我的举报')
          .fontSize(13)
          .fontColor('#666')
          .margin({ top: 4 })
      }
      .onClick(() => {
        // 点击处理
        router.pushUrl({
          url: 'pages/mine/Complaints'
        })
      })
    }
    .width('100%')
    .height(100)
    .padding({ left: 20, right: 20 })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }

  build() {
    Stack() {
      // 背景渐变
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor('#F8F8F8')

      Column() {
        // 顶部个人信息卡片
        Row() {
          // 头像展示
          Stack() {
            Circle()
              .width(64)
              .height(64)
              .stroke('#E0E0E0')
              .strokeWidth(1)
            
            Image(this.userSimpleInfo.avatar)
              .width(60)
              .height(60)
              .borderRadius(30)
              .backgroundColor('#F5F5F5')
          }
          .margin({ right: 12 })

          // 用户名、学号
          Column() {
            Text(this.userSimpleInfo.nickname)
              .fontSize(18)
              .fontWeight(FontWeight.Medium)
              .fontColor('#333')
              .margin({ bottom: 6 })
            Text('学号：' + this.userSimpleInfo.studentId)
              .fontSize(13)
              .fontColor('#999')
          }
          .width('100%')
          .height(60)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)

          Image($r('app.media.ic_right_arrow'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .height(80)
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .borderRadius({ topLeft: 16, topRight: 16 })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/mine/MineDetail',
            params: {
              studentId: this.userSimpleInfo.studentId
            }
          })
        })

        // 个性签名
        Row() {
          Text("个性签名：" + this.userSimpleInfo.bio)
            .fontSize(14)
            .fontColor('#666')
            .maxLines(1)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width('100%')
        .height(50)
        .padding({ left: 20, right: 20 })
        .backgroundColor(Color.White)
        .margin({ top: 1 })

        // 功能菜单
        Column() {
          this.Default()
        }
        .width('100%')
        .backgroundColor(Color.White)
        .margin({ top: 12 })
        .borderRadius(16)

        // 安全中心入口
        Row() {
          Image($r('app.media.ic_security'))
            .width(20)
            .height(20)
            .margin({ right: 8 })
          Text('安全中心')
            .fontSize(16)
            .fontColor('#333333')
          Blank()
          Image($r('app.media.ic_right_arrow'))
            .width(16)
            .height(16)
            .opacity(0.4)
        }
        .width('100%')
        .height(56)
        .margin({ top: 2 })
        .padding({ left: 16, right: 16 })
        .backgroundColor(Color.White)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/mine/SecurityCenter'
          })
        })
        // 退出登录按钮
        Button("退出登录", { type: ButtonType.Normal })
          .width('90%')
          .height(44)
          .margin({ top: 24 })
          .backgroundColor('#FF6B6B')
          .fontColor(Color.White)
          .fontSize(16)
          .borderRadius(22)
          .onClick(() => {
            logout().then((res) => {
              console.log('退出登录成功', res)
              AppStorage.delete('auth')
              disconnect()
              router.pushUrl({ url: 'pages/Login' })
              router.clear()
            })
          })

      }
      .width('100%')
      .height('100%')
      .padding({ top: 12 })
    }
    .width('100%')
    .height('100%')
    .onVisibleAreaChange([0.0, 1.0], (isVisible: boolean, currentRatio: number) => {
      if (isVisible && currentRatio == 1.0) {
        this.onPageShow()
      }
    })
  }
}