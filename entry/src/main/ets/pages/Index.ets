import { router } from '@kit.ArkUI';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column({ space: 20 }) {
      Text('🌍 AI 旅行规划师')
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 20 })

      // 按钮1
      Button('去模型设置页')
        .onClick(() => {
          router.pushUrl({ url: 'pages/ModelSettings' });
        })
        .width('85%')            // <--- 变宽，占屏幕85%
        .height(50)
        .borderRadius(25)        // <--- 变圆润

      // 按钮2
      Button('定制专属旅行条件')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CustomPlanPage' });
        })
        .width('85%')
        .height(50)
        .borderRadius(25)

      // 按钮3
      Button('开始 AI 旅行规划')
        .onClick(() => {
          router.pushUrl({ url: 'pages/AiPlanPage' });
        })
        .width('85%')
        .height(50)
        .borderRadius(25)

      Button('退出登录')
        .width('85%')
        .height(50)
        .borderRadius(25)
        .backgroundColor(Color.Transparent) // 透明背景
        .fontColor(Color.Gray)             // 灰色字体
        .margin({ top: 20 })
        .onClick(() => {
          router.replaceUrl({ url: 'pages/LoginPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center) // 让按钮在屏幕中间
    .backgroundColor('#F5F7FA')       // <--- 浅灰蓝高级背景色
  }
}