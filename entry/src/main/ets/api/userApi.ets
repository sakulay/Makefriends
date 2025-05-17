import { Delete, Put } from "../utils/request"

const USER_BASE_URL = `/api/v1/appUsers`

// 修改密码的请求参数接口
export interface UpdatePasswordForm {
  studentId: number
  newPassword: string
  oldPassword: string
}

// 修改密码
export function updatePassword(formData: UpdatePasswordForm) {
  return Put<null, UpdatePasswordForm>(
    `${USER_BASE_URL}/${formData.studentId}/password`,
    formData
  )
}

// 删除用户
export function deleteUser(studentId: string) {
  return Delete<null, void>(
    `${USER_BASE_URL}/${studentId}`
  )
} 