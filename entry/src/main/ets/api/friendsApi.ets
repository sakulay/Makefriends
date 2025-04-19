import { Get, Post, Put } from "../utils/request";
import {UserSimpleInfo } from "../viewmodel/UserProfileModel";

const FRIEND_BASE_URL = "/api/v1/appFriends"
  const FRIEND_REQUEST_BASE_URL = "/api/v1/appFriendRequests"
/**
 * 分页数据类型
 */
export class Page<T>{
  list: T[] = [];
  total: number;
  constructor(list: T[], total: number) {
    this.list = list;
    this.total = total
  }

  static fromJson<T, R>(data: R[], mapper: (item: R) => T, total: number): Page<T> {
    return new Page<T>(data.map(mapper), total);
  }
}
/**
 * 好友请求表单
 */
export class FriendRequestForm{
  senderId: string;
  receiverId: string;
  constructor(senderId: string, receiverId: string) {
    this.senderId = senderId;
    this.receiverId = receiverId;
  }
}
/**
 * 获取好友列表
 * @param studentId
 * @param nickname
 * @returns
 */
export function getFriendsList(studentId: string, nickname?: string) {
  return Get<Page<UserSimpleInfo>, string>(
    `${FRIEND_BASE_URL}/student/${studentId}`,
    nickname
  )
}
/**
 * 搜索好友
 * @param studentId
 * @param friendId
 * @returns
 */
export function searchFriend(studentId: string, friendId: string) {
  return Get<UserSimpleInfo, null>(
    `${FRIEND_BASE_URL}/friendInfo/${studentId}/${friendId}`
  )
}
/**
 * 添加好友
 * @param form
 * @returns
 */
export function addFriendRequest(form: FriendRequestForm) {
  return Post<null, FriendRequestForm>(
    `${FRIEND_REQUEST_BASE_URL}`,
    form
  )
}
/**
 * 获取好友请求列表
 * @param studentId
 * @returns
 */
export function getFriendRequestList() {
  return Get<Page<UserSimpleInfo>, null>(
    `${FRIEND_REQUEST_BASE_URL}/infoPage`
  )
}
/**
 * 通过好友请求
 * @param id
 * @returns
 */
export function passFriendRequest(id: string) {
  return Put<null,null>(
    `${FRIEND_REQUEST_BASE_URL}/passRequest/${id}`
  )
}
/**
 * 拒绝好友请求
 * @param id
 * @returns
 */
export function rejectFriendRequest(id: string) {
  return Put<null,null>(
    `${FRIEND_REQUEST_BASE_URL}/rejectRequest/${id}`
  )
}
