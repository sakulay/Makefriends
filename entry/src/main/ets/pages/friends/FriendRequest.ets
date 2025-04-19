import { router } from '@kit.ArkUI';
import { addFriendRequest, FriendRequestForm, getFriendRequestList, Page } from '../../api/friendsApi';
import { showBottomError, showTopToast } from '../../utils/toast';
import { UserSimpleInfo } from '../../viewmodel/UserProfileModel';
import { EmptyPage } from '../components/EmptyPage';
import { FriendItem } from './component/FriendItem';
import { LoginPanel } from '@hms.core.account.LoginComponent';

@Entry
@Component
struct FriendRequest {
  private LOG = "[FriendRequest] "
  @State message: string = 'Hello World';
  @State friendRequests: UserSimpleInfo[] = []

  aboutToAppear(): void {
    // this.friendRequests.push(new UserSimpleInfo('2101510218','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1))
    // this.friendRequests.push(new UserSimpleInfo('19','老司机', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1))
    // this.friendRequests.push(new UserSimpleInfo('14','林键超', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '我自横刀向天笑，去留肝胆两昆仑', '', 1))
  }
  onPageShow(): void {
    console.log(this.LOG + 'onPageShow')
    getFriendRequestList().then((res: Page<UserSimpleInfo>)=>{
      console.log(this.LOG + 'getFriendRequestList: ' + JSON.stringify(res.list))
      this.friendRequests = res.list
    }).catch((e: string)=>{
      showBottomError(this.getUIContext(), e)
    })
  }
  @Builder
  TopBar() {
    Row({space: 10}) {
      Image($r('app.media.ic_left_arrow'))
        .width(25)
        .height(25)
        .onClick(()=>{
          router.back()
        })
      Text('申请列表')
        .fontSize(23)
        .fontColor(Color.Black)
      Row().width('10%')
    }
    .width('100%')
    .padding(10)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor(Color.White)
  }

  @Builder
  friendRequestList() {
    ForEach(this.friendRequests, (item: UserSimpleInfo)=>{
      FriendItem({info: item})
    })
  }
  build() {
    Column() {
      this.TopBar()
      if(this.friendRequests.length == 0) {
        EmptyPage()
      } else {
        this.friendRequestList()
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#f1f1f1')
  }
}