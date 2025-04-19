import { http } from '@kit.NetworkKit'
import { HttpConstant } from '../common/HttpConstant'
import { HeaderContentType } from '../common/HeaderContentType';
import { BusinessError } from '@kit.BasicServicesKit';
import { Result } from '../utils/Result'
import { ErrorContants } from '../common/ErrorContants';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import { Get } from '../utils/request';

export class Upload {
  result: string;
  code: number;
  url: string;
  srcName: string;
  thumb: string;
  del: string;
  constructor(result: string, code: number, url: string, srcName: string, thumb: string, del: string) {
    this.result = result;
    this.code = code;
    this.url = url;
    this.srcName = srcName;
    this.thumb = thumb;
    this.del = del;
  }
}
export function upload(file: string, context: common.UIAbilityContext): Promise<Upload> {
  const cacheDir = context.cacheDir
  const resFile = fs.openSync(file, fs.OpenMode.READ_ONLY)
  let newPath = cacheDir + "/" + resFile.name;
  fs.copyFileSync(resFile.fd, newPath)
  let realUri = "internal://cache/" + resFile.name;
  console.log("realUri: " + realUri)
  const mutiFormData: Array<http.MultiFormData>  =   [
    {
      name: 'image',
      contentType: 'image/jpeg',
      filePath: newPath
    },
    {
      name: 'token',
      contentType: 'text/plain',
      data: HttpConstant.UPLOAD_TOKEN
    }
  ]
  return request(mutiFormData)
}

export class DeleteResult{
  code: number;
  msg: string;
  constructor(code: number, msg: string) {
    this.code = code;
    this.msg = msg;
  }
}
export function deletePic(url: string) {
  return new Promise((resolve: (value: DeleteResult)=>void, reject: (value: string)=>void)=>{
    let httpRequest = http.createHttp();
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      url,
      {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': HeaderContentType.APPLICATION_JSON
        },
      },
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          console.log("data.result: "+ data.result)
          let res: DeleteResult = JSON.parse(`${data.result}`)
          if(res.code == 200) {
            resolve(res)
          } else {
            reject("删除失败")
          }

          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        } else {
          console.error('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );
  })
}

function request(data: Array<http.MultiFormData>) {
  // 每一个httpRequest对应一个HTTP请求任务，不可复用
  let httpRequest = http.createHttp();
  // 用于订阅HTTP响应头，此接口会比request请求先返回。可以根据业务需要订阅此消息
  console.log("upload request: " + HttpConstant.UPLOAD_URL);
  console.log("upload data: ", JSON.stringify(data))

  // ✅ 构造 headers（防止空 Authorization）
  const headers: Record<string, string> = {
    'Content-Type': HeaderContentType.MULTIPART_FORM_DATA
  };
  const requestOptions: http.HttpRequestOptions = {
      method: http.RequestMethod.POST,
      header: headers,
      multiFormDataList: data
    }
  /**
   * 发起请求
   */
  return new Promise((resolve: (value: Upload)=>void, reject: (value: string)=>void)=>{
    httpRequest.request(
      // 填写HTTP请求的URL地址，可以带参数也可以不带参数。URL地址需要开发者自定义。请求的参数可以在extraData中指定
      HttpConstant.UPLOAD_URL,
      requestOptions,
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          /**
           * data.result后端数据
           * @code @msg @data
           */
          console.log("data.result: "+ data.result)
          let res: Upload = JSON.parse(`${data.result}`)
          if(res.code == 200) {
            resolve(res)
          } else {
            reject("上传失败")
          }

          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        } else {
          console.error('error:' + JSON.stringify(err));
          // 当该请求使用完毕时，调用destroy方法主动销毁
          httpRequest.destroy();
        }
      }
    );
  })
}
