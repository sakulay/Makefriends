import { router } from '@kit.ArkUI';
import { PostModel, PostQuery, getRecPostList, PostImage } from '../../api/postApi';
import { PostCard } from '../components/PostCard';
import { EmptyPage } from '../components/EmptyPage';
import { showBottomError, showBottomToast } from '../../utils/toast';
import { Loading } from '../components/Loading';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';

interface SearchParams {
  keyword: string;
}

@Entry
@Component
struct SearchResult {
  @State searchResults: PostModel[] = []
  @State isLoading: boolean = false
  @State isNone: boolean = false
  @State page: number = 1
  private keyword: string = ''
  
  // 模拟数据
  private mockData: PostModel[] = [
    new PostModel(
      1,
      14,
      "a校园美食分享",
      "今天在食堂发现了一家超好吃的面馆，推荐给大家！",
      [new PostImage("1", "1", "http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg", "")],
      50,
      60,
      "2025-02-25 12:00:00",
      new UserSimpleInfo("14", "林键超", "http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg", "1", "我自横刀向天笑，去留肝胆两昆仑", 34)
    ),
    new PostModel(
      2,
      15,
      "学习经验交流",
      "分享一下我的考研经验，希望对大家有帮助！",
      [],
      30,
      20,
      "2025-02-25 13:00:00",
      new UserSimpleInfo("15", "张三", "http://111.230.102.82:40061/i/2025/02/26/su2jeq-1.jpeg", '1', "热爱学习，热爱生活", 22)
    ),
    new PostModel(
      3,
      16,
      "社团活动招募",
      "我们社团正在招募新成员，欢迎加入！",
      [new PostImage("2", "3", "http://111.230.102.82:40061/i/2025/02/26/su2jeq-2.jpeg", "")],
      40,
      25,
      "2025-02-25 14:00:00",
      new UserSimpleInfo("16", "李四", "http://111.230.102.82:40061/i/2025/02/26/su2jeq-2.jpeg", '2', "热爱运动，热爱生活", 33)
    )
  ]
  
  aboutToAppear() {
    const params = router.getParams() as SearchParams;
    if (params?.keyword) {
      this.keyword = params.keyword;
      this.searchPosts(this.keyword);
    }
  }
  
  searchPosts(keyword: string) {
    if (!keyword) return;
    
    this.isLoading = true;
    const queryParam = new PostQuery(this.page, 10, 1);
    queryParam.title = keyword;
    
    getRecPostList(queryParam).then((res) => {
      if (res.list.length > 0) {
        this.searchResults.push(...res.list);
      } else {
        this.isNone = true;
      }
      this.isLoading = false;
    }).catch((err: string) => {
      console.error('搜索帖子失败: ', err);
      showBottomError(this.getUIContext(), err);
      this.isLoading = false;
    });
  }
  
  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(24)
          .height(24)
          .margin({ left: 16 })
          .onClick(() => {
            router.back()
          })
        Text('搜索结果')
          .fontSize(18)
          .fontWeight(500)
          .margin({ left: 16 })
      }
      .width('100%')
      .height(56)
      .backgroundColor(Color.White)

      // 搜索结果列表
      Scroll() {
        if (this.searchResults.length === 0) {
          EmptyPage()
        } else {
          Column() {
            ForEach(this.searchResults, (item: PostModel) => {
              PostCard({ item: item })
            })
            if (this.isLoading) {
              Loading({ h: "10%", text: '' })
                .offset({ bottom: 0 })
            }
          }
          .width('100%')
          .constraintSize({ minHeight: '100%' })
          .backgroundColor('#fff8f7f7')
        }
      }
      .scrollBarWidth(0)
      .onScrollEdge((event) => {
        if (event == 2) {
          if (!this.isNone) {
            this.page++;
            this.searchPosts(this.keyword);
          } else {
            showBottomToast(this.getUIContext(), '没有更多了');
          }
        }
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}