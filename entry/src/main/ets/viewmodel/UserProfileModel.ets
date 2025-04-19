import { getUserSimpleInfo } from "../api/userProfileApi";
import { AuthenticationToken } from "./AuthModel";
import { BusinessError } from "@kit.BasicServicesKit";

export class UserSimpleInfo{
  studentId: string;
  nickname: string;
  avatar: string;
  bio: string;
  gender?: number;
  deleteUrl?: string;
  status?: number;
  requestId?: string;
  constructor(studentId: string, nickname: string, avatar: string, bio: string, deleteUrl?: string, gender?: number, status?: number, requestId?: string) {
    this.studentId = studentId;
    this.nickname = nickname;
    this.avatar = avatar;
    this.gender = gender;
    this.bio = bio;
    this.deleteUrl = deleteUrl;
    this.status = status;
    this.requestId = requestId;
  }
}

export function initMineSimpleInfo() {
  const auth: AuthenticationToken = AppStorage.get('auth') as AuthenticationToken
  if(auth) {
    // console.log('initMineSimpleInfo初始化成功', JSON.stringify(auth))
    getUserSimpleInfo(auth.studentId).then((res) => {
      console.log('initMineSimpleInfo初始化成功', JSON.stringify(res))
      AppStorage.setOrCreate('mineSimpleInfo', res)
    }).catch((err: BusinessError) => {
      console.error('mineSimpleInfo初始化失败', err)
    })
  } else {
    console.error('initMineSimpleInfo初始化失败: auth is null')
  }
}