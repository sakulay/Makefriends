import { Post, PostList } from "../../utils/Mock"
import { router } from "@kit.ArkUI"
import { PostImage, PostModel } from "../../api/postApi"
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel"

@Component
export struct PostCard {
  @Prop item: PostModel = new PostModel(
    3,
    14,
    '标题3',
    '内容3',
    [],
    50, 60, '2025-02-25 12:00:00',
    new UserSimpleInfo(
      '14',
      '林键超',
      'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg',
      '我自横刀向天笑，去留肝胆两昆仑',
      '',
      1
    ))
  @State postList: Post[] = PostList
  // 生成图片列表
  @Builder
  ImageList(imgs: PostImage[]) {
    Row({ space: 10 }) { // 设置图片之间的间距
      ForEach(imgs, (img: PostImage) => {
        Image(img.imageUrl)
          .width(100)
          .height(100)
          .borderRadius(10)
      })
    }
    .width('100%') // 确保Row占满父容器的宽度
    .justifyContent(FlexAlign.Start) // 图片均匀分布
  }

  build() {
    Column({space: 8}) {
      // 头像、用户名
      Row({space: 8}) {
        Image(this.item.userInfo.avatar)
          .width(25)
          .height(25)
          .borderRadius(25)
        Text(this.item.userInfo.nickname)
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      // 标题、部分内容
      Column({space: 5}) {
        Text(this.item.title)
          .width('100%')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
        Text(this.item.content)
          .width('100%')
          .textAlign(TextAlign.Start)
          .fontSize(16)
          .maxLines(2)
      }
      .width('100%')
      // .backgroundColor(Color.Brown)
      .justifyContent(FlexAlign.Start)
      //  图片
      Row() {
        if(this.item.imageList) {
          this.ImageList(this.item.imageList.slice(0, 3))
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      //  评论数、点赞数
      Row({space: 2}) {
        Image($r('app.media.ic_comment'))
          .width(25)
          .height(25)
          .opacity(0.6)
        Text(this.item.commentCount.toString())
          .margin({right: 8})
          .fontColor(Color.Gray)
        Image($r('app.media.ic_like'))
          .width(23)
          .height(23)
          .margin({bottom: 4})
          .opacity(0.6)
        Text(this.item.likeCount.toString())
          .fontColor(Color.Gray)
      }
      .width('100%')
      .height(30)
      // .backgroundColor(Color.Gray)
      .justifyContent(FlexAlign.End)
    }
    // .width('100%')
    // .backgroundColor(Color.White)
    // .padding(10)
    // .margin({top: 8})
    .backgroundColor('#fefefe') // 柔白，而不是纯白
    .borderRadius(20) // 更加圆润
    .padding(12)
    .margin({ top: 12, left: '3%', right: '3%' })
    .shadow({
      radius: 12,
      color: 'rgba(0, 0, 0, 0.08)', // 柔和阴影
      offsetX: 0,
      offsetY: 6
    })
    .border({
      width: 0.5,
      color: '#e0e0e0'
    })
    .onClick(() => {
      router.pushUrl({
        url: 'pages/post/PostPage',
        params: this.item
      })
    })
  }
}