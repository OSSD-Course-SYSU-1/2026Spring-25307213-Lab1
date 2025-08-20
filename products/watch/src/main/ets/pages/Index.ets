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

import {
  CircleShape,
  ArcSwiper,
  ArcSwiperAttribute,
  ArcDotIndicator,
  ArcDirection,
  ArcSwiperController
} from '@kit.ArkUI';
import { Home } from './Home';
import { PlayList } from './PlayList';
import { MediaService } from '@ohos/mediaCommon';
import { songList } from 'musicList';
import { StyleConstants } from '../constants/StyleConstants';

@Preview
@Entry
@Component
struct Index {
  @Provide pageStack: NavPathStack = new NavPathStack();
  private wearableSwiperController: ArcSwiperController = new ArcSwiperController();
  private arcDotIndicator: ArcDotIndicator = new ArcDotIndicator();
  innerSelectedIndex: number = 0;

  aboutToAppear(): void {
    AppStorage.setOrCreate('songList', songList);
    MediaService.getInstance();
  }

  build() {
    Navigation(this.pageStack) {
      Column() {
        Row() {
          ArcSwiper(this.wearableSwiperController) {
            Home()
            PlayList()
          }
          .clipShape(new CircleShape({ width: StyleConstants.FULL_WIDTH, height: StyleConstants.FULL_HEIGHT }))
          .effectMode(EdgeEffect.None)
          .backgroundColor(Color.Transparent)
          .index(0)
          .duration(400)
          .vertical(false)
          .indicator(this.arcDotIndicator
            .arcDirection(ArcDirection.SIX_CLOCK_DIRECTION)
          )
          .disableSwipe(false)
          .digitalCrownSensitivity(CrownSensitivity.MEDIUM)
          .onAnimationStart((index: number, targetIndex: number) => {
            this.innerSelectedIndex = targetIndex;
          })
          .onGestureRecognizerJudgeBegin((event: BaseGestureEvent, current: GestureRecognizer,
            others: Array<GestureRecognizer>): GestureJudgeResult => { // 在识别器即将要成功时，根据当前组件状态，设置识别器使能状态
            if (current) {
              let target = current.getEventTargetInfo();
              if (target && current.isBuiltIn() && current.getType() == GestureControl.GestureType.PAN_GESTURE) {
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
          .disableTransitionAnimation(false)
        }.height(StyleConstants.FULL_HEIGHT)
      }.width(StyleConstants.FULL_WIDTH)
    }
    .hideTitleBar(true)
  }
}