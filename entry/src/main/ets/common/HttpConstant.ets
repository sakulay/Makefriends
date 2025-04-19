export class HttpConstant{
  static PROTOCOL = ""
  static LOCAL_API_URL: string = "http://192.168.209.225:8989"
  static BASE_API_URL: string = "http://111.230.102.82:8989"
  static UPLOAD_URL: string = "http://111.230.102.82:40061/api/index.php"
  static UPLOAD_TOKEN: string = '1c17b11693cb5ec63859b091c5b9c1b2'
  static URL: string = this.LOCAL_API_URL
  static TOKEN_PRE = 'AppBearer '
  static TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50SWQiOiIxOSIsInN1YiI6IjE5IiwiZGF0YVNjb3BlIjowLCJleHAiOjE3NDQ4OTg4OTgsImlhdCI6MTc0NDg5MTY5OCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9TVFVERU5UIl0sImp0aSI6IjQyMzViMTBlMzE4MzRkYWY5MGMyZWQ2MzhiYmZhZDZkIn0.6-f4suTVSb5TZcelhxf4Bt_S65IbxyCDic08w0HCEp4"
  static AUTH_TOKEN: string = this.TOKEN_PRE + HttpConstant.TOKEN
}