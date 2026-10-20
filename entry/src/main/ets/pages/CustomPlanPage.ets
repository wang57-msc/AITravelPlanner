import { router } from '@kit.ArkUI';

@Entry
@Component
struct CustomPlanPage {
  @State destination: string = '';
  @State days: number = 3;
  @State budget: string = '2000';
  @State style: string = '舒适游';

  build() {
    Column({ space: 20 }) {
      Text('定制你的专属旅行')
        .fontSize(24).fontWeight(FontWeight.Bold)
        .width('100%').textAlign(TextAlign.Start)

      // 1. 目的地输入
      TextInput({ placeholder: '想去哪里？（如：成都）', text: this.destination })
        .onChange((val) => this.destination = val)
        .width('100%').height(45)

      // 2. 天数选择 (Slider)
      Column() {
        Text(`游玩天数：${this.days} 天`).fontSize(16).width('100%')
        Slider({ value: this.days, min: 1, max: 10, step: 1 })
          .onChange((val) => this.days = val)
          .width('100%')
      }

      // 3. 预算输入 (数字类型)
      TextInput({ placeholder: '总预算（元）', text: this.budget })
        .type(InputType.Number)
        .onChange((val) => this.budget = val)
        .width('100%').height(45)

      // 4. 旅行风格 (Select)
      Row() {
        Text('旅行风格：').fontSize(16)
        Select([{ value: '穷游' }, { value: '舒适游' }, { value: '奢华游' }])
          .selected(1)
          .value(this.style)
          .onSelect((index, val) => this.style = val)
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)

      Blank() // 把按钮推到底部

      Button('生成专属规划')
        .width('100%').height(50)
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          if (this.destination === '') {
            return;
          }
          // 核心：把表单数据拼成一段 Prompt，通过路由传给聊天页
          const prompt = `我想去${this.destination}玩${this.days}天，总预算大概${this.budget}元，偏好${this.style}。请帮我做一个详细的行程规划。`;

          router.pushUrl({
            url: 'pages/AiPlanPage',
            params: { autoPrompt: prompt } // 传参
          });
        })
    }
    .width('100%').height('100%')
    .padding(20)
    .backgroundColor('#F5F5F5')
  }
}