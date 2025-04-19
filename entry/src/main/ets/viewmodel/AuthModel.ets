export class LoginForm {
  studentId: string;
  password: string;

  constructor(studentId: string, password: string) {
    this.studentId = studentId;
    this.password = password;
  }
}

export class AuthModel{
  studentId: string;
  password: string;
  authStatus?: number;
  authInfo?: string;
  deleteUrl?: string;

  constructor(studentId: string, password: string, authInfo?: string, authStatus?: number,  deleteUrl?: string) {
    this.studentId = studentId;
    this.password = password;
    this.authStatus = authStatus;
    this.authInfo = authInfo;
    this.deleteUrl = deleteUrl;
  }
}

export class AuthenticationToken{
  studentId: string;
  tokenType: string;
  accessToken: string;
  refreshToken: string;
  expiresIn: number;

  constructor(studentId: string, tokenType: string, accessToken: string, refreshToken: string, expiresIn: number) {
    this.studentId = studentId;
    this.tokenType = tokenType;
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
    this.expiresIn = expiresIn;
  }
}