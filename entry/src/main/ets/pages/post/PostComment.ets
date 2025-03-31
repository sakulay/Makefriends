import { comments, commentList } from "../utils/Mock";

@Entry
@Component
struct PostComment {
  private commentTree: comments[] = [];

  aboutToAppear() {
    this.commentTree = this.buildCommentTree(commentList);
  }

  buildCommentTree(comments: comments[]): comments[] {
    let commentMap = new Map<number, comments[]>();
    comments.forEach(comment => {
      if (!commentMap.has(comment.parentId)) {
        commentMap.set(comment.parentId, []);
      }
      commentMap.get(comment.parentId)!.push(comment);
    });

    const buildTree = (parentId: number): comments[] => {
      return (commentMap.get(parentId) || []).map(comment => {
        (comment as comments).children = buildTree(comment.id);
        return comment;
      });
    };

    return buildTree(0);
  }

  @Builder
  renderCommentItem(comment: comments, level: number) {
    Column({ space: 8 }) {  // 增加整体间距
      Row() { // 增加左缩进
        Text(comment.content)
          .fontSize(level === 0 ? 18 : 16) // 一级评论大一点
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start);
      }
      .padding(10)
      .backgroundColor(level === 0 ? Color.White : Color.Gray) // 一级评论白色，子级评论加深灰色
      .borderRadius(10)  // 添加圆角
      .shadow({ radius: 5, color: Color.Black, offsetX: 2, offsetY: 2 }) // 添加阴影
      .margin({ left: level * 25, right: 10 })
      ForEach(comment.children,  (child: comments) => this.renderCommentItem(child, level + 1));
    }
  }

  build() {
    Column() {
      Text('评论列表')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .padding(10);

      List() {
        ForEach(this.commentTree, (comment: comments) => this.renderCommentItem(comment, 0));
      }
    }
    .padding(15);
  }
}

export { PostComment };
