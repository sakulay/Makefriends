import { photoAccessHelper } from '@kit.MediaLibraryKit'
import { BusinessError } from '@kit.BasicServicesKit'
import { dataSharePredicates } from '@kit.ArkData';
import { checkPermissionGrant } from '../utils/permission';
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';
import { fileIo } from '@kit.CoreFileKit';
import { promptAction, router } from '@kit.ArkUI';

@Extend(Line) function lineStyle(value:string = "100%") {
  .width(value)
  .height(1)
  .backgroundColor(Color.Grey)
}



async function example() {
  console.info('getAssets');

  let context = getContext();
  let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);

  let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
  let fetchOptions: photoAccessHelper.FetchOptions = {
    fetchColumns: [],
    predicates: predicates
  };

  phAccessHelper.getAssets(fetchOptions, async (err, fetchResult) => {
    if (fetchResult !== undefined) {
      console.info('fetchResult success');
      let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      if (photoAsset !== undefined) {
        console.info('photoAsset.displayName : ' + photoAsset.displayName);
      }
    } else {
      console.error(`fetchResult fail with error: ${err.code}, ${err.message}`);
    }
  });
}

async function example02() {
  let permission: Permissions = "ohos.permission.READ_IMAGEVIDEO"
  let grant: boolean =
    await checkPermissionGrant("ohos.permission.READ_IMAGEVIDEO") === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED
  if (grant) {
    example()
  } else {
    let result = await abilityAccessCtrl.createAtManager().requestPermissionsFromUser(getContext(), [permission])
    try{
      if (result.authResults[0] === 0) {
        example()
      }
    } catch(err) {
      console.error(`requestPermissionsFromUser fail with error: ${err.code}, ${err.message}`);
    }

  }
}

/** 保存图片至相册 */
async function savePhotoToGallery(context: common.UIAbilityContext) {
  let helper = photoAccessHelper.getPhotoAccessHelper(context);
  try {
    // onClick触发后10秒内通过createAsset接口创建图片文件，10秒后createAsset权限收回。
    let uri = await helper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
    // 使用uri打开文件，可以持续写入内容，写入过程不受时间限制
    let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // $r('app.media.startIcon')需要替换为开发者所需的图像资源文件
    context.resourceManager.getMediaContent($r('app.media.pic4').id, 0)
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
struct MineDetail{
  @State avatarUri:string = "file://media/Photo/2/IMG_1742700953_001/IMG_001.jpg"

  async example01() {
  try {
    let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
    // 设置图片类型为图片
    PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 设置最多可选择的图片数量为1
    PhotoSelectOptions.maxSelectNumber = 1;
    let photoPicker = new photoAccessHelper.PhotoViewPicker();
    photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
      console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
      if (PhotoSelectResult.photoUris.length > 0) {
        this.avatarUri = PhotoSelectResult.photoUris[0];
      }
    }).catch((err: BusinessError) => {
      console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
    });
  } catch (error) {
    let err: BusinessError = error as BusinessError;
    console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
  }
}
  /** 头像 */
  @Builder
  avatar() {
    Row() {
      Text('头像')
      Image(this.avatarUri)
        .width(70)
        .height(70)
        .borderRadius(25)
        .onClick(()=>{
            this.example01()
        })
    }
    .width('100%')
    .height(70)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }
  /** 昵称 */
  @Builder
  nickName(title: string, text: string) {
    Row() {
      Text(title)
        .width(50)
      TextInput({text: text, placeholder: '点击添加'})
        .textAlign(TextAlign.End)
        .layoutWeight(1)
        .backgroundColor(Color.White)
        .padding(0)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }
  /** 学号 */
  @Builder
  stuNum(stuNum: string) {
    Row() {
      Text("学号")
        .width(50)
      Text(stuNum)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }

  /** 性别 */
  @Builder
  gender(sex: string) {
    Row() {
      Text("性别")
        .width(50)
      Text(sex)
        .layoutWeight(1)
        .textAlign(TextAlign.End)
        .onClick(()=>{
          this.getUIContext().showTextPickerDialog({
            range: ['男', '女'],
            onAccept: (value: TextPickerResult) => {
              console.info('accept:' + value.index)
              if (value.index === 0) {
                sex = '男'
              } else {
                sex = '女'
              }
              console.info('accept:' + sex)
            },
            onCancel: () => {
              console.info('cancel')
            }
          })
        })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }

  /** 个人简介 */
  @Builder
  bio() {
    Row() {
      Text("个人简介")
        .width(65)
      TextArea({placeholder: '点击添加'})
        .layoutWeight(1)
        .textAlign(TextAlign.End)
        .padding(0)
        .maxLength(10)
        .showCounter(true,{
          thresholdPercentage: 80,
          highlightBorder: false
        })
        .borderRadius(0)
        .backgroundColor(Color.White)
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
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
      // 顶部
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(20)
          .onClick(()=>{
            router.back()
          })
        Text("个人信息")
          .fontSize(25)
        Text("保存")
          .fontSize(20)
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(Color.Gray)
      .padding(5)

      // 主体
      Column() {
        Column({space: 5}) {
          this.avatar()
          this.nickName('昵称', '林键超')
          this.stuNum('2101510218')
          this.gender('男')
          this.bio()
          this.savePic()
        }
        .width('100%')
        .backgroundColor(Color.White)
        .borderRadius(10)
        .padding(10)
      }
      .width('100%')
      .height('100%')
      .padding({left: 10, right: 10})
      .margin({top: 15})

    }
    .backgroundColor('#f1f1f1')

  }
}