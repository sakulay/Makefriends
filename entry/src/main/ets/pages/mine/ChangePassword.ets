import { router } from "@kit.ArkUI"
import { updatePassword, UpdatePasswordForm } from "../../api/userApi"
import promptAction from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import { getStudentId } from '../../utils/utils'

@Entry
@Component
struct ChangePassword {
  @State oldPassword: string = ''
  @State newPassword: string = ''
  @State confirmPassword: string = ''
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
        Text('修改密码')
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

      // 表单内容
      Column() {
        // 旧密码输入框
        TextInput({ placeholder: '请输入旧密码', text: this.oldPassword })
          .type(InputType.Password)
          .width('100%')
          .height(48)
          .margin({ top: 16 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.oldPassword = value
          })

        // 新密码输入框
        TextInput({ placeholder: '请输入新密码', text: this.newPassword })
          .type(InputType.Password)
          .width('100%')
          .height(48)
          .margin({ top: 16 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.newPassword = value
          })

        // 确认密码输入框
        TextInput({ placeholder: '请确认新密码', text: this.confirmPassword })
          .type(InputType.Password)
          .width('100%')
          .height(48)
          .margin({ top: 16 })
          .backgroundColor('#F5F5F5')
          .borderRadius(8)
          .padding({ left: 16, right: 16 })
          .onChange((value: string) => {
            this.confirmPassword = value
          })

        // 提交按钮
        Button('确认修改', { type: ButtonType.Normal })
          .width('100%')
          .height(48)
          .margin({ top: 32 })
          .backgroundColor('#FF6B6B')
          .fontColor(Color.White)
          .fontSize(16)
          .borderRadius(24)
          .enabled(!this.isLoading)
          .onClick(() => {
            this.handleSubmit()
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

  private handleSubmit() {
    if (!this.oldPassword || !this.newPassword || !this.confirmPassword) {
      promptAction.showToast({ message: '请填写完整信息' })
      return
    }

    if (this.newPassword !== this.confirmPassword) {
      promptAction.showToast({ message: '两次输入的新密码不一致' })
      return
    }

    // if (this.newPassword.length < 6) {
    //   promptAction.showToast({ message: '新密码长度不能少于6位' })
    //   return
    // }

    this.isLoading = true
    const formData : UpdatePasswordForm = {
      studentId: parseInt(this.studentId),
      newPassword: this.newPassword,
      oldPassword: this.oldPassword
    }

    updatePassword(formData)
      .then(() => {
        promptAction.showToast({ message: '密码修改成功' })
        router.back()
      })
      .catch((error: string) => {
        promptAction.showToast({ message: error || '密码修改失败' })
      })
      .finally(() => {
        this.isLoading = false
      })
  }
} 