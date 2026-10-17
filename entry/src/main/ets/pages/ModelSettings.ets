import { preferences } from '@kit.ArkData'; // 1. 引入数据持久化模块
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct ModelSettings {
  @State apiKey: string = '';
  @State selectedModel: string = 'DeepSeek';
  @State temperature: number = 0.7;

  // 定义本地存储的实例和文件名
  private dataPreferences: preferences.Preferences | null = null;
  private readonly PREF_NAME: string = 'ModelConfig';

  // 2. 页面加载时（生命周期），自动读取本地存储的数据
  aboutToAppear() {
    this.initPreferences();
  }

  async initPreferences() {
    try {
      // 获取实例
      this.dataPreferences = await preferences.getPreferences(getContext(this), this.PREF_NAME);
      // 读取数据并回显到界面上
      this.apiKey = await this.dataPreferences.get('apiKey', '') as string;
      this.selectedModel = await this.dataPreferences.get('model', 'DeepSeek') as string;
      this.temperature = await this.dataPreferences.get('temp', 0.7) as number;
    } catch (err) {
      console.error('读取配置失败', err);
    }
  }

  // 3. 点击保存按钮的逻辑
  async saveConfig() {
    if (!this.dataPreferences) return;
    try {
      // 将数据写入内存
      await this.dataPreferences.put('apiKey', this.apiKey);
      await this.dataPreferences.put('model', this.selectedModel);
      await this.dataPreferences.put('temp', this.temperature);
      // 强制刷新落盘
      await this.dataPreferences.flush();

      // 提示保存成功
      promptAction.showToast({ message: '配置保存成功！' });
      console.log('配置保存成功');
    } catch (err) {
      console.error('保存失败', err);
      promptAction.showToast({ message: '保存失败' });
    }
  }

  build() {
    Column({ space: 20 }) {
      Text('模型设置')
        .fontSize($r('app.float.font_size_title'))
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .textAlign(TextAlign.Start)

      TextInput({ placeholder: '请输入 API Key', text: this.apiKey })
        .type(InputType.Password)
        .onChange((value: string) => {
          this.apiKey = value;
        })
        .width('100%')

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

      Button('保存配置')
        .width('100%')
        .backgroundColor($r('app.color.brand_primary'))
        .onClick(() => {
          // 4. 点击按钮调用保存方法
          this.saveConfig();
        })

    }
    .width('100%')
    .height('100%')
    .padding($r('app.float.padding_m'))
    .backgroundColor($r('app.color.bg_color'))
  }
}