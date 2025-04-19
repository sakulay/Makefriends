// pages/DownloadImage.ets
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { http } from '@kit.NetworkKit';


@Entry
@Component
export struct DownloadImagePage {
  @State imageUrl: string = ''; // 替换成你的图片URL
  private LOG = '[DownloadImagePage]';

  async downloadAndSaveImage() {
    try {
      // 1. 下载图片为 ArrayBuffer
      const res = await http.createHttp().request(this.imageUrl, {
        method: http.RequestMethod.GET,
        readTimeout: 6000,
        connectTimeout: 3000,
        expectDataType: http.HttpDataType.ARRAY_BUFFER
      });

      const buffer: Uint8Array = res.result as Uint8Array;

      // 2. 获取授权的媒体库保存路径（10秒有效）
      const context = getContext(this);
      const helper = photoAccessHelper.getPhotoAccessHelper(context);
      const uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg'); // 创建文件

      // 3. 使用 fileIo 写入文件
      const file = await fileIo.open(uri, fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.CREATE);
      await fileIo.write(file.fd, buffer);
      await fileIo.close(file.fd);

      console.info(`${this.LOG} 图片保存成功`);
    } catch (error) {
      console.error(`${this.LOG} 保存失败: ` + JSON.stringify(error));
    }
  }

  build() {
    Column({ space: 20 }) {
      Text(this.imageUrl)
      TextInput({text: $$this.imageUrl}).width('100%').height(50)

      // 必须使用 SaveButton 才能触发权限
      SaveButton({ icon: SaveIconStyle.FULL_FILLED, buttonType: ButtonType.Capsule })
        .onClick(async (event, result) => {
          if (result === SaveButtonOnClickResult.SUCCESS) {
            await this.downloadAndSaveImage();
          } else {
            console.error(`${this.LOG} 权限拒绝或异常: result=${result}`);
          }
        })
    }
    .padding(20)
    .width('100%')
    .height('100%')
  }
}
