@Entry
@Component
struct PageToRefresh {
  private currentOffsetY: number = 0;
  @State refreshStatus: boolean = false;
  @State refreshText: string = '正在刷新';
  @State pullUpText: string = '正在加载';
  private timer: number = 0;
  @State isRefreshing: boolean = false;
  @State isCanLoadMore: boolean = false;
  @State ArrData: string[] = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9','0', '1', '2', '3', '4'];
  @State newArr: string [] = ['10', '11']
  @State isAtBottom: boolean = false;
  @State isAtTop: boolean = false;

  putDownPullUpRefresh(event?: TouchEvent): void {
    if (event === undefined) {
      return;
    }
    switch (event.type) {
      case TouchType.Down:
        this.currentOffsetY = event.touches[0].y;
        break;
      case TouchType.Move:
        // console.log('move '+ event.touches[0].y + ' ' + this.currentOffsetY)
        let isDownPull = event.touches[0].y - this.currentOffsetY > 50;
        let isLoadMore = event.touches[0].y - this.currentOffsetY < -50;
        if (isDownPull && this.isCanLoadMore === false) {
          this.refreshStatus = true;
        }
        if (isLoadMore) {
          this.isCanLoadMore = true
        }
        break;
      case TouchType.Cancel:
        break;
      case TouchType.Up:
        // if (this.refreshStatus && this.isAtTop) {
        //   this.isAtTop = false
        //   this.timer = setTimeout(() => {
        //     this.refreshStatus = false;
        //     this.ArrData = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
        //   }, 1500)
        // }
        // if (this.isCanLoadMore && this.isAtBottom) {
        //   this.isAtBottom = false
        //   this.timer = setTimeout(() => {
        //     this.isCanLoadMore = false;
        //     this.newArr.forEach((item) => {
        //       this.ArrData.push(item)
        //     })
        //   }, 1000)
        // }
        if(this.isCanLoadMore) {

        }

        break;
      default:
        break;
    }
  }

  @Builder
  putDown() {
    Row() {
      Image($r('app.media.news_more'))
        .width(40)
        .height(20)
      Text(this.refreshText).fontSize(16)
    }
    .justifyContent(FlexAlign.Center)
    .width('94%')
    .height('10%')
  }

  @Builder
  PullUp() {
    Row() {
      Image($r('app.media.ic_more'))
        .width(40)
        .height(40)
      Text(this.pullUpText).fontSize(16)
    }
    .justifyContent(FlexAlign.Center)
    .width('94%')
    .height('5%')
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          Text('商品')
          if (this.refreshStatus) {
            this.putDown()
          }
          ForEach(this.ArrData, (item: string) => {
            ListItem() {
              Text(item)
                .height(100)
            }
          }, (item: string) => JSON.stringify(item))
          if (this.isCanLoadMore) {
            this.PullUp()
          }
          if (!this.isCanLoadMore) {
            Text('暂无更多数据')
          }
        }
      }
      .edgeEffect(EdgeEffect.Fade)
      .width('100%')
      .onTouch((event?: TouchEvent) => {
        this.putDownPullUpRefresh(event);
      })
      .onScrollEdge((event: Edge)=>{
        console.log('onScrollEdge', event)
        if(event == 0) {
          console.log('onScrollEdge', "到达上边界")
          this.isAtTop = true
          this.isAtBottom = false
        } else if(event == 2) {
          console.log('onScrollEdge', "到达下边界")
          if(this.isCanLoadMore) {
            console.log('onScrollEdge', "加载更多")
            this.isCanLoadMore = false
          }
          this.isAtBottom = true
          this.isAtTop = false
        }
      })
    }
  }
}