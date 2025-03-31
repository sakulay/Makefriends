import { Post, PostList } from "../utils/Mock"
import { router } from "@kit.ArkUI"

@Component
export struct PostCard {
  @State item: Post = PostList[0]
  @State postList: Post[] = PostList
  // 生成图片列表
  @Builder
  ImageList(imgs: string[]) {
    Row({ space: 10 }) { // 设置图片之间的间距
      ForEach(imgs, (img: string) => {
        Image(img)
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
        Image(this.item.avatar)
          .width(25)
          .height(25)
          .borderRadius(25)
        Text(this.item.nickname)
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
        this.ImageList(this.item.imgList.slice(0, 3))
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
    .width('100%')
    .backgroundColor(Color.White)
    .padding(10)
    .margin({top: 8})
    .onClick(() => {
      router.pushUrl({
        url: 'pages/post/PostPage',
        params: this.item
      })
    })
  }
}