import { router } from '@kit.ArkUI';

@Entry
@Component
struct LoginPage {
  @State username: string = '';
  @State password: string = '';

  build() {
    Column({ space: 20 }) {
      Blank().layoutWeight(1) // 把内容往下挤一点

      // ====== 全新的 Logo 区域 ======
      Stack() {
        // 外面一个品牌色的圆圈
        Circle({ width: 100, height: 100 })
          .fill($r('app.color.brand_primary'))

        // 里面放个地球Emoji
        Text('🌍')
          .fontSize(50)
      }
      .margin({ bottom: 15 })

      Text('AI 旅行规划师')
        .fontSize(28)
        .fontWeight(FontWeight.Bold)

      Text('你的专属智能旅行向导')
        .fontSize(14)
        .fontColor(Color.Gray)
        .margin({ bottom: 30 })
      // ==============================

      // 账号输入
      TextInput({ placeholder: '请输入账号', text: this.username })
        .onChange((val) => this.username = val)
        .width('85%').height(50)
        .backgroundColor('#F0F2F5')
        .borderRadius(25)
        .padding({ left: 20 })

      // 密码输入
      TextInput({ placeholder: '请输入密码', text: this.password })
        .type(InputType.Password)
        .onChange((val) => this.password = val)
        .width('85%').height(50)
        .backgroundColor('#F0F2F5')
        .borderRadius(25)
        .padding({ left: 20 })

      // 登录按钮
      Button('登 录')
        .width('85%').height(50)
        .backgroundColor($r('app.color.brand_primary'))
        .borderRadius(25)
        .margin({ top: 30 })
        .onClick(() => {
          // 假登录：直接跳转到首页，把登录页销毁
          router.replaceUrl({ url: 'pages/Index' });
        })

      Blank().layoutWeight(1)
    }
    .width('100%').height('100%')
    .backgroundColor(Color.White)
  }
}