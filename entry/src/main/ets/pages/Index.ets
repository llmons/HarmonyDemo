import { display, promptAction } from '@kit.ArkUI';

@Component
struct TextEditDemo {
  @State content: string = '长按编辑文本'
  @State isEdit: boolean = false

  build() {
    Column() {
      if (this.isEdit) {
        TextArea({
          placeholder: '请输入文本',
          text: this.content
        })
          .inputFilter('\\D')
          .onChange((txt: string) => this.content = txt)
          .onEditChange((isEdit: boolean) => {
            if (!isEdit) {
              if (this.content == '') {
                promptAction.showToast({
                  message: "文本不可为空",
                  duration: 2000,
                  bottom: 300
                })
                return
              }
              this.isEdit = false
            }

          })
      } else {
        Text(this.content)
          .fontColor('#555')
          .gesture(
            LongPressGesture({
              duration: 800,
              repeat: true,
              fingers: 1
            })
              .onAction(() => {
                this.isEdit = true
              })
          )
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
    .padding(10)
  }
}

@Component
struct CounterDemo {
  @State currNumber: number = 1;
  @State fs: number = 20;

  build() {
    Column({ space: 50 }) {
      Row() {
        Button('增加')
          .onClick(() => {
            ++this.currNumber;
          });
      }

      Row() {
        if (this.currNumber % 2) {

          Text(this.currNumber.toString())
            .fontSize(this.fs)
            .fontColor(Color.Red)
        } else {
          Text(this.currNumber.toString())
            .fontSize(this.fs)
            .fontColor(Color.Green)
        }
      }

      Row() {
        if (this.currNumber > 1) {
          Button('减少').onClick(() => {
            if (this.currNumber <= 1) {
              return;
            }
            --this.currNumber
          })
        } else {
          Button('减少')
            .backgroundColor(Color.Grey)
            .onClick(() => {
              if (this.currNumber <= 1) {
                return;
              }
              --this.currNumber
            })
        }
      }
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}

@Entry
@Component
struct Index {
  @State bgc: string = '#f6f6f6'
  @State rgColors: [ResourceColor, number][] = [[0xf6f6f6, 0], [0x303030, 1]]
  private screenWidth: number = 0;
  private screenHeight: number = 0;

  aboutToAppear() {
    try {
      this.screenWidth = display.getDefaultDisplaySync().width;
      this.screenHeight = display.getDefaultDisplaySync().height;
    } catch (e) {
      console.error('Fail with code: ' + JSON.stringify(e));
    }
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        TextEditDemo();
      }.tabBar('Tab1')

      TabContent() {
        CounterDemo()
      }.tabBar('Tab2')
    }
    .onChange((index: number) => {
      this.bgc = index ? '#303030' : '#f6f6f6'
      this.rgColors = index ? [[0x303030, 0], [0xf6f6f6, 1]] : [[0xf6f6f6, 0], [0x303030, 1]]
    })
    .radialGradient({
      center: [this.screenWidth / 2, this.screenHeight / 2],
      radius: 10000,
      colors: this.rgColors
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .animation({
      duration: 300,
      curve: Curve.EaseInOut,
      playMode: PlayMode.Normal
    })
  }
}