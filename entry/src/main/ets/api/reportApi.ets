import { Post } from "../utils/request";

const REPORT_BASE_URL = '/api/v1/appComplaints'
/**
 * 举报表单
 */
export class ReportForm{
  complaintTargetType: number;
  complaintTargetId: string;
  complaintDescription: string;

  constructor(complaintTargetType: number, complaintTargetId: string, content: string){
    this.complaintTargetType = complaintTargetType;
    this.complaintTargetId = complaintTargetId;
    this.complaintDescription = content;
  }
}

export function addReport(reportForm: ReportForm) {
  return Post<void, ReportForm>(
    `${REPORT_BASE_URL}`,
    reportForm
  )
}