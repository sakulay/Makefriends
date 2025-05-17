import { router } from "@kit.ArkUI"
import promptAction from '@ohos.promptAction'
import { disconnect } from "../../model/MessageModel"
import common from '@ohos.app.ability.common'
import { getStudentId } from '../../utils/utils'
import { deleteUser } from '../../api/userApi'

@Entry
@Component
struct DeleteAccount {
  @State isLoading: boolean = false
  private studentId: string = getStudentId()

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(24)
          .margin({ left: 12 })
          .onClick(() => {
            router.back()
          })
        Text('注销账号')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 12 })
        Blank()
      }
      .width('100%')
      .height(48)
      .backgroundColor('#FFFFFF')
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 提示内容
      Column() {
        Image($r('app.media.ic_warning'))
          .width(64)
          .height(64)
          .margin({ top: 32, bottom: 16 })

        Text('注销账号')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#333333')
          .margin({ bottom: 16 })

        Text('注销账号后，您的账号将被永久删除，且无法恢复。请谨慎操作！')
          .fontSize(14)
          .fontColor('#666666')
          .textAlign(TextAlign.Center)
          .margin({ bottom: 32 })
          .padding({ left: 32, right: 32 })

        // 注销按钮
        Button('确认注销', { type: ButtonType.Normal })
          .width('100%')
          .height(48)
          .backgroundColor('#FF6B6B')
          .fontColor(Color.White)
          .fontSize(16)
          .borderRadius(24)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.showConfirmDialog()
          })
      }
      .width('100%')
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)
      .margin({ top: 12 })
      .borderRadius(16)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F8F8F8')
  }

  private showConfirmDialog() {
    AlertDialog.show({
      title: '确认注销',
      message: '注销后账号将无法恢复，是否确认注销？',
      primaryButton: {
        value: '取消',
        action: () => {
          // 取消操作
        }
      },
      secondaryButton: {
        value: '确认注销',
        action: () => {
          this.handleDelete()
        }
      }
    })
  }

  private handleDelete() {
    this.isLoading = true
    deleteUser(this.studentId)
      .then(() => {
        promptAction.showToast({ message: '账号注销成功' })
        AppStorage.delete('auth')
        disconnect()
        router.pushUrl({ url: 'pages/Login' })
        router.clear()
      })
      .catch((error: string) => {
        promptAction.showToast({ message: error || '账号注销失败' })
      })
      .finally(() => {
        this.isLoading = false
      })
  }
} 