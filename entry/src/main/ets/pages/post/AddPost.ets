import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomColors, router } from '@kit.ArkUI';
import { PostImage, PostModel, saveAppPost } from '../../api/postApi';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';
import { Upload, upload } from '../../api/uploadApi';
import { common } from '@kit.AbilityKit';
import { showTopToast } from '../../utils/toast';
import { getStudentId } from '../../utils/utils';
import { showBottomError, showBottomToast } from '../../utils/toast'
import { CategoryModel, CategoryQuery, getCategoryPage } from '../../api/categoryApi'
import vibrator from '@ohos.vibrator';

class CustomThemeImpl implements CustomTheme {
  colors?: CustomColors;

  constructor(colors: CustomColors) {
    this.colors = colors;
  }
}

// 自定义内容文字及loading组件主题颜色
class CustomThemeColors implements CustomColors {
  fontPrimary = '#333333';  // 深色文字
  iconPrimary = '#FF4081';  // 警告图标颜色
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

@CustomDialog
struct TipsDialog {
  controller?: CustomDialogController
  
  @Prop imageRes: Resource
  @Prop content: string
  @Prop theme: CustomTheme
  
  build() {
    Column() {
      Image(this.imageRes).width(40).height(40).margin(10)
      Text(this.content).fontSize(18).margin(10).fontColor(Color.White)
    }
    .backgroundColor(Color.Gray)
    .borderRadius(12)
    .padding(20)
    .width('50%')
    .alignItems(HorizontalAlign.Center)
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.1)',
      offsetX: 0,
      offsetY: 2
    })
    .animation({
      duration: 250,
      curve: Curve.EaseOut,
      delay: 0,
      iterations: 1,
      playMode: PlayMode.Normal
    })
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
  @State categories: CategoryModel[] = [] // 分类列表
  @State selectedCategory: CategoryModel | null = null // 当前选中的分类

  titleTips: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.ic_warning'),
      content: '标题不能为空',
      theme: new CustomThemeImpl(new CustomThemeColors()),
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    isModal: false,
    width: 200,
  })

  contentTips: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.ic_warning'),
      content: '内容不能为空',
      theme: new CustomThemeImpl(new CustomThemeColors()),
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    backgroundColor: '#FFFFFF',
    maskColor: 'rgba(0, 0, 0, 0.6)',
    isModal: false,
    width: 200,
  })

  categoryTips: CustomDialogController = new CustomDialogController({
    builder: TipsDialog({
      imageRes: $r('app.media.ic_warning'),
      content: '请选择分类',
      theme: new CustomThemeImpl(new CustomThemeColors()),
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    backgroundColor: '#FFFFFF',
    maskColor: 'rgba(0, 0, 0, 0.6)',
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
    if(this.post.title == '') {
      this.titleTips.open()
      setTimeout(() => {
        this.titleTips.close()
      }, 2000)
    } else if(!this.selectedCategory) {
      this.categoryTips.open()
      setTimeout(() => {
        this.categoryTips.close()
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

  aboutToAppear() {
    this.getCategories()
  }

  /**
   * 获取分类列表
   */
  getCategories() {
    let queryParams = new CategoryQuery(1, 50, 0)
    getCategoryPage(queryParams).then((res) => {
      console.log('获取分类成功: ', JSON.stringify(res))
      this.categories = res.list
    }).catch((err: string) => {
      console.error('获取分类失败: ', err)
      showBottomError(this.getUIContext(), err)
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
  CategorySelector() {
    Column() {
      Row() {
        Text('选择分类')
          .fontSize(20)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)
        Text('*')
          .fontSize(16)
          .fontColor('#FF4081')
          .margin({ left: 5, right: 5 })
      }
      .width('100%')
      .margin({ bottom: 12, top: 16 })

      Scroll() {
        Row({ space: 12 }) {
          ForEach(this.categories, (item: CategoryModel) => {
            Column() {
              Text(item.name)
                .fontSize(14)
                .fontWeight(this.selectedCategory?.id === item.id ? FontWeight.Bold : FontWeight.Normal)
                .fontColor(this.selectedCategory?.id === item.id ? '#2080f0' : '#666666')
            }
            .backgroundColor(this.selectedCategory?.id === item.id ? '#E6F2FF' : '#F5F5F5')
            .borderRadius(20)
            .padding({ left: 16, right: 16, top: 8, bottom: 8 })
            .animation({
              duration: 250,
              curve: Curve.EaseInOut
            })
            .onClick(() => {
              this.selectedCategory = item
              this.post.categoryId = item.id
              this.post.categoryName = item.name
              // 使用正确的振动参数
              try {
                vibrator.startVibration(
                  { type: 'time', duration: 10 },  // 振动效果
                  { id: 1, usage: 'touch' }        // 振动属性
                )
              } catch (error) {
                console.error('触感反馈失败:', error)
              }
            })
          })
        }
        .padding({ left: 8, right: 8 })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .width('100%')
      .height(44)
    }
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(12)
    .padding({ top: 4, bottom: 16 })
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
          })
        Text(`${this.titleCnt}`)
          .fontSize(15)
          .fontColor(Color.Gray)
          .margin({top: 15})
      }
      .padding({ bottom: 8 })

      Divider()
        .color('#F5F5F5')
        .width('100%')
        .height(1)

      Divider()
        .color('#F5F5F5')
        .width('100%')
        .height(1)

      // 内容
      TextArea({placeholder: '内容', text: $$this.post.content})
        .padding({left: 5, bottom: 10, top: 10, right: 5})
        .placeholderColor(Color.Gray)
        .backgroundColor(Color.White)
        .constraintSize({minHeight: 200})
        .fontSize(20)
        .placeholderFont({size: 23})
        .maxLength(2000)
        .showCounter(true,{
          thresholdPercentage: 80,
          highlightBorder: false
        })

      // 分类选择器
      this.CategorySelector()

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