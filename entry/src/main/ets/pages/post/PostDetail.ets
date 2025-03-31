import { mockInfo, PersonalInfo, Post, PostList} from '../utils/Mock'
import { router } from '@kit.ArkUI'

@Component
export struct PostDetail {
  @State imgs: string[] = PostList[0].imgList
  @State info: PersonalInfo = mockInfo()
  @Prop post: Post
  @State swiper_index: number = 1
  aboutToAppear(): void {
      if(this.post) {
        console.log(JSON.stringify(this.post))
        this.imgs = this.post.imgList
      }
      // console.log(`aboutToAppear: ${this.imgs}`)
  }
  @Builder MySwiper() {
    Stack({alignContent: Alignment.BottomEnd}){
      Swiper(){
        ForEach(this.imgs, (item: string)=>{
          Image(item)
            .objectFit(ImageFit.Contain)
            .width("100%")
            .height(350)
        })
      }
      .indicator(false)
      .onChange((index)=>{
        this.swiper_index = index + 1
      })
      Text(`${this.swiper_index}/${this.imgs.length}`)
        .width(50)
        .textAlign(TextAlign.Center)
        .fontColor(Color.White)
        .backgroundColor($r('sys.color.mask_tertiary'))
        .borderRadius(16)
        .margin({bottom: 10, right: 10})
    }
  }
  build() {
    Column() {
      if(PostList[0].imgList) {
        this.MySwiper()
      }
      Column({space: 10}) {
        // 头像、用户名
        Row({space: 8}) {
          Image(this.post.avatar)
            .width(35)
            .height(35)
            .borderRadius(25)
          Text(this.post.nickname)
            .fontSize(18)
        }
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .onClick(()=>{
          router.pushUrl({
            url: 'pages/friends/InfoCard',
            params: this.info
          })
        })
        // 标题、部分内容
        Column({space: 10}) {
          Text(this.post.title)
            .width('100%')
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Start)
          Text(this.post.content)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontSize(16)
        }
        .width('100%')
        // .backgroundColor(Color.Brown)
        .justifyContent(FlexAlign.Start)
      }
      .width('100%')
      .backgroundColor(Color.White)
      // .backgroundColor(Color.Brown)
      .padding(10)
      .margin({top: 8})
    }
    // .height('100%')
    .width('100%')
    .backgroundColor('#f1f1f1')
  }
}