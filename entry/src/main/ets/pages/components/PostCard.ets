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
      Row() {
        Image( this.item.userInfo.avatar )
          .width(44)
          .height(44)
          .borderRadius(22)
          .margin({ right: 12 })
          .backgroundColor('#F5F5F5')
          .onClick(()=>{
            router.pushUrl({
              url: 'pages/friends/InfoCard',
              params: this.item.userInfo
            })
          })

        Column() {
          Text(this.item.userInfo.nickname)
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#333333')
          Text(this.item.createTime)
            .fontSize(12)
            .fontColor('#999999')
            .margin({ top: 4 })
        }
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
      }
      .width('100%')
      // .padding({ top: 16, bottom: 16, left: 16, right: 16 })

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

      // 底部操作栏
      Row() {
        // 左侧分类标签
        if (this.item.categoryName) {
          Text(this.item.categoryName)
            .fontSize(12)
            .fontColor('#2080f0')
            .backgroundColor('#E6F2FF')
            .borderRadius(10)
            .padding({ left: 8, right: 8, top: 2, bottom: 2 })
        }

        // 右侧点赞等操作
        Row({space: 2}) {
          Image($r('app.media.ic_like'))
            .width(23)
            .height(23)
            .margin({bottom: 4})
            .opacity(0.3)
          Text(this.item.likeCount.toString())
            .fontColor(Color.Gray)
            .margin({right: 7})
          Image($r('app.media.ic_comment'))
            .width(25)
            .height(25)
            .opacity(0.3)
          Text(this.item.commentCount.toString())
            .margin({right: 8})
            .fontColor(Color.Gray)
          Image($r('app.media.ic_star'))
            .width(23)
            .height(23)
            .opacity(0.3)
            .margin({bottom: 2})
          Text(this.item.likeCount.toString())
            .fontColor(Color.Gray)
        }
      }
      .width('100%')
      .height(30)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .backgroundColor('#fefefe') // 柔白，而不是纯白
    .borderRadius(20) // 更加圆润
    .padding(12)
    .margin({ top: 12, left: '3%', right: '3%' })

    .shadow({
      radius: 8,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 2
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