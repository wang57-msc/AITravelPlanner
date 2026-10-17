import { http } from '@kit.NetworkKit';
import { preferences } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';

// ====== 1. 类型声明（已完美适配 ArkTS 严格模式） ======
interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequestBody {
  model: string;
  messages: ChatMessage[];
  temperature: number;
}

// 必须拆开定义，不能用嵌套花括号
interface ApiResponseMessage {
  content: string;
}

interface ApiResponseChoice {
  message: ApiResponseMessage;
}

interface ApiResponse {
  choices: ApiResponseChoice[];
}
// ====================================================

@Entry
@Component
struct AiPlanPage {
  @State userInput: string = '';
  @State aiResponse: string = '你好！我是你的AI旅行规划师，你想去哪里玩？';
  @State isLoading: boolean = false;

  private dataPreferences: preferences.Preferences | null = null;
  private readonly PREF_NAME: string = 'ModelConfig';

  async aboutToAppear() {
    try {
      this.dataPreferences = await preferences.getPreferences(getContext(this), this.PREF_NAME);
    } catch (err) {
      console.error('读取配置失败', err);
    }
  }

  async sendMessage() {
    if (this.userInput.trim() === '') {
      promptAction.showToast({ message: '请输入你想去的地方' });
      return;
    }

    if (!this.dataPreferences) return;
    const apiKey = await this.dataPreferences.get('apiKey', '') as string;
    if (apiKey === '') {
      promptAction.showToast({ message: '请先去模型设置页填写 API Key' });
      return;
    }

    const userQuestion = this.userInput;
    this.userInput = '';
    this.aiResponse = 'AI 正在努力思考中...';
    this.isLoading = true;

    let httpRequest = http.createHttp();
    try {
      const messages: ChatMessage[] = [
        { role: "system", content: "你是一个专业的旅行规划师，请用简洁的中文为用户规划行程。" },
        { role: "user", content: userQuestion }
      ];

      const requestBody: ChatRequestBody = {
        model: "deepseek-chat",
        messages: messages,
        temperature: 0.7
      };

      let response = await httpRequest.request(
        "https://api.deepseek.com/chat/completions",
        {
          method: http.RequestMethod.POST,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
          },
          extraData: JSON.stringify(requestBody),
          connectTimeout: 60000,
          readTimeout: 60000
        }
      );

      if (response.responseCode === 200) {
        let result = JSON.parse(response.result as string) as ApiResponse;
        this.aiResponse = result.choices[0].message.content;
      } else {
        this.aiResponse = `请求失败，错误码：${response.responseCode}`;
      }
    } catch (err) {
      console.error('网络请求报错：', err);
      this.aiResponse = '网络请求失败，请检查网络或 API Key 是否正确。';
    } finally {
      this.isLoading = false;
      httpRequest.destroy();
    }
  }

  build() {
    Column() {
      Column() {
        Scroll() {
          Text(this.aiResponse)
            .fontSize(16)
            .backgroundColor('#E8F0FE')
            .padding(15)
            .borderRadius(10)
            .width('100%')
            .lineHeight(24)
        }
        .width('100%')
        .layoutWeight(1)
        .align(Alignment.TopStart)
      }
      .layoutWeight(1)
      .padding(15)

      Row({ space: 10 }) {
        TextInput({ placeholder: '说说你想去哪...', text: this.userInput })
          .onChange((val: string) => {
            this.userInput = val;
          })
          .layoutWeight(1)
          .height(45)
          .enabled(!this.isLoading)

        Button(this.isLoading ? '思考中' : '发送')
          .height(45)
          .backgroundColor(this.isLoading ? Color.Gray : $r('app.color.brand_primary'))
          .enabled(!this.isLoading)
          .onClick(() => {
            this.sendMessage();
          })
      }
      .padding(15)
      .width('100%')
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}