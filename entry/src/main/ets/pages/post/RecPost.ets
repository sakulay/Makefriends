import { Post, PostList } from '../utils/Mock'
import { router } from '@kit.ArkUI'
import { PostCard } from '../components/PostCard'

@Entry
@Component
export struct RecPost {
  @State postList: Post[] = PostList
  @Builder
  PostList(postList: Post[]) {
    ForEach(postList, (item: Post, index: number)=>{
      PostCard({item: item})
    }, (item: Post) => item.id.toString())
  }

  build() {
    Scroll() {
      Column() {
        this.PostList(this.postList)
      }
      .width('100%')
      .backgroundColor('#f1f1f1')
    }
  }
}