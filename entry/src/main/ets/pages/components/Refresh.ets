import { Loading } from './Loading';

@Component
export struct MyRefresh {
  @Prop refreshing: boolean = false;
  onRefresh: () => void = () => {};
  @State refreshStatus: number = 0; // 0: 未开始, 1: 下拉中, 2: 释放刷新, 3: 刷新中
  @BuilderParam content: () => void

  build() {
    Column() {
      this.content()
      if (this.refreshing) {
        Loading()
          .width(24)
          .height(24)
      } else {
        Image($r('app.media.ic_more'))
          .width(24)
          .height(24)
      }
      Text(this.refreshing ? '刷新中...' : '下拉刷新')
        .fontSize(14)
        .fontColor('#666666')
        .margin({ top: 8 })
    }
    .width('100%')
    .height(60)
    .justifyContent(FlexAlign.Center)
    .gesture(
      PanGesture()
        .onActionStart(() => {
          this.refreshStatus = 1;
        })
        .onActionUpdate((event: GestureEvent) => {
          if (event.offsetY > 60) {
            this.refreshStatus = 2;
          } else {
            this.refreshStatus = 1;
          }
        })
        .onActionEnd(() => {
          if (this.refreshStatus === 2) {
            this.refreshStatus = 3;
            this.onRefresh();
          } else {
            this.refreshStatus = 0;
          }
        })
    )
  }
} 