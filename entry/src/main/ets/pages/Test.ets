// pages/DownloadImage.ets
import { common } from "@kit.AbilityKit";
import { photoAccessHelper } from "@kit.MediaLibraryKit";
import { fileIo } from "@kit.CoreFileKit";
import { promptAction } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";
import { http } from "@kit.NetworkKit";

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
export struct DownloadImagePage {
  async  saveImageFromUrlToAlbum(imageUrl: string): Promise<void> {
    try {
      const context = getContext(this)
      const helper = photoAccessHelper.getPhotoAccessHelper(context)

      // Step 1: 下载图片文件
      const httpRequest = http.createHttp()
      const response = await httpRequest.request(
        imageUrl,
        {
          method: http.RequestMethod.GET,
          readTimeout: 6000,
          connectTimeout: 3000,
          expectDataType: http.HttpDataType.ARRAY_BUFFER
        }
      )

      if (!response.result || !response.responseCode.toString().startsWith("2")) {
        console.error('图片下载失败:', JSON.stringify(response))
        return
      }

      const imageData = response.result as ArrayBuffer

      // Step 2: 创建图片文件到相册
      const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg')  // 使用jpg或png取决于你的图片格式
      const file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE)

      // Step 3: 写入图片数据
      await fileIo.write(file.fd, imageData)

      // Step 4: 关闭文件
      await fileIo.close(file.fd)

      console.info('图片保存成功')
    } catch (err) {
      console.error('保存图片失败:', JSON.stringify(err))
    }
  }
  /** 保存图片至相册 */
  @Builder
  savePic() {
    SaveButton().onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
      if (result === SaveButtonOnClickResult.SUCCESS) {
        const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
        // 免去权限申请和权限请求等环节，获得临时授权，保存对应图片
        savePhotoToGallery(context);
      } else {
        promptAction.showToast({ message: '设置权限失败！' })
      }
    })
  }
  build() {
    Column() {
      Text("资讯")
      this.savePic()
      Button("保存图片")
        .onClick(() => {
          this.saveImageFromUrlToAlbum("https://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1CPbcv.img?w=630&h=440&m=6")
        })
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}
