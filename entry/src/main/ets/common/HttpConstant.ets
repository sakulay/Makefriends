export class HttpConstant{
  static PROTOCOL = ''
  static DEV_DOMIN: string = "192.168.68.225"
  static PRO_DOMIN: string = "111.230.102.82"
  static DOMIN: string = HttpConstant.DEV_DOMIN
  static UPLOAD_URL: string = "http://111.230.102.82:40061/api/index.php"
  static UPLOAD_TOKEN: string = '1c17b11693cb5ec63859b091c5b9c1b2'
  static URL: string = `http://${HttpConstant.DOMIN}:8989`
  static TOKEN_PRE = 'AppBearer '
  static TOKEN = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdHVkZW50SWQiOiIxOSIsInN1YiI6IjE5IiwiZGF0YVNjb3BlIjowLCJleHAiOjE3NDQ4OTg4OTgsImlhdCI6MTc0NDg5MTY5OCwiYXV0aG9yaXRpZXMiOlsiUk9MRV9TVFVERU5UIl0sImp0aSI6IjQyMzViMTBlMzE4MzRkYWY5MGMyZWQ2MzhiYmZhZDZkIn0.6-f4suTVSb5TZcelhxf4Bt_S65IbxyCDic08w0HCEp4"
  static AUTH_TOKEN: string = this.TOKEN_PRE + HttpConstant.TOKEN
}