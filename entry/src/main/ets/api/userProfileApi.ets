import { Get, Post, Put } from "../utils/request";
import { UserSimpleInfo } from "../viewmodel/UserProfileModel";

const USER_PROFILE_BASE_URL = '/api/v1/appUserProfiles'
export function getUserSimpleInfo(studentId: string) {
  return Get<UserSimpleInfo, null>(
    `${USER_PROFILE_BASE_URL}/${studentId}/info`,
  )
}

export function updateUserProfile(studentId: string, formData: UserSimpleInfo) {
  return Put<null,UserSimpleInfo>(
    `${USER_PROFILE_BASE_URL}/student/${studentId}`,
    formData
  )
}