import { AuthenticationToken } from "../viewmodel/AuthModel";

export function getStudentId() {
  const auth: AuthenticationToken = AppStorage.get('auth') as AuthenticationToken
  if(auth) return auth.studentId
  else return ''
}