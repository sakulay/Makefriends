import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomColors, router, TipsDialog } from '@kit.ArkUI';
import { PostImage, PostModel, saveAppPost } from '../../api/postApi';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';
import { Upload, upload } from '../../api/uploadApi';
import { common } from '@kit.AbilityKit';
import { showTopToast } from '../../utils/toast';
import { getStudentId } from '../../utils/utils';

class CustomThemeImpl implements CustomTheme {
  colors?: CustomColors;

  constructor(colors: CustomColors) {
    this.colors = colors;
  }
}

// 自定义内容文字及loading组件主题颜色
class CustomThemeColors implements CustomColors {
  fontPrimary = Color.White;
  iconPrimary = '#ffd000cd';
}
class Post {
  title: string;
  content: string;
  list: string[];

  constructor(title: string, content: string, list: string[]) {
    this.title = title;
    this.content = content;
    this.list = list;
  }
}

@Entry
@Component
struct AddPost {
  private LOG = '[AddPost]'
  @State tt: number = 0
  @State message: string = '';
  @State imageUri: string = '';
  @State list: string[] = ['1','file://media/Photo/4/IMG_1742880362_003/IMG_003.jpg']
  @State imgs: PostImage[] = [];
  @State titleCnt: number = 45
  @State post: PostModel = new PostModel(0, 1, '', '', this.imgs, 0, 0, '', new UserSimpleInfo('', '', '', ''));
  @State customTheme: CustomTheme = new CustomThemeImpl(new CustomThemeColors());

  titleTips: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.ic_warning'),
      content: '标题不能为空',
      theme: this.customTheme,
    }),
    backgroundColor: '#92000000',
    isModal: false,
    width: 200,
    // height: 130,
  })
  contentTips: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.ic_warning'),
      content: '内容不能为空',
      theme: this.customTheme,
    }),
    backgroundColor: '#92000000',
    isModal: false,
    width: 200,
  })
  // 添加保存草稿的方法
  saveDraft() {
    // 这里可以添加保存草稿的逻辑，例如将 post 对象保存到本地存储或服务器
    console.info('Draft saved:', this.post);

    // 添加弹窗提示用户草稿已保存
    AlertDialog.show({
      // title: '保存成功',
      message: '是否保存草稿？',
      autoCancel: true,
      alignment: DialogAlignment.Center,
      offset: { dx: 0, dy: -20 },
      gridCount: 3,
      width: 280,
      height: 130,
      cornerRadius: 20,
      shadow: ({ radius: 20, color: Color.Grey, offsetX: 20, offsetY: 5}),
      primaryButton: {
        enabled: true,
        defaultFocus: true,
        style: DialogButtonStyle.HIGHLIGHT,
        value: '保存',
        action: () => {
          console.info('Callback when the second button is clicked')
        }
      },
      secondaryButton: {
        value: '不保存',
        action: () => {
          console.info('Callback when the first button is clicked')
        }
      },
      transition:TransitionEffect.asymmetric(
        TransitionEffect.OPACITY
          .animation({ duration: 300, curve: Curve.Sharp })
          .combine(TransitionEffect.scale({x: 1.5, y: 1.5})
          .animation({duration: 300, curve: Curve.Sharp})),
        TransitionEffect.OPACITY
          .animation({ duration: 100, curve: Curve.Smooth })
          .combine(TransitionEffect.scale({x: 0.5, y: 0.5})
            .animation({duration: 300, curve: Curve.Smooth}))),
    });
  }

  // 发布
  publish() {
    // 检查标题和内容是否为空
    if(this.post.title == '') {
      this.titleTips.open()
      setTimeout(() => {
        this.titleTips.close()
      }, 2000)
    } else if(this.post.content == '') {
      this.contentTips.open()
      setTimeout(() => {
        this.contentTips.close()
      }, 2000)
    } else {
      this.handleSubmit()
    }
  }

  async addPic() {
    try {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      // 设置图片类型为图片
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      // 设置最多可选择的图片数量为1
      PhotoSelectOptions.maxSelectNumber = 1;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker
        .select(PhotoSelectOptions)
        .then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
          console.info('PhotoViewPicker.select successfully, PhotoSelectResult uri: ' + JSON.stringify(PhotoSelectResult));
          if (PhotoSelectResult.photoUris.length > 0) {
            const uri = PhotoSelectResult.photoUris[0];
            this.imgs.push(new PostImage('', '', uri, ''))
          }
        }).catch((err: BusinessError) => {
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }
  handleImgsUpload(): Promise<void> {
    const uploadPromises = this.imgs.map(async (item: PostImage) => {
      console.log(this.LOG, "item.imageUrl: ", item.imageUrl)
      // 判断图片是否是本地图片
      try {
        if (item.imageUrl.startsWith("file:") || item.imageUrl.startsWith("internal:")) {
          const up = await upload(item.imageUrl, getContext(this) as common.UIAbilityContext)
          console.log(this.LOG, "上传图片成功：", JSON.stringify(up))
          item.imageUrl = up.url
          item.deleteUrl = up.del
        }
      } catch (e) {
        console.error(this.LOG, "上传图片失败：", item.imageUrl)
      }
    });

    return Promise.all(uploadPromises).then(() => {
      console.log(this.LOG, "上传图片：", JSON.stringify(this.imgs))
    });
  }

  /**
   * 提交表单
   */
  async handleSubmit() {
    // 先完成图片的上传
    await this.handleImgsUpload()
    // 提交表单
    this.post.imageList = this.imgs
    this.post.userId = Number(getStudentId())
    saveAppPost(this.post).then(()=>{
      console.log(this.LOG, "提交表单成功")
      showTopToast(this.getUIContext(), "发布成功")
      router.back()
    }).catch((e: string) => {
      console.error(this.LOG, "发布失败：", e)
    })
  }
  @Builder
  top() {
    Row() {
      Image($r('app.media.ic_left_arrow'))
        .width(23)
        .height(23)
        .onClick(()=>{
          if(this.post.title != '' || this.post.content != '' || this.post.imageList.length != 0) {
            this.saveDraft(); // 调用保存草稿的方法
          } else {
            router.back();
          }
        })
      Text("发布")
        .fontSize(20)
        .fontWeight(350)
        .margin({left: 'auto'})
        .onClick(()=>{
          this.publish()
        })
    }
    .width('100%')
    .height(38)
    .padding(10)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  postBody() {
    Column() {
      Row() {
        // 标题
        TextInput({placeholder: '标题', text: $$this.post.title})
          .padding({left: 5, bottom: 10, top: 10, right: 5})
          .fontSize(23)
          .fontWeight(500)
          .placeholderFont({size: 23})
          .placeholderColor(Color.Gray)
          .backgroundColor(Color.White)
          .maxLength(45)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.titleCnt = 45 - value.length;
          }) // 添加 onChange 事件来更新 title 和 titleCnt
        // 标题剩余字数提示
        Text(`${this.titleCnt}`)
          .fontSize(15)
          .fontColor(Color.Gray)
          .margin({top: 15})
      }
      Divider()
      // 内容
      TextArea({placeholder: '内容', text: $$this.post.content})
        .padding({left: 5, bottom: 10, top: 10, right: 5})
        .placeholderColor(Color.Gray)
        .backgroundColor(Color.White)
        .constraintSize({minHeight: 200})
        .fontSize(20)
        .placeholderFont({size: 20})
        .maxLength(2000)
        .showCounter(true,{
          thresholdPercentage: 80,
          highlightBorder: false
        })
      // 图片
      Flex({direction: FlexDirection.Row, wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start, alignItems: ItemAlign.Start}) {
        ForEach(this.imgs, (pic: PostImage, index: number) => {
          Stack({alignContent: Alignment.TopEnd}) {
            Column() {
              Image(pic.imageUrl)
                .width(100)
                .height(100)
                .objectFit(ImageFit.Contain)
            }
            .width(100)
            .height(100)
            .borderRadius(5)
            .backgroundColor('#f1f1f1')
            .margin({left: 10, top: 5}) // 添加 margin 属性

            Column() {
              Image($r('app.media.ic_delete_gray'))
                .width(10)
                .height(10)
                .opacity(0.5)
            }
            .justifyContent(FlexAlign.Center)
            .width(15)
            .height(15)
            .backgroundColor('#ffecebeb')
            .margin({top: 5, right: 2})
            .onClick(() => {
              this.imgs.splice(index, 1); // 删除对应的图片
            })
          }
        })
        Column() {
          Image($r('app.media.ic_plus_gray'))
            .width(30)
            .height(30)
            .opacity(0.5)
        }
        .width(100)
        .height(100)
        .borderRadius(10)
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#f1f1f1')
        .margin({left: 10, top: 5})
        .onClick(() => {
          this.addPic()
        })
      }
      .width('100%')
      Button("点击")
        .width('60%')
        .onClick(() => {
          if(this.tt == 0) {
            this.imgs.push(new PostImage('', '', 'http://111.230.102.82:40061/i/2025/02/26/p1mi5m-0.jpg', ''))
            this.tt++
          } else {
            this.imgs.push(new PostImage('', '', 'http://img-s-msn-com.akamaized.net/tenant/amp/entityid/AA1CRajx.img', ''))
            this.tt--
          }
          console.log(JSON.stringify(this.post.imageList))
        })
    }
    .constraintSize({minHeight: "100%"})
    .width('100%')
    .padding({left: 10, right: 10, bottom: 10, top: 10})
  }

  build() {
    Column() {
      // 顶部
      this.top()
      // 主体
      Scroll() {
        this.postBody()
      }
      .scrollBarWidth(0)
      .layoutWeight(1)
    }

    // .backgroundColor(Color.Brown)

  }
}