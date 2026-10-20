import { router } from '@kit.ArkUI';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column({ space: 20 }) { // 用 Column 垂直排列，加 20 的间距，绝对不会重叠
      Button('去模型设置页')
        .width('80%') // 统一宽度更好看
        .height(50)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          router.pushUrl({ url: 'pages/ModelSettings' });
        })

      Button('开始 AI 旅行规划')
        .width('80%')
        .height(50)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          router.pushUrl({ url: 'pages/AiPlanPage' });
        })

      Button('定制旅行条件')
        .width('80%')
        .height(50)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          router.pushUrl({ url: 'pages/CustomPlanPage' });
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center) // 让三个按钮居中
    .backgroundColor($r('app.color.bg_color'))
  }
}