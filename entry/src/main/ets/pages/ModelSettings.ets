@Entry
@Component
struct ModelSettings {
  @State apiKey: string = '';
  @State selectedModel: string = 'DeepSeek';
  @State temperature: number = 0.7;

  build() {
    Column({ space: 20 }) {
      // 1. 标题
      Text('模型设置')
        .fontSize($r('app.float.font_size_title'))
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)

      // 2. API Key 输入框
      TextInput({ placeholder: '请输入 API Key', text: this.apiKey })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.apiKey = value;
        })
        .width('100%')

      // 3. 模型选择 (Select组件)
      Select([
        { value: 'DeepSeek' },
        { value: '智谱GLM' },
        { value: '通义千问' }
      ])
        .selected(0)
        .value(this.selectedModel)
        .onSelect((index: number, value: string) => {
          this.selectedModel = value;
        })
        .width('100%')

      // 4. 参数调整 (Slider组件)
      Column() {
        Text(`模型温度: ${this.temperature.toFixed(1)}`)
          .width('100%')
          .fontSize(16)
        Slider({
          value: this.temperature,
          min: 0,
          max: 1,
          step: 0.1
        })
          .onChange((value: number) => {
            this.temperature = value;
          })
          .width('100%')
      }

      // 5. 保存按钮
      Button('保存配置')
        .width('100%')
        .backgroundColor($r('app.color.brand_primary'))  // <--- 就在这里！
        .onClick(() => {
          console.log('点击了保存');
        })

    }
    .width('100%')
    .height('100%')
    .padding($r('app.float.padding_m'))
    .backgroundColor($r('app.color.bg_color')) // <--- 还有这里
  }
}