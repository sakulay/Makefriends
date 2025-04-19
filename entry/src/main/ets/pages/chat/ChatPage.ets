import { FaceGridConstants, SpanType } from "../../common/ChatConstants";
import { MessageBase, SpanItem, TextDetailData } from "../../model/Message";
import { logger } from "../../utils/Logger";
import { display, KeyboardAvoidMode, router } from "@kit.ArkUI";
import { common } from "@kit.AbilityKit";
import window from '@ohos.window';
import { EmojiData, LastEmojiData } from "../../model/Emoji";
import { inputMethod } from "@kit.IMEKit";
import { EmojiKeyboard } from "../View/EmojiKeyboard";
import { dealImageResMsg } from "../../utils/MessageUtils";
import { mockInfo } from "../../utils/Mock";
import { webSocket } from "@kit.NetworkKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { sendChatMessage } from "../../model/MessageModel";
import { getStudentId } from "../../utils/utils";
import { getAppChatmessages, MessageModel, readed } from "../../api/chatApi";
import { UserSimpleInfo } from "../../viewmodel/UserProfileModel";
import { getUserSimpleInfo } from "../../api/userProfileApi";
import { searchFriend } from "../../api/friendsApi";
import { showBottomError } from "../../utils/toast";

interface Params{
  msg: MessageBase,
  userInfo: UserSimpleInfo
}
const TAG = '[ChatWithExpression]';
const DESIGN_WIDTH: number = 640; // 设计宽度
const STROKE_WIDTH: number = 2; // strokeWidth的宽度
const LAYOUT_WEIGHT: number = 1; // layoutWeight参数
// 定义聊天界面布局信息
const HEAD_IMAGE_EDGE_PADDING: number = 5; // 头像到左右两边的padding
const HEAD_IMAGE_MSG_PADDING: number = 10; // 头像到聊天信息paddding
const MSG_TOP_BOTTOM_PADDING: number = 5; // 聊天信息上下paddding
const MSG_LEFT_RIGHT_PADDING: number = 20; // 聊天信息左右paddding
const MSG_HEADIMG_SIZE: number = 50; // 用户头像尺寸
//
const EMOJI_SRC_POS: number = 19; // 图片路径在资源中的开始位置（resource://RAWFILE/01.png截为01.png）

// 用户信息:昵称、头像
const USER_NAME_MYSELF: string = '张三';
const USER_NAME_OTHER: string = '李四';
const DELAY_TIME: number = 200; // 延时时间

@Entry
@Component
struct ChatPage {
  private TAG = '[ChatPage]'
  @StorageProp('ws') ws: webSocket.WebSocket = webSocket.createWebSocket();
  // 滚动条组件
  private scroller: Scroller = new Scroller();
  // 键盘安全高度
  @StorageLink('keyboardHeight') keyboardHeight: number = 0;
  // 发送的信息条数
  @State msgNums: number = 0;
  @State isFaceDlgOpen: boolean = false; // 表情对话框打开状态
  private isFaceClick = false; // 表情按钮是否点击
  // 组件的控制器
  controllerRich: RichEditorController = new RichEditorController();
  // 聊天信息数据
  private textDetailData = new TextDetailData();
  // 最近使用表情
  @State lastEmojiData: LastEmojiData = new LastEmojiData();
  // 聊天输入框配置
  private start: number = -1;
  private end: number = -1;
  private focusKey = 'msg_input'; // 输入框焦点
  private message = ""
  // 聊天信息参数
  private screenWidth: number = 0; // 屏幕宽度
  private msgFontSize: number = 0; // 字体
  private msgMaxWidth: number = 0; // 聊天信息最大宽度
  @State otherInfo: UserSimpleInfo = new UserSimpleInfo('2101510218', '李伟良', '', '');
  @State mineInfo: UserSimpleInfo = new UserSimpleInfo('2101510218', '李伟良', '', '');
  @State HEAD_IMAGE_MYSELF: string = 'photo1.jpg';
  @State HEAD_IMAGE_OTHER: string = 'photo0.jpg';
  @State isLoading: boolean = true;

  async aboutToAppear(): Promise<void> {
    const displayData: display.Display = display.getDefaultDisplaySync();
    this.screenWidth = px2vp(displayData.width);

    // 根据设计稿及屏幕宽度计算fontsize及行间距
    this.msgFontSize = this.screenWidth * 100 / DESIGN_WIDTH; // 100,百分比
    logger.info(TAG, 'FontSize:' + this.msgFontSize.toString());
    // 聊天信息最大宽度
    this.msgMaxWidth =
      (this.screenWidth - HEAD_IMAGE_EDGE_PADDING * 2 - HEAD_IMAGE_MSG_PADDING * 2 - MSG_HEADIMG_SIZE * 2) *
        0.95; // 2、0.95 聊天内容最大长度设为两个聊天对象之间宽度的95%
    // 初始化双方信息
    await this.initMineAndOtherInfo()
    // 获取聊天信息
    // this.getChatMessage()
    this.initChatMessages()
    // 全局共享聊天信息
    AppStorage.setOrCreate('textDetailData', this.textDetailData)
    // 全局加载对方头像
    AppStorage.setOrCreate('imageOther', this.HEAD_IMAGE_OTHER)
    // 全局共享聊天信息最大宽度
    AppStorage.setOrCreate('msgMaxWidth', this.msgMaxWidth)
    //
    this.ws = AppStorage.get('ws') as webSocket.WebSocket;
    let context = getContext(this) as common.UIAbilityContext;
    context.windowStage.getMainWindowSync().getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE);
    window.getLastWindow(getContext(this)).then(currentWindow => {
      // 监视软键盘的弹出和收起
      currentWindow.on('avoidAreaChange', async data => {
        if (data.type !== window.AvoidAreaType.TYPE_KEYBOARD) {
          return;
        }
        const bottomAvoidArea = currentWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR)
          .bottomRect
          .height;
        currentWindow.on('keyboardHeightChange', (data) => {
          if (data > 0) {
            AppStorage.setOrCreate('keyboardHeight', data - bottomAvoidArea);
          } else {
            AppStorage.setOrCreate('keyboardHeight', 0);
          }
          logger.info(TAG, 'keyboardHeight data:' + data.toString() + ',bottomAvoidArea:' +
          bottomAvoidArea.toString());
        })
        // TODO 知识点：点击表情按钮之后，等待系统软键盘关闭后再延迟刷新表情键盘，避免屏幕闪烁
        if (data.area.bottomRect.height === 0 && this.isFaceClick === true) {
          // 200毫秒之后执行
          setTimeout(async () => {
            this.isFaceDlgOpen = true;
          }, DELAY_TIME)
        }
      })
    })
  }
  aboutToDisappear(): void {
    // 全局共享聊天信息
    AppStorage.delete('textDetailData')
    // 全局加载对方头像
    AppStorage.delete('imageOther')
    AppStorage.delete('msgMaxWidth')
    this.isFaceDlgOpen = false;
    this.isFaceClick = false;
  }

  /**
   * 获取聊天记录
   */
  getChatMessage() {
    // 预加载三条聊天信息
    const chatMsg1: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_1"));
    let msgBase1 = new MessageBase(true, USER_NAME_MYSELF, this.HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    dealImageResMsg(msgBase1, chatMsg1);
    this.textDetailData.pushData(msgBase1);

    const chatMsg2: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_2"));
    let msgBase2 = new MessageBase(false, USER_NAME_OTHER, this.HEAD_IMAGE_OTHER, this.msgMaxWidth);
    dealImageResMsg(msgBase2, chatMsg2);
    this.textDetailData.pushData(msgBase2);

    const chatMsg3: string = getContext(this)
      .resourceManager
      .getStringSync($r("app.string.chat_with_expression_msg_3"));
    let msgBase3 = new MessageBase(true, USER_NAME_MYSELF, this.HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    dealImageResMsg(msgBase3, chatMsg3);
    this.textDetailData.pushData(msgBase3);
  }
  /**
   * 初始化聊天信息
   */
  initChatMessages() {
    const other = AppStorage.get('selectedChat') as string
    const me = getStudentId()
    getAppChatmessages(getStudentId(), other).then((res: Array<MessageModel>) => {
      console.log(this.TAG, '获取聊天记录成功', JSON.stringify(res))
      res.forEach((item: MessageModel) => {

        if(item.sender == me) {
          let msgBase = new MessageBase(true, USER_NAME_MYSELF, this.HEAD_IMAGE_MYSELF, this.msgMaxWidth);
          dealImageResMsg(msgBase, item.content)
          this.textDetailData.pushData(msgBase)
        } else {
          let msgBase = new MessageBase(false, USER_NAME_OTHER, this.HEAD_IMAGE_OTHER, this.msgMaxWidth);
          dealImageResMsg(msgBase, item.content)
          this.textDetailData.pushData(msgBase)
        }
      })
    }).catch((err: string)=>{
      console.log(this.TAG, '获取聊天记录失败', err)
    })
  }
  /**
   * 初始化双方信息
   */
  async initMineAndOtherInfo() {
    this.mineInfo = AppStorage.get('mineSimpleInfo') as UserSimpleInfo
    this.HEAD_IMAGE_MYSELF = this.mineInfo.avatar
    // const other = AppStorage.get('selectedChat') as string
    await searchFriend(getStudentId(), AppStorage.get('selectedChat') as string).then((res: UserSimpleInfo) => {
      console.log(TAG, '获取对方信息成功', JSON.stringify(res))
      this.HEAD_IMAGE_OTHER = res.avatar
      this.otherInfo = res
      this.isLoading = false
    }).catch((err: string) => {
      console.error(TAG, '获取对方信息失败', err)
    })
  }
  /**
   * 发送聊天消息
   */
  async sendChatMsg(): Promise<void> {
    let msgBase = new MessageBase(true, USER_NAME_MYSELF, this.HEAD_IMAGE_MYSELF, this.msgMaxWidth);
    // 清空message
    this.message = ""
    // 获取发送信息
    this.controllerRich.getSpans({
      start: this.start,
      end: this.end
    }).forEach(item => {
      if (typeof (item as RichEditorImageSpanResult)['imageStyle'] !== 'undefined') {
        // TODO 知识点：处理imagespan信息
        const imageMsg: ResourceStr | undefined = (item as RichEditorImageSpanResult).valueResourceStr;
        if (imageMsg !== undefined) {
          const spanItem: SpanItem = new SpanItem(SpanType.IMAGE, '', imageMsg.toString().substring(EMOJI_SRC_POS));
          msgBase.spanItems.push(spanItem);
          this.message += imageMsg.toString()
        }
      } else {
        // TODO 知识点：处理文字span信息
        const textMsg: string = (item as RichEditorTextSpanResult).value;
        const spanItem: SpanItem = new SpanItem(SpanType.TEXT, textMsg, '');
        msgBase.spanItems.push(spanItem);
        this.message += textMsg
      }
    })
    logger.info(TAG, '发送的消息内容:' + this.message);
    // 发送
    if (msgBase.spanItems.length !== 0) {
      this.textDetailData.pushData(msgBase);
      sendChatMessage("admin", this.message)
      logger.info(TAG, '消息列表:' + JSON.stringify(this.textDetailData.msgList));
      this.msgNums = this.textDetailData.totalCount();
      this.controllerRich.deleteSpans();
      this.controllerRich.setCaretOffset(-1);
    }
    this.scroller.scrollEdge(Edge.Bottom);
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_left_arrow'))
          .width(20)
          .height(20)
          .onClick(() => {
            readed(this.otherInfo.studentId, getStudentId()).then(() => {
              AppStorage.set("selectedChat", "")
              router.back();
            }).catch((err: string) => {
              showBottomError(this.getUIContext(), err)
            })

          })
        Column() {
          Text(this.otherInfo.nickname)
            .fontSize(20)
          Text(this.otherInfo.studentId)
            .fontSize(14)
        }
        .padding({left: 20, top: 5})
        .alignItems(HorizontalAlign.Start)
        .layoutWeight(1)
        .height(50)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/friends/InfoCard',
            params: mockInfo()
          })
        })
      }
      .width('100%')
      .height(50)
      .padding({left: 10})
      .backgroundColor(Color.White)
      // 聊天对话框
      List({
        scroller: this.scroller,
        initialIndex: this.msgNums - 1
      }) {
        LazyForEach(this.textDetailData, (msg: MessageBase) => {
          ListItem() {
            if (msg.isSelf) {
              MessageItemSelfView({ msg: msg, userInfo: this.mineInfo});
            } else {
              MessageItemView({ msg: msg,  userInfo: this.otherInfo });
            }
          }
        })
      }
      .onAreaChange(() => {
        // 控制列表滚动条到底部
        this.scroller.scrollEdge(Edge.Bottom);
      })
      .alignSelf(ItemAlign.End)
      .align(Alignment.End)
      .listDirection(Axis.Vertical)
      .divider({
        strokeWidth: STROKE_WIDTH,
        color: $r('app.color.chat_with_expression_detail_divider')
      })
      .padding({
        left: $r('app.integer.chat_with_expression_list_padding_left'),
        right: $r('app.integer.chat_with_expression_list_padding_right'),
        bottom: $r('app.integer.chat_with_expression_list_padding_bottom')
      })
      .width($r('app.string.chat_with_expression_layout_100'))
      .height($r('app.string.chat_with_expression_layout_80'))
      .layoutWeight(LAYOUT_WEIGHT)
      // 底部输入框
      Row() {
        Image($r('app.media.chatting_mode_voice'))
          .id('img_voice')
          .height($r('app.integer.chat_with_expression_opt_layout_voice_image_width'))
          .margin({
            left: $r('app.integer.chat_with_expression_chat_font_size'),
            right: $r('app.integer.chat_with_expression_chat_font_size')
          })
        // 输入框
        RichEditor({ controller: this.controllerRich })
          .height($r('app.integer.chat_with_expression_chat_input_height'))
          .layoutWeight(LAYOUT_WEIGHT)
          .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
          .backgroundColor($r('app.string.chat_with_expression_input_background'))
          .key(this.focusKey)
          .id(this.focusKey)
          .defaultFocus(false)
          .onClick(async () => {
            this.isFaceDlgOpen = false;
            this.isFaceClick = false;
          })
        // 表情功能
        Image($r('app.media.express'))
          .height($r('app.integer.chat_with_expression_chat_express_size'))
          .width($r('app.integer.chat_with_expression_chat_express_size'))
          .margin({
            top: $r('app.integer.chat_with_expression_express_margin_top'),
            left: $r('app.integer.chat_with_expression_express_margin_left')
          })
          .id('faceBtn')
          .onClick(async () => {
            logger.info(TAG, 'face onClick keyboardHeight=' + this.keyboardHeight.toString());
            // 系统软键盘关闭状态下直接打开
            if (this.keyboardHeight <= 0) {
              if (this.isFaceDlgOpen === false) {
                this.isFaceDlgOpen = true;
              } else {
                this.isFaceDlgOpen = false;
              }
            } else {
              // 系统软键盘打开状态下先关闭软键盘再延迟打开
              this.isFaceClick = true;
              const inputMethodController = inputMethod.getController();
              inputMethodController.stopInputSession();
            }
          })
        Button($r('app.string.chat_with_expression_input_button'))
          .id('btn_sendMsg')
          .height($r('app.integer.chat_with_expression_chat_input_height'))
          .borderRadius($r('app.integer.chat_with_expression_btn_border_radius'))
          .width($r('app.integer.chat_with_expression_send_button_width'))
          .margin({
            left: $r('app.integer.chat_with_expression_chat_font_size'),
            right: $r('app.integer.chat_with_expression_chat_font_size')
          })
          .fontColor(Color.White)
          .backgroundColor(Color.Green)
          .onClick(async () => {
            this.sendChatMsg();
          })
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .borderRadius({
        topLeft: $r('app.integer.chat_with_expression_chat_border_radius'),
        topRight: $r('app.integer.chat_with_expression_chat_border_radius')
      })
      .backgroundColor(Color.White)
      .width($r('app.string.chat_with_expression_layout_100'))
      .padding({
        top: $r('app.integer.chat_with_expression_chat_outline_padding'),
        bottom: $r('app.integer.chat_with_expression_chat_outline_padding')
      })
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])

      // TODO 知识点：通过变量控制表情键盘的显示
      if (this.isFaceDlgOpen) {
        Column() {
          // 最近使用的表情
          if (this.lastEmojiData.totalCount() > 0) {
            Text($r('app.string.chat_with_expression_last_emoji')).alignSelf(ItemAlign.Start)
              .margin($r('app.integer.chat_with_expression_chat_margin_top'))
              .id('txt_last_face')
            // 表情键盘组件
            EmojiKeyboard({
              controllerRich: this.controllerRich,
              msgFontSize: this.msgFontSize,
              lastEmojiData: this.lastEmojiData,
              emojiList: this.lastEmojiData.emojiList
            })
          }
          // 全部表情
          Text($r('app.string.chat_with_expression_all_emoji')).alignSelf(ItemAlign.Start)
            .id('txt_all_face')
            .margin($r('app.integer.chat_with_expression_chat_margin_top'))
          // 表情键盘组件
          EmojiKeyboard({
            controllerRich: this.controllerRich,
            msgFontSize: this.msgFontSize,
            lastEmojiData: this.lastEmojiData,
            emojiList: EmojiData
          })
        }
      }
    }
    .onClick(() => {
      // 点击收起键盘
      inputMethod.getController().stopInputSession();
      this.isFaceDlgOpen = false;
    })
    .backgroundColor($r('app.color.chat_with_expression_message_body_background'))
    .height($r('app.string.chat_with_expression_layout_100'))
  }
}
/**
 * ---------------------------------
 *
 *
 *
 *
 *
 *
 * ---------------------------------
 */
// 本人单条聊天信息
@Component
@Reusable
export struct MessageItemSelfView {
  @State msg: MessageBase = new MessageBase(true, '', '', 0);

  @State userInfo: UserSimpleInfo = new UserSimpleInfo('', '', '', '');

  aboutToReuse(params: object) {
    const realParams = params as Params;
    this.msg = realParams.msg;
    this.userInfo = realParams.userInfo;
  }

  build() {
    Row() {
      // 聊天信息
      Row() {
        Text(undefined) {
          // TODO: 性能知识点：使用ForEach组件循环渲染数据
          ForEach(this.msg.spanItems, (item: SpanItem) => {
            // TODO 知识点：分别使用ImageSpan、Span渲染图片、文字信息
            if (item.spanType === SpanType.IMAGE) {
              ImageSpan($rawfile(item.imgSrc as string))
                .width($r('app.integer.chat_with_expression_chat_font_size'))
                .height($r('app.integer.chat_with_expression_chat_font_size'))
                .margin(FaceGridConstants.EMOJI_MARGIN)
                .verticalAlign(ImageSpanAlignment.BOTTOM)
                .objectFit(ImageFit.Cover)
            } else if (item.spanType === SpanType.TEXT) {
              Span(item.text)
            }
          })
        }.constraintSize({
          minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
          maxWidth: this.msg.maxWidth
        })
        .textAlign(TextAlign.Start)
      }
      .constraintSize({
        minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
        minWidth: $r('app.string.chat_with_expression_layout_10'),
        maxWidth: this.msg.maxWidth
      })
      .borderRadius($r('app.integer.chat_with_expression_chat_item_border'))
      .backgroundColor($r('app.color.chat_with_expression_detail_item_message_background'))
      .padding({
        top: MSG_TOP_BOTTOM_PADDING,
        bottom: MSG_TOP_BOTTOM_PADDING,
        left: MSG_LEFT_RIGHT_PADDING,
        right: MSG_LEFT_RIGHT_PADDING
      })
      // 用户头像
      Image(this.msg.profilePicture)
        .objectFit(ImageFit.Fill)
        .width(MSG_HEADIMG_SIZE)
        .height(MSG_HEADIMG_SIZE)
        .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
        .margin({
          top: 0,
          left: HEAD_IMAGE_MSG_PADDING,
          right: HEAD_IMAGE_EDGE_PADDING,
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/friends/InfoCard',
            params: this.userInfo
          })
        })
    }
    .width($r('app.string.chat_with_expression_layout_100'))
    .margin({
      top: $r('app.integer.chat_with_expression_chat_margin_top'),
    })
    .justifyContent(FlexAlign.End)
  }
}
// 对方单条聊天信息
@Component
@Reusable
export struct MessageItemView {
  @State msg: MessageBase = new MessageBase(true, '', '', 0);
  @State userInfo: UserSimpleInfo = new UserSimpleInfo('', '', '', '');

  aboutToReuse(params: object) {
    const realParams = params as Params;
    this.msg = realParams.msg;
    this.userInfo = realParams.userInfo;
  }

  build() {
    Row() {
      // 用户头像
      Image(this.msg.profilePicture)
        .objectFit(ImageFit.Fill)
        .width(MSG_HEADIMG_SIZE)
        .height(MSG_HEADIMG_SIZE)
        .borderRadius($r('app.integer.chat_with_expression_chat_border_radius'))
        .margin({
          top: 0,
          left: HEAD_IMAGE_EDGE_PADDING,
          right: HEAD_IMAGE_MSG_PADDING,
        })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/friends/InfoCard',
            params: this.userInfo
          })
        })
      // 聊天信息
      Row() {
        Text(undefined) {
          // TODO: 性能知识点：使用ForEach组件循环渲染数据
          ForEach(this.msg.spanItems, (item: SpanItem) => {
            // TODO 知识点：分别使用ImageSpan、Span渲染图片、文字信息
            if (item.spanType === SpanType.IMAGE) {
              ImageSpan($rawfile(item.imgSrc as string))
                .width($r('app.integer.chat_with_expression_chat_font_size'))
                .height($r('app.integer.chat_with_expression_chat_font_size'))
                .verticalAlign(ImageSpanAlignment.BOTTOM)
                .margin(FaceGridConstants.EMOJI_MARGIN)
                .objectFit(ImageFit.Cover)
            } else if (item.spanType === SpanType.TEXT) {
              Span(item.text)
            }
          })
        }.constraintSize({
          minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
          maxWidth: this.msg.maxWidth
        })
        .textAlign(TextAlign.Start)
      }
      .constraintSize({
        minHeight: $r('app.integer.chat_with_expression_chat_inline_height'),
        minWidth: $r('app.string.chat_with_expression_layout_10'),
        maxWidth: this.msg.maxWidth
      })
      .borderRadius($r('app.integer.chat_with_expression_chat_item_border'))
      .backgroundColor(Color.White)
      .padding({
        top: MSG_TOP_BOTTOM_PADDING,
        bottom: MSG_TOP_BOTTOM_PADDING,
        left: MSG_LEFT_RIGHT_PADDING,
        right: MSG_LEFT_RIGHT_PADDING
      })
    }
    .width($r('app.string.chat_with_expression_layout_100'))
    .margin({
      top: $r('app.integer.chat_with_expression_chat_margin_top'),
    })
    .justifyContent(FlexAlign.Start)
  }
}