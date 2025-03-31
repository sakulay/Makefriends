export interface BotItem {
  text: string;
  icon_normal: Resource;
  icon_selected: Resource;
}

export interface TopItem {
  title: string;
  content?: string;
}

export class Review {
  img: Resource;
  name: string;
  content: string;
  ago: string;
  where: string;
  love: number;

  constructor(img: Resource, name: string, content: string, ago: string, where: string, love: number) {
    this.img = img;
    this.name = name;
    this.content = content;
    this.ago = ago;
    this.where = where;
    this.love = love;
  }
}

export const where: string[] = ['北京', '上海', '苏州', '杭州', '南京', '长沙', '武汉', '西藏', '海南', '沈阳', '哈尔滨', '郑州', '洛阳', '焦作', '合肥', '福州', '厦门', '兰州', '贵阳', '石家庄', '长春', '吉林'];

// export const reviewImg: Resource[] = [$r('app.media.user1'), $r('app.media.user2'), $r('app.media.user3'), $r('app.media.user4'), $r('app.media.user55'), $r('app.media.user6'), $r('app.media.user7')];

export const reviewName: string[] = ['山河无恙1472', '直爽的孤勇者', '成熟百灵鸟RNX', '果壳里的宇宙0sS6', '颂岩1', '二哥19525', '姹紫亦千红', '雨中的凤米花'];

export const reviewContent: string[] = ['妥妥的干货,赞赞', '已经收藏起来加关注，写的不错，很中肯', '中国好声音！', '大力推进成熟先进技术的工程化实践，从而推动行业技术进步和能力水平提升', '推动钢铁业高质量发展 ，加强科技创新和成果转化', '相约浙江乌镇，共绘数字合作美好愿景。', '十年沉淀，十年辉煌，祝伟大的祖国繁荣昌盛国泰民安！', '以创新保安全，集中力量攻克卡脖子钢材和核心技术！'];

export const reviewAgo: string[] = ['5分钟前', '20分钟前', '30分钟前', '1小时前', '2小时前', '5小时前', '8小时前', '12小时前'];

export const reviewLove: number[] = [0, 5, 22, 115, 223, 326, 562, 663];

export const WhereRandom: string = where[Math.floor(Math.random() * 22)];

// export const NavBottom: BotItem[] = [
//   {
//     icon_normal: $r('app.media.ic_public_view_list'),
//     icon_selected: $r('app.media.ic_public_view_list_click'),
//     text: '首页',
//   },
//   {
//     icon_normal: $r('app.media.ic_public_play'),
//     icon_selected: $r('app.media.ic_public_play_click'),
//     text: '视频',
//   },
//   {
//     icon_normal: $r('app.media.ic_public_appstore'),
//     icon_selected: $r('app.media.ic_public_appstore_click'),
//     text: '商城',
//   },
//   {
//     icon_normal: $r('app.media.ic_public_contacts'),
//     icon_selected: $r('app.media.ic_public_contacts_click'),
//     text: '未登录',
//   },
// ]

export const NavTop: TopItem[] = [
  {
    title: '推荐',
    content: '推荐内容'
  },
  {
    title: '杭州',
    content: '杭州内容'
  },
  {
    title: '直播',
    content: '直播内容'
  },
  {
    title: '科技',
    content: '科技内容'
  },
  {
    title: '军事',
    content: '军事内容'
  },
  {
    title: '国际',
    content: '国际内容'
  },
  {
    title: '财经',
    content: '财经内容'
  },
  {
    title: '法律',
    content: '法律内容'
  },
  {
    title: '政法',
    content: '政法内容'
  },
  {
    title: '视界',
    content: '视界内容'
  },
]

export const videos: string[] = ['https://prod-streaming-video-msn-com.akamaized.net/a8c412fa-f696-4ff2-9c76-e8ed9cdffe0f/604a87fc-e7bc-463e-8d56-cde7e661d690.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/fb194c01-2ff6-4b4e-afbd-a00289124c4c/af7a74f5-5cb6-423e-b428-d05c0d36478d.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/178161a4-26a5-4f84-96d3-6acea1909a06/2213bcd0-7d15-4da0-a619-e32d522572c0.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/e908e91f-370f-49ad-b4ce-775b7e7a05b4/a6287f74-46f0-42f9-b5d9-997f00585696.mp4', 'https://prod-streaming-video-msn-com.akamaized.net/fe13f13c-c2cc-4998-b525-038b23bfa9b5/1a9d30ca-54be-411e-8b09-d72ef4488e05.mp4'];

// export const images: Resource[] = [$r('app.media.uri1'), $r('app.media.uri2'), $r('app.media.uri3'), $r('app.media.uri4'), $r('app.media.uri5')];

// export const imgs: Resource[] = [$r('app.media.image1'), $r('app.media.img'), $r('app.media.img_1'), $r('app.media.img_2'), $r('app.media.img_3'), $r('app.media.img_4'), $r('app.media.img_5'), $r('app.media.img_6'), $r('app.media.img_7')];

export class friends{
  img: string;
  nickname: string;
  bio: string;

  constructor(img: string, nickname: string, bio: string) {
    this.img = img;
    this.nickname = nickname;
    this.bio = bio;
  }
}

export const friendsList: friends[] = [
  new friends('http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', 'Sugar', '一个爱生活，爱分享的人'),
  new friends('http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', 'anson', '直爽的孤勇者'),
  new friends('http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', 'Mike', '大力推进成熟先进技术的工程化实践'),
  new friends('http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', 'Sugar', '一个爱生活，爱分享的人'),
  new friends('http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', 'anson', '直爽的孤勇者'),
  new friends('http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', 'Mike', '大力推进成熟先进技术的工程化实践'),
  new friends('http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', 'Sugar', '一个爱生活，爱分享的人'),
  new friends('http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', 'anson', '直爽的孤勇者'),
  new friends('http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', 'Mike', '大力推进成熟先进技术的工程化实践'),
  new friends('http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', 'Sugar', '一个爱生活，爱分享的人'),
  new friends('http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', 'anson', '直爽的孤勇者'),
  new friends('http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', 'Mike', '大力推进成熟先进技术的工程化实践'),
  new friends('http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', 'Sugar', '一个爱生活，爱分享的人'),
  new friends('http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', 'anson', '直爽的孤勇者'),
  new friends('http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', 'Mike', '大力推进成熟先进技术的工程化实践')
]

export class PersonalInfo {
  id: number
  img: string;
  nickname: string;
  bio: string;
  status: number;

  constructor(id: number, img: string, nickname: string, bio: string, status: number) {
    this.id = id;
    this.img = img;
    this.nickname = nickname;
    this.bio = bio;
    this.status = status;
  }

}

export class Post{
  id: number
  userId: number
  nickname: string
  avatar: string
  title: string
  content: string
  imgList: string[]
  likeCount: number
  commentCount: number
  createTime: string

  constructor(id: number, userId: number, nickname: string, avatar: string, title: string, content: string, imgList: string[], likeCount: number, commentCount: number, createTime: string) {
    this.id = id;
    this.userId = userId;
    this.nickname = nickname;
    this.avatar = avatar;
    this.title = title;
    this.content = content;
    this.imgList = imgList;
    this.likeCount = likeCount;
    this.commentCount = commentCount;
    this.createTime = createTime;
  }
}
export function mockInfo() {
  return new PersonalInfo(2101510218, 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg', '林键超', '我自横刀向天笑，去留肝胆两昆仑', 1)
}
export const PostList: Post[] = [
  new Post(1, 14, 'sugar', 'http://111.230.102.82:40061/i/0/2025/02/25/sdw5hd-0.jpg', '价格近 DeepSeek 的三百倍价格近 DeepSeek 的三百倍', '北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5，北京时间2月28日凌晨4点，OpenAI正式发布传闻中的“最后一款非推理模型”GPT-4.5', ['http://111.230.102.82:40061/i/2025/03/03/plr7t4-0.png', 'http://111.230.102.82:40061/i/2025/03/03/plrmwr-0.png', 'http://111.230.102.82:40061/i/2025/03/24/yspn1w.jpeg'], 10, 20, '2025-02-25 12:00:00'),
  new Post(2, 14, 'anson', 'http://111.230.102.82:40061/i/2025/02/26/su2jeq-0.jpeg','DeepSeek开源周第四弹！一次性发布3个开源项目，梁文锋亲自参与开发', '1）DualPipe：这是一种创新的双向流水线并行（Pipeline Parallelism）算法，首次在 DeepSeek-V3 技术报告中提出。该算法能够实现前向/后向计算与通信阶段的完全重叠，可显著减少流水线空泡（Pipeline Bubbles）。\n' +
    '\n' +
    '（项目地址：https://github.com/deepseek-ai/DualPipe）\n' +
    '\n' +
    '（2）EPLB：这是 DeepSeek-V3 训练框架中实际使用的专家并行负载均衡算法（EPLB）。该算法基于对专家负载的估算，计算出一个平衡的专家复制和分配方案。同时 DeepSeek 提醒道，该开源代码库不包含专家负载预测的确切方法，常规方法是使用历史统计数据的移动平均值来预测。\n' +
    '\n' +
    '（项目地址：https://github.com/deepseek-ai/EPLB）\n' +
    '\n' +
    '（3）DeepSeek Infra 中的性能分析数据：为了帮助开发者更深入地了解通信-计算重叠策略以及底层技术细节，DeepSeek 选择开源其训练和推理框架中收集的性能分析数据。据官方介绍，这些数据是通过 PyTorch Profiler 采集的，开发者下载后可直接在 Chrome 浏览器（chrome://tracing） 或 Edge 浏览器（edge://tracing） 中进行可视化分析。\n' +
    '\n' +
    '（项目地址：https://github.com/deepseek-ai/profile-data）\n' +
    '\n' +
    '尤其值得一提的是，在 DualPipe 的 README 文件中，特别提到梁文峰本人也参与了该项目的创建与开发。\n', ['http://111.230.102.82:40061/i/2025/03/03/plr7t4-0.png', 'http://111.230.102.82:40061/i/2025/03/03/plrmwr-0.png'], 30, 40, '2025-02-25 12:00:00'),
  new Post(3, 14, 'mike', 'http://111.230.102.82:40061/i/2025/02/25/10h2q0v-0.jpeg', '标题3', '内容3', ['http://111.230.102.82:40061/i/2025/03/03/plr7t4-0.png'], 50, 60, '2025-02-25 12:00:00'),
]

export class comments {
  id: number;
  userId: number;
  postId: number;
  content: string;
  parentId: number;
  createTime: string;
  isReply: number;
  children: comments[]; // 添加 children 属性

  constructor(id: number, userId: number, postId: number, content: string, parentId: number, createTime: string, isReply: number) {
    this.id = id;
    this.userId = userId;
    this.postId = postId;
    this.content = content;
    this.parentId = parentId;
    this.createTime = createTime;
    this.isReply = isReply;
    this.children = []; // 初始化为空数组
  }
}

export const commentList: comments[] = [
  new comments(1, 14, 1, '一级评论1', 0, '2025-02-25 12:00:00', 0),
  new comments(2, 14, 1, '一级评论2', 0, '2025-02-25 12:00:00', 0),
  new comments(3, 14, 1, '二级评论3', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '二级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '三级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(1, 14, 1, '一级评论1', 0, '2025-02-25 12:00:00', 0),
  new comments(2, 14, 1, '一级评论2', 0, '2025-02-25 12:00:00', 0),
  new comments(3, 14, 1, '二级评论3', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '二级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '三级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(1, 14, 1, '一级评论1', 0, '2025-02-25 12:00:00', 0),
  new comments(2, 14, 1, '一级评论2', 0, '2025-02-25 12:00:00', 0),
  new comments(3, 14, 1, '二级评论3', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '二级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '三级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(1, 14, 1, '一级评论1', 0, '2025-02-25 12:00:00', 0),
  new comments(2, 14, 1, '一级评论2', 0, '2025-02-25 12:00:00', 0),
  new comments(3, 14, 1, '二级评论3', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '二级评论4', 1, '2025-02-25 12:00:00', 1),
  new comments(3, 14, 1, '三级评论4', 1, '2025-02-25 12:00:00', 1),
]