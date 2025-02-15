import { dataPreferences } from '../entryability/EntryAbility';

const lightColor: string = '#f5f5fa'
const darkColor: string = '#303030'

@Component
struct TextEditDemo {
  @State content: string = '长按编辑文本'
  @State isEdit: boolean = false
  @State showPopup: boolean = false;

  aboutToAppear() {
    if (dataPreferences && dataPreferences.hasSync('myContent')) {
      this.content = dataPreferences.getSync('myContent', '长按编辑文本').toString();
    } else {
      dataPreferences?.putSync('myContent', this.content)
    }

    setTimeout(() => {
      if (!this.isEdit) {
        this.showPopup = true;
      }
    }, 2000)
    setTimeout(() => {
      this.showPopup = false;
    }, 7000)
  }

  build() {
    Column() {
      if (this.isEdit) {
        TextArea({
          placeholder: '请输入文本',
          text: this.content
        })
          .key('mainInput')
          .inputFilter('\\D')
          .width(300)
          .height(300)
          .padding(20)
          .onChange((txt: string) => {
            this.content = txt
            dataPreferences?.putSync('myContent', txt);
            dataPreferences?.flushSync()
          })
          .onEditChange((isEdit: boolean) => {
            if (!isEdit) {
              this.isEdit = false
            }
          })
      } else {
        Row() {
          Text(this.content)
            .maxLines(14)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        .width(300)
        .height(300)
        .padding(20)
        .alignItems(VerticalAlign.Top)
        .backgroundColor(Color.White)
        .borderRadius(10)
        .bindPopup(this.showPopup, {
          message: '长按可编辑',
          placement: Placement.TopLeft,
          maskColor: darkColor,
          popupColor: lightColor,
          autoCancel: true,
        })
        .gesture(
          LongPressGesture({
            duration: 500,
            repeat: true,
            fingers: 1
          })
            .onAction(() => {
              this.isEdit = true
              setTimeout(() => {

                focusControl.requestFocus('mainInput');
              }, 0)
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
  @State fs: number = 30;
  @State value: number = 0;
  @State total: number = 100;
  randomDelay = () => {
    let rn = Math.floor(Math.random() * 10 / 5) + 1;
    this.total = rn * 100;
  }
  dispatchProgress = (action: string) => {
    let intervalID = setInterval(() => {
      this.value += 1
      if (this.value > this.total) {
        switch (action) {
          case 'up':
            ++this.currNumber;
            break;
          case 'down':
            --this.currNumber;
            break;
        }
        this.value = 0;
        clearInterval(intervalID);
      }
    }, 10);
  }

  build() {
    Column({ space: 50 }) {
      Row() {
        Button('增加')
          .backgroundColor('#006400')
          .onClick(() => {
            this.randomDelay()
            this.dispatchProgress('up')
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
            .fontColor(Color.Yellow)
        }
      }

      Row() {
        if (this.currNumber > 1) {
          Button('减少')
            .backgroundColor('#006400')
            .onClick(() => {
              if (this.currNumber <= 1) {
                return;
              }
              this.randomDelay()
              this.dispatchProgress('down')
            })
        } else {
          Button('减少', { stateEffect: false })
            .backgroundColor(Color.Grey)
        }
      }

      Row({ space: 10 }) {
        Progress({
          value: this.value,
          total: this.total,
          type: ProgressType.Capsule
        })
          .size({ width: 120, height: 30 })
          .color('#006400')

        Text() {
          Span((this.value / 100).toFixed(2).toString() + 's')
        }
        .fontColor(Color.White)
      }
    }
    .width(300)
    .height(500)
    .padding(20)
    .justifyContent(FlexAlign.Center)
    .backgroundColor('#424242')
    .borderRadius(10)
    .justifyContent(FlexAlign.Center)
  }
}

@Entry
@Component
struct Index {
  @State bgc: string = lightColor
  @State index: number = 0;
  @State rgColors: [ResourceColor, number][] = [[0xf6f6f6, 0], [0x303030, 1]]
  private controller: TabsController = new TabsController();

  @Builder
  Tab1() {
    Column() {
      Text('Tab1')
        .fontColor(this.index == 0 ? '#006400' : '#fff')
    }
    .onClick(() => {
      this.index = 0;
      this.controller.changeIndex(this.index);
    })
  }

  @Builder
  Tab2() {
    Column() {
      Text('Tab2')
        .fontColor(this.index == 1 ? '#006400' : '#000')
    }
    .onClick(() => {
      this.index = 1;
      this.controller.changeIndex(this.index);
    })
  }

  build() {
    Tabs({
      barPosition: BarPosition.End,
      controller: this.controller
    }) {
      TabContent() {
        TextEditDemo();
      }.tabBar(this.Tab1())

      TabContent() {
        CounterDemo()
      }.tabBar(this.Tab2())
    }
    .onChange((index: number) => {
      this.index = index;
      this.bgc = index ? darkColor : lightColor
      this.rgColors = index ? [[0x303030, 0], [0xf6f6f6, 1]] : [[0xf6f6f6, 0], [0x303030, 1]]
    })
    .radialGradient({
      center: [0, 0],
      radius: 10000,
      colors: this.rgColors
    })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .animation({
      duration: 300,
      curve: Curve.Linear,
      playMode: PlayMode.Normal
    })
  }
}