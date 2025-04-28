import { TAG } from "@ohos/hypium/src/main/Constant";
import { SpanType } from "../common/ChatConstants";
import { MessageBase, SpanItem } from "../model/Message";
import { logger } from "./Logger";

const EMOJI_RESOURCE: string = 'resource:'; // 资源前缀
const EMOJI_SUFFIX: string = '.png'; // 资源图片后缀
const EMOJI_FILENAME_LEN: number = 2; // 图片名长度
/**
 * 将聊天信息中的文字、表情分别解析为span、imageSpan
 * @param strMessage 聊天内容, msgBase 聊天消息结构
 */
export function dealImageResMsg(msgBase: MessageBase, strMessage: string): void {
  let strContent: string = ''; // 聊天内容
  // TODO 知识点：循环解析聊天信息中的表情以及文字
  let pos: number = strMessage.indexOf(EMOJI_RESOURCE);
  while (pos !== -1) {
    // 从pos后面找到.png所在位置
    const posPng = strMessage.indexOf(EMOJI_SUFFIX, pos);
    // 获取信息表情前面部分文字并插入span
    strContent += strMessage.substring(0, pos);
    if (strContent !== '') {
      // 插入span
      const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strContent, '');
      msgBase.spanItems.push(spanItem);
      strContent = '';
    }
    if (posPng !== -1) {
      // 获取表情资源
      const imgSrc: string = strMessage.substring(posPng - EMOJI_FILENAME_LEN, posPng + EMOJI_SUFFIX.length);
      // 插入imageSpan
      const spanItem: SpanItem = new SpanItem(SpanType.IMAGE, '', imgSrc);
      msgBase.spanItems.push(spanItem);
      // 信息重新初始话为表情后面部分
      strMessage = strMessage.substring(posPng + EMOJI_SUFFIX.length);
    } else {
      // 没匹配到.png，显示为文字
      strContent += EMOJI_RESOURCE;
      // 插入插入span
      const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strContent, '');
      msgBase.spanItems.push(spanItem);
      // 获取剩余聊天信息
      strMessage = strMessage.substring(pos + EMOJI_RESOURCE.length);
      // 清空当前span
      strContent = '';
    }
    pos = strMessage.indexOf(EMOJI_RESOURCE);
  }
  // 插入剩余聊天内容到span
  const spanItem: SpanItem = new SpanItem(SpanType.TEXT, strMessage, '');
  msgBase.spanItems.push(spanItem);
  logger.info(TAG, 'spanItem len:' + msgBase.spanItems.length.toString());
}