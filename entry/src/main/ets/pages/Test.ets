// pages/DownloadImage.ets
import { common } from "@kit.AbilityKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { http } from "@kit.NetworkKit";
import { promptAction } from '@kit.ArkUI';

/** 保存图片至相册 */
async function savePhotoToGallery(context: common.UIAbilityContext) {
  let helper = photoAccessHelper.getPhotoAccessHelper(context);
  try {
    // onClick触发后10秒内通过createAsset接口创建图片文件，10秒后createAsset权限收回。
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
    let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // $r('app.media.startIcon')需要替换为开发者所需的图像资源文件
    context.resourceManager.getMediaContent(
      $r('app.media.pic4').id,
      0)
      .then(async value => {
        let media = value.buffer;
        // 写到媒体库文件中
        await fileIo.write(file.fd, media);
        await fileIo.close(file.fd);
        promptAction.showToast({ message: '已保存至相册！' });
      });
  }
  catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to save photo. Code is ${err.code}, message is ${err.message}`);
  }
}


@Entry
@Component
struct SaveImagePage {
  @State imageUrl: string = ''
  @State isSaving: boolean = false

  // 验证URL是否为有效的图片URL
  // private isValidImageUrl(url: string): boolean {
  //   if (!url) return false
  //   try {
  //     const urlObj = new URL(url)
  //     const ext = urlObj.pathname.split('.').pop()?.toLowerCase()
  //     return ['jpg', 'jpeg', 'png', 'gif', 'webp'].includes(ext)
  //   } catch {
  //     return false
  //   }
  // }

  async handleSaveImage(context: common.UIAbilityContext, imageData: ArrayBuffer) {
    try {
      const helper = photoAccessHelper.getPhotoAccessHelper(context)
      // onClick触发后10秒内通过createAsset接口创建图片文件
      const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg')
      // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
      const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)

      try {
        await fileIo.write(file.fd, imageData)
        promptAction.showToast({ 
          message: '✅ 图片已保存至相册',
          duration: 2000 
        })
      } finally {
        await fileIo.close(file.fd)
      }
    } catch (error) {
      const err = error as BusinessError
      console.error('[SaveImage] Save failed:', err)
      promptAction.showToast({ 
        message: `保存失败: ${err.message || '未知错误'}`,
        duration: 3000 
      })
    }
  }

  async downloadImage(url: string): Promise<ArrayBuffer | null> {
    const httpRequest = http.createHttp()
    try {
      const response = await httpRequest.request(url, {
        method: http.RequestMethod.GET,
        readTimeout: 10000,
        connectTimeout: 5000,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      })

      if (!response.result || !response.responseCode.toString().startsWith('2')) {
        throw new Error(`下载失败: ${response.responseCode}`)
      }

      const imageData = response.result as ArrayBuffer
      if (!imageData.byteLength) {
        throw new Error('下载的图片数据为空')
      }

      return imageData
    } catch (error) {
      console.error('[SaveImage] Download failed:', error)
      promptAction.showToast({ 
        message: '图片下载失败，请检查URL是否正确',
        duration: 3000 
      })
      return null
    } finally {
      httpRequest.destroy()
    }
  }

  build() {
    Column({ space: 20 }) {
      Text('输入图片地址:')
        .fontSize(18)
        .fontColor('#333333')

      TextInput({
        placeholder: '请输入图片URL (支持jpg/png/gif)',
        text: this.imageUrl
      })
        .width('90%')
        .height(40)
        .backgroundColor('#f5f5f5')
        .borderRadius(8)
        .padding({ left: 12, right: 12 })
        .onChange((value) => {
          this.imageUrl = value
        })

      SaveButton({ 
        icon: SaveIconStyle.FULL_FILLED
      })
        .borderRadius(90)
        .iconSize(19)
        .height(40)
        .backgroundColor('#317aff')
        .onClick(async (event, result) => {
          if (result === SaveButtonOnClickResult.SUCCESS) {
            if (!this.imageUrl) {
              promptAction.showToast({ message: '请输入图片URL' })
              return
            }

            if (this.isSaving) {
              promptAction.showToast({ message: '正在保存中，请稍候...' })
              return
            }

            this.isSaving = true
            try {
              const context = getContext(this) as common.UIAbilityContext
              const imageData = await this.downloadImage(this.imageUrl)
              if (imageData) {
                await this.handleSaveImage(context, imageData)
              }
            } finally {
              this.isSaving = false
            }
          } else {
            promptAction.showToast({ 
              message: '未获得存储权限，无法保存图片',
              duration: 3000 
            })
          }
        })
    }
    .width('100%')
    .height('100%')
    .padding(20)
    .backgroundColor('#FFFFFF')
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
  }
}