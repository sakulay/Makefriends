import { Client } from "@ohos/stompjs";
import { webSocket } from "@kit.NetworkKit";
import { BusinessError } from "@kit.BasicServicesKit";
import { MessageBase, TextDetailData } from "./Message";
import { dealImageResMsg } from "../utils/MessageUtils";
import { HttpConstant } from "../common/HttpConstant";
import { AuthenticationToken } from "../viewmodel/AuthModel";


let messageList = new TextDetailData()
const url: string = 'ws://192.168.209.225:8989/ws'
// const token: string = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50SWQiOiIxOSIsInN1YiI6IjE5IiwiZGF0YVNjb3BlIjowLCJleHAiOjE3NDUwMzg0MjYsImlhdCI6MTc0NTAzMTIyNiwiYXV0aG9yaXRpZXMiOlsiUk9MRV9TVFVERU5UIl0sImp0aSI6Ijc5OGJkNGY4NmViMjQyOWE4MDMxZjFjYzkzMTY3NDFmIn0.SEBeDf5n59w9vsbRGZwq2t21tFB4o2Dr4lIiySWeYYY'
const client: Client = new Client()
const ws = webSocket.createWebSocket()
const LOG = '[MessageModel]'

export class MessageModel {
  type: string;
  sender: string
  content: string;

  constructor(type: string, sender: string, content: string) {
    this.type = type;
    this.sender = sender;
    this.content = content;
  }
}
export enum MessageType {
  CHAT = "CHAT",
  UNREAD = "UNREAD"
}
export class Unread{
  sender: string;
  avatar: string;
  nickname: string;
  latestContent: string;
  unreadCount: string;
  constructor(sender: string, avatar: string, nickname: string, latestContent: string, unreadCount: string) {
    this.sender = sender;
    this.avatar = avatar;
    this.nickname = nickname;
    this.latestContent = latestContent;
    this.unreadCount = unreadCount;
  }
}

export function getUnreadList(): Array<Unread> {
  let list: Array<Unread> = []
  list.push(new Unread("19", "http://111.230.102.82:40061/i/2025/02/26/p1mi5m-0.jpg", "mike", "你好", '1'))
  list.push(new Unread("11", "http://111.230.102.82:40061/i/2025/02/26/p1mi5m-0.jpg", "anson", "你好1", '1'))
  list.push(new Unread("2101510218", "http://111.230.102.82:40061/i/2025/02/26/p1mi5m-0.jpg", "yuyu", "你好2", '1'))
  list.push(new Unread("4689", "http://111.230.102.82:40061/i/2025/02/26/p1mi5m-0.jpg", "ljc", "你好33333333", '1'))
  return list;
}
// 未读消息列表
let unreadList: Array<Unread> = getUnreadList();

export function initMessage() {
  // 全局设置未读消息列表
  AppStorage.setOrCreate("unread", unreadList)
  // 全局设置消息列表
  AppStorage.setOrCreate("message", messageList)
  // 全局设置已选聊天会话
  AppStorage.setOrCreate("selectedChat", '')
  // 全局设置ws
  AppStorage.setOrCreate("ws", ws)
  connect()
}
export function connect() {

  ws.on('open', (err: BusinessError, value: Object) => {
    if (err) {
      console.log("❌ 连接失败. Err:" + err.message);
      // this.message = '连接失败: ' + err.message + '\n' + this.message;
      return;
    }
    console.log("✅ WebSocket 连接成功");
    // this.message = '连接成功' + '\n' + this.message;
    // 发送 STOMP 连接请求
    const token = (AppStorage.get('auth') as AuthenticationToken).accessToken
    let connectFrame = "CONNECT\naccept-version:1.2\nAuthorization:AppBearer " + token + "\n\n\x00";
    ws.send(connectFrame, (err) => {
      if (err) {
        console.log("❌ STOMP 连接失败:", JSON.stringify(err));
      } else {
        console.log("✅ STOMP 连接请求已发送");
      }
    });
  })
  ws.on('close', (err: BusinessError, value: Object) => {
    if (err) {
      console.log("❌ WebSocket 关闭错误:", JSON.stringify(err));
      // this.message = '断开连接失败：' + err.message +'\n' + this.message;
      return;
    }
    console.log("✅ WebSocket 连接已关闭");
    // this.message = '断开连接' + '\n' + this.message;
  });
  ws.on('error', (err: BusinessError) => {
    console.log(LOG, "on error, error: " + JSON.stringify(err));
  });
  ws.on('message', (err: BusinessError, value: string | ArrayBuffer) => {
    if (err) {
      console.log("❌ WebSocket 消息错误:", JSON.stringify(err));
      return;
    }
    console.log("📩 收到消息:", value);

    if (typeof value === 'string') {
      if (value.startsWith("CONNECTED")) {
        console.log("✅ STOMP 连接成功");
        // 订阅消息
        let subscribeFrame1 = "SUBSCRIBE\nid:sub-0\ndestination:/user/queue/greeting\nack:auto\nreceipt:sub-receipt-1\n\n\x00";
        ws.send(subscribeFrame1, (err)=>{subscribeHandle(err)});
        let subscribeFrame2 = "SUBSCRIBE\nid:sub-1\ndestination:/topic/notice\nack:auto\nreceipt:sub-receipt-2\n\n\x00";
        ws.send(subscribeFrame2, (err)=>{subscribeHandle(err)});
        let subscribeFrame3 = "SUBSCRIBE\nid:sub-2\ndestination:/user/queue/unread\nack:auto\nreceipt:sub-receipt-3\n\n\x00";
        ws.send(subscribeFrame3, (err)=>{subscribeHandle(err)});

      } else if (value.startsWith("RECEIPT")) {
        console.log("✅ 订阅成功！");
      } else {
        let lines = value.split("\n");  // 按行拆分
        let lastLine = lines[lines.length - 1];  // 获取最后一行
        let message = JSON.parse(lastLine) as MessageModel; // 拿到消息
        // 如果是聊天消息
        if (message.type === MessageType.CHAT) {
          console.log("📥 收到聊天消息:", message.content);
          const textDetailData = AppStorage.get('textDetailData') as TextDetailData
          // 如果开启会话，则更新聊天记录
          if(textDetailData) {
            const messageBase = new MessageBase(false, '', AppStorage.get('imageOther') as string, AppStorage.get('msgMaxWidth') as number)
            dealImageResMsg(messageBase, message.content)
            textDetailData.pushData(messageBase)
          }
        }
        else if (message.type === MessageType.UNREAD) { // 未读消息
          console.log("📥 收到未读消息:", message.content);
          // 未读消息是现在进行的会话
          let selectedChat: string | undefined = AppStorage.get('selectedChat')
          if(selectedChat !== '' && selectedChat == message.sender) return
          // 未读消息不是现在进行的会话
          const found = unreadList.find(item => item.sender === message.sender);
          // 未读消息存在
          if(found) {
            found.unreadCount = message.content.split('@')[0]
            found.latestContent = message.content.split('@')[1]
          } else {
            // 未读消息不存在
            unreadList.push(message2Unread(message))
          }
          AppStorage.set("unread", unreadList)
        }
      }
    }
  });
  ws.connect(url)
}
export function disconnect() {
  if(ws) {
    ws.close()
  }
}

function subscribeHandle(err: BusinessError){
  if (err) {
    console.log("❌ 订阅失败:", JSON.stringify(err));
  } else {
    console.log("✅ user/queue/greeting订阅请求已发送");
  }
}

function message2Unread(message: MessageModel) {
  let avatar = 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg'
  let nickname = '未命名'
  return new Unread(
    message.sender,
    avatar,
    nickname,
    message.content.split('@')[1],
    message.content.split('@')[0]
  )
}

export function sendChatMessage(toUsername: string, content: string) {
  const user = AppStorage.get('selectedChat') as string
  const sendFrame =
    "SEND\n" +
      `destination:/app/sendToUser/${user}\n` +
      "content-type:application/json\n" +
      "\n" +
      `${JSON.stringify(content)}` + "\x00";

  ws.send(sendFrame, (err) => {
    if (err) {
      console.log("❌ 消息发送失败:", JSON.stringify(err));
    } else {
      console.log("✅ 消息已发送:", content);
    }
  });
}
