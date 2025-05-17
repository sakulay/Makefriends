import { PostModel } from '../../api/postApi';
import { getFavoritesPage, deleteFavorites } from '../../api/favoritesApi';
import { getStudentId } from '../../utils/utils';
import { Loading } from '../components/Loading';
import { router } from '@kit.ArkUI';
import { EmptyPage } from '../components/EmptyPage';
import { myloading } from './BrowseRecord';

@Entry
@Component
struct Favorites {
  @State records: PostModel[] = [];
  @State loading: boolean = false;
  @State pageNum: number = 1;
  @State pageSize: number = 10;
  @State hasMore: boolean = true;
  @State isRefreshing: boolean = false;
  private LOG = "[Favorites]"

  aboutToAppear() {
    this.loadData();
  }

  async loadData() {
    console.log("page", this.pageNum)
    // 如果正在加载中，直接返回
    if (this.loading) {
      console.log("正在加载中，跳过")
      return;
    }
    
    // 如果不是刷新状态，且没有更多数据，直接返回
    if (!this.isRefreshing && !this.hasMore) {
      console.log("没有更多数据，跳过")
      return;
    }

    console.log("发送请求")
    this.loading = true;
    try {
      const result = await getFavoritesPage({
        pageNum: this.pageNum,
        pageSize: this.pageSize,
        viewerId: getStudentId()
      });
      
      if (this.pageNum === 1) {
        this.records = result.list;
      } else {
        this.records = this.records.concat(result.list);
      }
      
      this.hasMore = result.list.length === this.pageSize;
      if (this.hasMore) {
        this.pageNum++;
      }
    } catch (error) {
      console.error('加载收藏记录失败:', error);
    } finally {
      this.loading = false;
      this.isRefreshing = false;
    }
  }

  async handleDelete(postId: string) {
    try {
      await deleteFavorites(getStudentId(), postId);
      this.records = this.records.filter(record => record.id !== Number(postId));
    } catch (error) {
      console.error('删除收藏记录失败:', error);
    }
  }

  // 刷新数据
  async refreshData() {
    // 重置页码和状态
    console.log('刷新数据')
    this.pageNum = 1
    this.hasMore = true
    this.records = []
    this.isRefreshing = true
    await this.loadData()
  }

  build() {
    Refresh({ refreshing: $$this.isRefreshing, offset: 120, friction: 2, builder: myloading() }) {
      Column() {
        // 顶部导航栏
        Row() {
          Image($r('app.media.ic_left_arrow'))
            .width(24)
            .height(24)
            .margin({ left: 12 })
            .onClick(() => {
              router.back();
            })
          Text('我的收藏')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .margin({ left: 12 })
          Blank()
        }
        .width('100%')
        .height(48)
        .backgroundColor('#FFFFFF')
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)

        Stack({alignContent: Alignment.Top}) {
          if(this.records.length == 0 && !this.isRefreshing) {
            EmptyPage()
          } else {
            List() {
              ForEach(this.records, (record: PostModel) => {
                ListItem() {
                  Row() {
                    if(record.imageList.length != 0) {
                      Image(record.imageList[0].imageUrl)
                        .width(60)
                        .height(60)
                        .borderRadius(6)
                        .margin({ right: 10 })
                        .objectFit(ImageFit.Cover)
                    }
                    Column() {
                      Text(record.title)
                        .fontSize(15)
                        .fontWeight(FontWeight.Medium)
                        .margin({ bottom: 4 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .width('100%')
                        .textAlign(TextAlign.Start)

                      Text(record.content)
                        .fontSize(13)
                        .fontColor('#666')
                        .maxLines(2)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                        .margin({ bottom: 4 })
                        .width('100%')
                        .textAlign(TextAlign.Start)

                      Row() {
                        Text(record.createTime)
                          .fontSize(12)
                          .fontColor('#999')
                        Blank()
                        Image($r('app.media.ic_delete'))
                          .width(16)
                          .height(16)
                          .onClick(() => this.handleDelete(record.id.toString()))
                      }
                      .width('100%')
                      .justifyContent(FlexAlign.SpaceBetween)
                    }
                    .layoutWeight(1)
                  }
                  .padding(10)
                  .width('100%')
                  .backgroundColor('#FFFFFF')
                  .borderRadius(6)
                  .shadow({ radius: 2, color: '#1A000000', offsetX: 1, offsetY: 1 })
                  .onClick(() => {
                    router.pushUrl({
                      url: 'pages/post/PostPage',
                      params: record
                    }, router.RouterMode.Standard)
                  })
                }
                .margin({ top: 4, bottom: 4 })
              })
              if(this.loading && !this.isRefreshing) {
                ListItem() {
                  myloading()
                }
              }
            }
            .onReachEnd(() => this.loadData())
            .width('100%')
            .height('100%')
            .padding(10)
            .backgroundColor('#F5F5F5')
          }
        }
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
    }
    .onRefreshing(() => {
      this.refreshData()
    })
  }
} 