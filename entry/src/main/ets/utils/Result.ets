export interface Result<T>{
  code: string | undefined
  msg: string | undefined
  data: T
}