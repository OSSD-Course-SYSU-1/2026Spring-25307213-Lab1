/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ArcSwiper, ArcSwiperAttribute, ArcSwiperController } from '@kit.ArkUI';
import { StyleConstants } from '../constants/StyleConstants';
import { PlayListSheet } from '../viewmodel/ViewModel'

@Builder
export function PlayListBuilder() {
  PlayList();
}

@Preview
@Component
export struct PlayList {
  @Consume pageStack: NavPathStack
  @State itemSimpleColor: Color | number | string = '';
  @State selectedItemSimpleColor: Color | number | string = '';
  innerSelectedIndex: number = 0;
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController();
  private playList: PlayListSheet[] = [
    {
      name: $r('app.string.playlist_name_one'),
      background: $r('app.media.playlist_bg1'),
      title: $r('app.string.playlist_title_one'),
    },
    {
      name: $r('app.string.playlist_name_two'),
      background: $r('app.media.playlist_bg2'),
      title: $r('app.string.playlist_title_two'),
    }
  ]

  build() {
    NavDestination() {
      Column() {
        ArcSwiper(this.wearableSwiperController) {
          ForEach(this.playList, (item: PlayListSheet) => {
            Column({ space: 10 }) {
              Row() {
                Text(item.name)
                  .fontWeight(FontWeight.Bold)
                  .fontColor($r('app.color.font_color'))
                  .fontSize($r('app.float.home_font_size'))
                Image($r('app.media.chevron_right'))
                  .width($r('app.float.home_icon_jump_width'))
                  .margin({ left: $r('app.float.playlist_padding') })
              }

              Image($r('app.media.play_btn_fill'))
                .width($r('app.float.playlist_icon'))
                .height($r('app.float.playlist_icon'))
                .position({ x: '25%', y: '65%' })
              Text(item.title)
            }
            .width(StyleConstants.FULL_WIDTH)
            .height(StyleConstants.FULL_HEIGHT)
            .backgroundImage(item.background, ImageRepeat.NoRepeat)
            .backgroundImageSize({ width: StyleConstants.FULL_WIDTH, height: StyleConstants.FULL_HEIGHT })
            .justifyContent(FlexAlign.SpaceBetween)
            .padding({ top: $r('app.float.playlist_row_padding'), bottom: $r('app.float.playlist_row_padding') })
            .onClick(() => {
              this.pageStack.replacePathByName('songList', null)
            })
          })
        }
        .index(0)
        .duration(400)
        .vertical(true)
        .indicator(false)
        .disableSwipe(false)
        .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
        .disableTransitionAnimation(false)
        .onAnimationStart((index: number, targetIndex: number) => {
          this.innerSelectedIndex = targetIndex;
        })
        .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
        ): GestureJudgeResult => { // 在识别器即将要成功时，根据当前组件状态，设置识别器使能状态
          if (current) {
            let target = current.getEventTargetInfo();
            if (target && current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
              // 此处判断swiperTarget.isBegin()或innerSelectedIndex === 0，表明ArcSwiper滑动到开头
              let swiperTarget = target as ScrollableTargetInfo
              if (swiperTarget instanceof ScrollableTargetInfo &&
                (swiperTarget.isBegin() || this.innerSelectedIndex === 0)) {
                let panEvent = event as PanGestureEvent;
                if (panEvent && panEvent.offsetX > 0 && (swiperTarget.isBegin() || this.innerSelectedIndex === 0)) {
                  return GestureJudgeResult.REJECT;
                }
              }
            }
          }
          return GestureJudgeResult.CONTINUE;
        })
      }
      .width(StyleConstants.FULL_WIDTH)
      .height(StyleConstants.FULL_HEIGHT)
    }
    .hideTitleBar(true)
  }
}