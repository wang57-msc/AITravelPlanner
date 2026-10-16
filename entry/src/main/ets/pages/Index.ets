import { router } from '@kit.ArkUI';
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() { // 如果看 RelativeContainer 不顺眼，可以改成 Column()，但留着也没事
      Button('去模型设置页')
        .onClick(() => {
          // 注意：这里路径必须和你新建的文件名一致
          router.pushUrl({ url: 'pages/ModelSettings' });
        })
        .width(200)
        .height(50)
    }
    .height('100%')
    .width('100%')
  }
}