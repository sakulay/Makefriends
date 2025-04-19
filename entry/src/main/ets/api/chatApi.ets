import { Unread } from "../model/MessageModel"
import { Get } from "../utils/request"

const CHAT_BASE_URL = "/api/v1/appChatMessages"
export class MessageModel{
  sender: string;
  receiver: string;
  content: string;

  constructor(sender: string, receiver: string, content: string) {
    this.sender = sender;
    this.receiver = receiver;
    this.content = content;
  }
}
export function getAppChatUnreads(id: string) {
  return Get<Array<Unread>, null>(
    `${CHAT_BASE_URL}/${id}/unread`
  )
}

export function getAppChatmessages(id: string, other: string) {
  return Get<Array<MessageModel>, null>(
    `${CHAT_BASE_URL}/${id}/${other}/messages`
  )
}

export function readed(sender: string,  receiver: string) {
  return Get<null, null>(
    `${CHAT_BASE_URL}/${sender}/${receiver}/readed`
  )
}