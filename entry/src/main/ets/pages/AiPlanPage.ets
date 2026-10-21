import { router } from '@kit.ArkUI';
import { http } from '@kit.NetworkKit';
import { preferences } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';

// ====== 1. 类型声明 ======
interface ChatMessage {
  role: string;
  content: string;
}

interface ChatRequestBody {
  model: string;
  messages: ChatMessage[];
  temperature: number;
}

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
  @State isLoading: boolean = false;

  // 这里是你的消息列表，初始有一句欢迎语
  @State messages: Array<ChatMessage> = [
    { role: "assistant", content: "你好！我是你的AI旅行规划师，你想去哪里玩？" }
  ];

  private dataPreferences: preferences.Preferences | null = null;
  private readonly PREF_NAME: string = 'ModelConfig';

  async aboutToAppear() {
    try {
      this.dataPreferences = await preferences.getPreferences(getContext(this), this.PREF_NAME);
    } catch (err) {
      console.error('读取配置失败', err);
    }
    const params = router.getParams() as Record<string, string>;
    if (params && params.autoPrompt) {
      this.userInput = params.autoPrompt; // 把条件填入输入框
      // 延迟一小会儿调用发送，确保页面加载完毕
      setTimeout(() => {
        this.sendMessage();
      }, 500);
    }
    // TODO: 明天在这里写读取本地聊天记录的逻辑
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
    this.isLoading = true;

    // 1. 用户的问题放进气泡列表
    this.messages.push({ role: "user", content: userQuestion });
    // TODO: 明天在这里写保存聊天记录到本地的方法
    // 2. AI 的“正在思考”占位符放进列表
    this.messages.push({ role: "assistant", content: "AI 正在努力思考中..." });
    // 3. 记住这个占位符的位置
    let loadingIndex = this.messages.length - 1;

    let httpRequest = http.createHttp();
    try {
      const messagesToApi: ChatMessage[] = [
        { role: "system", content: "你是一个专业的旅行规划师，请用简洁的中文为用户规划行程。" },
        { role: "user", content: userQuestion }
      ];

      const requestBody: ChatRequestBody = {
        model: "deepseek-chat",
        messages: messagesToApi,
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
        // 4. 拿到真实回复，替换掉“正在思考”的占位符
        this.messages[loadingIndex] = { role: "assistant", content: result.choices[0].message.content };
      } else {
        this.messages[loadingIndex] = { role: "assistant", content: `请求失败，错误码：${response.responseCode}` };
      }
    } catch (err) {
      console.error('网络请求报错：', err);
      this.messages[loadingIndex] = { role: "assistant", content: '网络请求失败，请检查网络或 API Key 是否正确。' };
    } finally {
      this.isLoading = false;
      httpRequest.destroy();
    }
  }

  build() {
    Column() {
      // 聊天记录展示区（循环渲染气泡列表）
      List({ space: 15 }) {
        ForEach(this.messages, (msg: ChatMessage, index: number) => {
          ListItem() {
            Row() {
              Text(msg.content)
                .fontSize(16)
                .padding(12)
                .borderRadius(12)
                // 用户是蓝色背景白字，AI是白色背景黑字
                .backgroundColor(msg.role === 'user' ? $r('app.color.brand_primary') : Color.White)
                .fontColor(msg.role === 'user' ? Color.White : Color.Black)
                .constraintSize({ maxWidth: '80%' })
            }
            .width('100%')
            // 用户靠右，AI靠左
            .justifyContent(msg.role === 'user' ? FlexAlign.End : FlexAlign.Start)
          }
        }, (msg: ChatMessage) => msg.content + Date.now().toString())
      }
      .width('100%')
      .layoutWeight(1)
      .padding(15)

      // 底部输入区
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