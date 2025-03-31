import { Client } from "@ohos/stompjs";
import { webSocket } from "@kit.NetworkKit";
import { BusinessError } from "@kit.BasicServicesKit";

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

export function getUnreadList(): Array<MessageModel> {
  let list: Array<MessageModel> = []
  list.push(new MessageModel(MessageType.UNREAD, "mike", "2"))
  list.push(new MessageModel(MessageType.UNREAD, "anson", "3"))
  list.push(new MessageModel(MessageType.UNREAD, "yuyu", "4"))
  list.push(new MessageModel(MessageType.UNREAD, "ljc", "10"));
  list.push(new MessageModel(MessageType.UNREAD, "mike", "2"))
  list.push(new MessageModel(MessageType.UNREAD, "anson", "3"))
  list.push(new MessageModel(MessageType.UNREAD, "yuyu", "4"))
  list.push(new MessageModel(MessageType.UNREAD, "ljc", "10"));
  list.push(new MessageModel(MessageType.UNREAD, "mike", "2"))
  list.push(new MessageModel(MessageType.UNREAD, "anson", "3"))
  list.push(new MessageModel(MessageType.UNREAD, "yuyu", "4"))
  list.push(new MessageModel(MessageType.UNREAD, "ljc", "10"));
  list.push(new MessageModel(MessageType.UNREAD, "mike", "2"))
  list.push(new MessageModel(MessageType.UNREAD, "anson", "3"))
  list.push(new MessageModel(MessageType.UNREAD, "yuyu", "4"))
  list.push(new MessageModel(MessageType.UNREAD, "ljc", "10"));
  return list;
}
let unreadList: Array<MessageModel> = getUnreadList();
const url: string = 'ws://192.168.46.225:8989/ws'
const token: string = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0IiwiZGVwdElkIjozLCJkYXRhU2NvcGUiOjEsImV4cCI6MTc0MzI3NDYwNiwidXNlcklkIjozLCJpYXQiOjE3NDMyNjc0MDYsImF1dGhvcml0aWVzIjpbIlJPTEVfQURNSU4xIl0sImp0aSI6IjMwN2Q3OGM5ZDFjMjQ5NGNiYTZhZGY4ODE5ZjFkYmY4In0.OE3AXRbZB6dXnJlyZufPJREcGKOQ9_bf-ZdLxvuVVuY'
const client: Client = new Client()
const ws = webSocket.createWebSocket()

export function initMessage() {
  AppStorage.setOrCreate("unread", unreadList)
  console.log("messageModel: ", unreadList.toString())
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
    let connectFrame = "CONNECT\naccept-version:1.2\nAuthorization:Bearer " + token + "\n\n\x00";
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
    console.log("on error, error:" + JSON.stringify(err));
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
        let message = JSON.parse(lastLine) as MessageModel;
        if (message.type === MessageType.CHAT) {
          console.log("📥 收到聊天消息:", message.content);
        } else if (message.type === MessageType.UNREAD) {
          console.log("📥 收到未读消息:", message.content);
          unreadList.push(message)
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